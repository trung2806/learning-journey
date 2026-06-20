# An EVPN-VXLAN Engineer's Guide to RoCEv2 AI Fabric — Technical Knowledge Foundation

## TL;DR
- An AI "backend" fabric is the same Clos/BGP/ECMP plumbing you already master, but the workload inverts every assumption you built ACI and EVPN-VXLAN around: a synchronous all-reduce stalls the *entire* GPU job behind the single slowest flow, so the design goal shifts from "statistically multiplex many small flows over an oversubscribed fabric" to "guarantee near-zero loss and bounded tail latency for a few elephant flows on a 1:1 non-blocking fabric."
- The genuinely new body of knowledge is lossless Ethernet for RDMA/RoCEv2: PFC (802.1Qbb), ECN, and DCQCN, with named knobs (DSCP 26→TC3 for data, DSCP 48→TC7 for CNP, WRED min/max ECN thresholds, PFC headroom/watchdog, MTU 9000) — plus the load-balancing problem that low flow-entropy elephant flows break ECMP, solved by adaptive routing / packet spraying (NVIDIA Spectrum-X, UEC 1.0, Broadcom DLB).
- For a Vietnam Gov/FSI sovereign-AI zone, your security/zoning instinct transfers directly: keep the lossless backend GPU fabric physically separate from frontend and storage networks, treat it as an isolated high-risk tier under Law 134/2025's national-AI-infrastructure and data-localization provisions, and use EVPN-VXLAN overlays for tenant isolation on the frontend while keeping the backend a flat, non-blocking, lossless L3 fabric.

## Key Findings

1. **Why AI fabric is different is a property of the workload, not the wires.** Distributed training runs collective operations (all-reduce, all-gather, reduce-scatter, all-to-all) that are synchronous and bulk-synchronous: every GPU must finish exchanging gradients before the next training step starts. Job completion time is dominated by the slowest flow; one dropped packet forces an RDMA go-back-N retransmit that idles thousands of GPUs. This is the opposite of the many-small-flows, loss-tolerant, oversubscription-friendly enterprise DC fabric.
2. **RoCEv2 is InfiniBand's transport over UDP/IP (dest port 4791).** It needs "lossless" Ethernet because RDMA assumes an effectively drop-free medium. That losslessness is engineered with PFC + ECN + DCQCN, not native to Ethernet.
3. **The contested frontier is congestion control and load balancing.** DCQCN tuning is genuinely hard, and the largest Ethernet AI operator (Meta) abandoned DCQCN on its 400G RoCE fabric in favor of PFC plus collective-library (receiver-driven) admission. ECMP breaks on low-entropy elephant flows; the answer is adaptive routing / packet spraying (Spectrum-X, UEC 1.0).
4. **Ethernet has overtaken InfiniBand for new AI backends** — roughly 70% of new AI infrastructure deployments now choose Ethernet/RoCEv2 — driven by hyperscaler validation, UEC 1.0 (June 2025), and AI-optimized silicon. InfiniBand remains the lowest-jitter, most deterministic option for tightly-coupled single-vendor clusters.
5. **For the EVPN-VXLAN/ACI engineer, ~70% of the skillset transfers directly** (BGP underlay, ECMP, L3 Clos, overlays, intent-based automation). What's new and critical: lossless PFC/ECN tuning, unlearning oversubscription for the backend, and a troubleshooting mindset shift from "is there a path" to "is any single flow being dropped/paused/incast."

---

## Details

### 1. First-principles: why an AI fabric is not a classic EVPN-VXLAN DC fabric

**The workload defines the fabric.** In distributed deep-learning training, the model and/or data are split across many GPUs using several parallelism strategies, each with a distinct network signature:

- **Data parallelism (DP):** the full model is replicated per GPU; each processes a different mini-batch, then all GPUs synchronize gradients with an **all-reduce** every step. High bandwidth, highly synchronous.
- **Tensor parallelism (TP):** individual layers/weight tensors are sliced across GPUs; requires all-reduce/all-gather within forward and backward passes with very tight latency coupling. Because it is the most communication-intensive, TP is kept *inside* a server over NVLink wherever possible.
- **Pipeline parallelism (PP):** model layers are split into stages across GPUs; uses point-to-point send/receive of activations between consecutive stages; latency-sensitive, with "pipeline bubbles" if a stage waits.
- **Expert parallelism (EP)** for Mixture-of-Experts: experts are spread across GPUs and each token is routed to its experts via two **all-to-all** exchanges per MoE layer — bursty, irregular, high-frequency traffic.

The recurring primitive is the **collective**. NCCL (NVIDIA) and RCCL (AMD) implement these. The key facts a network architect must internalize:

- **All-reduce** is typically implemented as a fused **reduce-scatter + all-gather**. In a **ring** all-reduce on *n* GPUs, each GPU sends ~2(n−1) chunks of size S/n; ring is **bandwidth-optimal** but its latency grows linearly with GPU count. NCCL 2.4+ added **double binary trees** which give **logarithmic latency**, better for small/medium messages and large scale. NCCL chooses ring vs. tree (and protocol LL/LL128/Simple) per-collective at runtime based on message size and topology.
- **Traffic is bursty, synchronous, and elephant-flow-dominated.** A handful of very large flows (gradients can be hundreds of MB to GBs) traverse the fabric simultaneously, then the network goes quiet during compute. There is no statistical multiplexing smoothing to rely on.
- **Tail latency = job latency.** Because every GPU blocks at the collective barrier, the slowest flow sets the pace. A single congested link, a single dropped packet (triggering retransmission), or a single PFC pause can stall the whole job. This is the "completion fallacy": aggregate throughput looks fine while one degraded flow throttles the cluster.
- **Incast** is endemic: tree-based aggregation and all-to-all create many-senders-to-one-receiver patterns that overflow a single egress buffer.

**Contrast with classic EVPN-VXLAN DC:** enterprise/cloud DC fabrics assume many independent small north-south and east-west flows, statistically multiplexed, where oversubscription (e.g., 3:1 at the leaf) is acceptable, TCP absorbs loss gracefully, and a single drop is invisible to applications. Almost every one of those assumptions is false on the AI backend.

### 2. RDMA and RoCEv2 fundamentals for the IP/MPLS engineer

**RDMA** lets one host's NIC write directly into another host's memory with **kernel bypass** and **zero copy** — no per-packet CPU involvement, no socket-buffer copies, no user/kernel context switches. The application talks to the NIC through **verbs**, posting work requests to **queue pairs (QPs)** (a send queue + receive queue), against memory regions that have been **registered** (pinned and mapped) in advance so the NIC can DMA to/from them safely.

**RoCEv2** takes the InfiniBand transport layer and encapsulates it in **UDP/IP**: the RDMA transport packet (with the InfiniBand Base Transport Header) rides inside Ethernet/IP/UDP with **UDP destination port 4791**. Because it is IP-routable, it is sometimes called "Routable RoCE." Two consequences matter for design:

- The **UDP source port** is used as an opaque per-QP flow identifier so that standard 5-tuple ECMP can spread different QPs over different paths — but all packets of one QP follow one path (preserving order).
- The RoCEv2 spec defines **ECN marking + CNP (Congestion Notification Packet)** as its congestion-signaling mechanism.

**Versus iWARP and InfiniBand:** iWARP runs RDMA over TCP (handles loss in the transport but with higher latency/complexity and weaker ecosystem); InfiniBand is a purpose-built lossless fabric with **credit-based flow control** (a sender cannot transmit without receiver buffer credits, so packets are essentially never dropped) and its own switching/subnet-manager stack. RoCEv2's advantage is that it reuses your Ethernet/IP fabric; its burden is that **Ethernet is lossy by default** and you must engineer losslessness.

**"Lossless" is a term of art.** The IBTA RoCEv2 annex itself says the underlying network "should be configured as lossless," but notes that "lossless doesn't mean that packets are absolutely never lost" — RoCEv2 has an end-to-end reliable delivery mechanism with go-back-N retransmission. The point of lossless Ethernet is to keep that expensive retransmission path off the hot path, because go-back-N on a large send window is catastrophic for collective performance.

### 3. Lossless-Ethernet control mechanisms — reference-config depth

**Priority Flow Control (PFC, IEEE 802.1Qbb)** is per-priority (per-CoS) pause. Instead of 802.3x's link-wide PAUSE (which stops everything), PFC creates up to 8 virtual lanes and pauses only the congested priority class via a pause frame carrying a timer in **quanta** (1 quanta = time to transmit 512 bits at port speed). It is a one-hop, link-level mechanism.

- **Headroom buffer math:** when a receiver hits its XOFF threshold and sends a pause, packets already in flight keep arriving until the pause takes effect. The switch must reserve **headroom** to absorb them losslessly. Headroom ≈ a function of MTU (both ends) + the sender's response time + the round-trip propagation delay of the cable. The PFC standard caps the response-time contribution at 3,840 bytes; at 10 Gbps, ~1,300 bytes per 100 m of cable round trip. Vendors compute this from configured/auto-detected **cable length** and **MRU/MTU**; a common default is 350 m. Shorter cables and lower MTU need less headroom. Conceptually, you reserve roughly one bandwidth-delay-product of headroom per lossless priority to guarantee zero loss.
- **PFC storms and deadlock:** PFC backpressure propagates hop-by-hop upstream. With cyclic buffer dependencies (CBD), this can **deadlock** — a circular wait where no packet in the cycle can move and pauses spread until large parts of the fabric freeze. Cloud operators confirm deadlocks occur in practice.
- **PFC watchdog:** monitors no-drop queues for a stuck (sustained-pause) condition; if a queue isn't draining within the watchdog interval (e.g., 100 ms default on Cisco), it drops/shuts the queue to break the storm, logs it, and auto-restores when pauses stop. Always enable it. (Meta's production PFC watchdog triggers on pauses exceeding 200 ms.)

**Explicit Congestion Notification (ECN)** marks packets (IP ECN bits → CE = 0x11) at the congested switch using a **WRED** curve *before* the buffer is full, so the endpoint slows down without any drop. The receiver, seeing CE, generates a **CNP** back to the sender.

**DCQCN (Data Center Quantized Congestion Notification)** is the de-facto RoCEv2 congestion control: it combines **ECN (the proactive, end-to-end rate signal)** with **PFC (the reactive, hop-by-hop drop-prevention backstop)**. The control loop: the **Congestion Point** (switch) marks CE via WRED when queue depth crosses **K-min**, with marking probability rising linearly to **P-max** at **K-max**; the **Notification Point** (receiver NIC) echoes a CNP; the **Reaction Point** (sender NIC) runs an α-update / multiplicative-decrease / additive-increase loop to quantize its rate.

- **The cardinal rule: ECN must trigger before PFC.** You want to spend almost all of your fabric's life on the smooth, "analog" DCQCN rate-control loop, with PFC as a rare "digital" on/off safety backstop. If ECN thresholds are set too high (never marks) or PFC thresholds too low, you invert the hierarchy — PFC leads, ECN becomes useless, and you get head-of-line blocking and pause storms. This is one of the most common RoCE deployment mistakes.
- **Tuning tradeoffs (contested):** too-aggressive ECN (K-min too low) makes senders cut rate before there's real congestion (throughput loss); too-relaxed (K-min too high) lets PFC carry the whole burden. Overly tight thresholds can cause oscillation, throughput collapse, and "ghost" tail-latency spikes. There is no universal setting — this is genuinely workload-dependent. Meta's own sweep is instructive: relaxing the CTSW ECN threshold to **5 MB** and tuning DCQCN gave only "marginally better completion time… by a small margin of 3%," while "congestion metrics like PFC became worse by 2-3x" — which is why they ultimately stopped relying on DCQCN at 400G (see §5).

**Reference configuration concepts and named knobs (by platform):**

- **DSCP/TC mapping (the canonical scheme):** RoCEv2 data → **DSCP 26 → traffic-class/qos-group 3** (lossless, PFC-enabled, priority 3); CNP → **DSCP 48 → traffic-class/qos-group 7** (strict-priority, never dropped). (Note a wrinkle: NVIDIA NIC defaults and most vendor guides use **DSCP 26**, but Cisco's AI/ML CVD examples classify RoCEv2 on **DSCP 24 (CS3)** in some documents — confirm the host NIC's actual marking and match it fabric-wide.)
- **Cisco NX-OS (Nexus 9000, MQC):** `class-map type qos match-all RDMA / match dscp 26`; `set qos-group 3`; `policy-map type network-qos … class type network-qos c-8q-nq3 / pause pfc-cos 3 / mtu 9216`; `policy-map type queuing … random-detect minimum-threshold 150 kbytes maximum-threshold 3000 kbytes drop-probability 7 weight 0 ecn`; per-interface `priority-flow-control mode on` + PFC watchdog. CNP → qos-group 7, strict priority. NX-OS 10.6 adds RoCEv2 BTH-opcode ACL filters and Dynamic Load Balancing (DLB) actions.
- **Arista EOS:** `qos map dscp 26 to traffic-class 3` / `qos map dscp 48 to traffic-class 7`; `tx-queue 3 random-detect ecn minimum-threshold 500 kbytes maximum-threshold 1500 kbytes max-mark-probability 20`; `priority-flow-control priority 3 no-drop`. EOS implements RoCEv2, DCQCN, PFC/ECN, and Cluster Load Balancing (CLB).
- **NVIDIA Spectrum / Cumulus Linux:** trust DSCP, map DSCP 26→switch priority, set ECN min/max thresholds; the simplifying command is **`nv set qos roce`** which applies validated RoCE defaults. On Spectrum-X, RoCE adaptive routing and programmable congestion control (DOCA PCC on BlueField-3) are integral.
- **MTU/jumbo frames:** run **MTU 9000** (9216 on switch) end-to-end so RDMA messages segment efficiently; mismatched MTU breaks PFC pause-frame generation in VXLAN cases.
- **ECMP entropy and hashing:** RoCEv2 elephant flows have **low flow entropy** (few, large, long-lived flows). Standard 5-tuple ECMP hashing then causes **hash collisions** — two elephants pinned to the same uplink — producing congestion and tail-latency spikes even when the fabric has spare capacity elsewhere. Mitigations: **QP scaling** (spread a NIC-pair's traffic over many QPs to raise entropy), **enhanced ECMP** (hash additionally on the RoCE destination-QP field via switch UDF), **adaptive routing / dynamic load balancing** (per-flowlet or per-packet path selection by egress-queue occupancy), and **packet spraying** (spread packets of one flow across all viable paths, reordering at the destination NIC).

### 4. AI fabric topologies and design patterns

**Three (or four/five) physically separate networks.** NVIDIA's DGX SuperPOD and AI-factory reference architectures separate: (1) the **compute/backend fabric** (East-West, GPU-to-GPU RDMA, non-blocking), (2) the **storage fabric**, (3) the **in-band management / frontend** (North-South, data ingest, checkpoints), (4) **out-of-band management**, and on NVLink systems (5) the **NVLink scale-up fabric**. The backend is built 1:1 non-blocking; the storage fabric is allowed slight oversubscription; the frontend is conventional.

**Scale-up vs. scale-out — where the network boundary sits.** *Inside* a node, GPUs talk over **NVLink/NVSwitch** (scale-up): an 8-GPU HGX H100 node has 4 NVSwitch chips providing a fully non-blocking ~900 GB/s domain (NVLink 5/Blackwell ~1.8 TB/s); a GB200 NVL72 puts 72 GPUs in one ~130 TB/s NVLink domain. Tensor parallelism is kept here because it's "free" relative to the network. *Across* nodes, the **RoCEv2/InfiniBand/Spectrum-X scale-out fabric** takes over — this is the network you design, and the boundary is the NIC. There is a 1:1 GPU-to-NIC mapping (e.g., 8× 400G NICs per 8-GPU node).

**Rail-optimized vs. rail-only vs. leaf-spine:**
- **Rail-optimized:** GPUs of the same rank/position across all servers connect to the same leaf ("rail N connects GPU N of every server to leaf N"). Because collectives like all-reduce move data predominantly between same-rank GPUs, a rail-optimized design keeps that traffic one hop away (intra-rail, forwarded at the leaf) and only crosses the spine for inter-rail traffic. This is the standard for large GPU clusters.
- **Rail-only:** eliminates the spine entirely — partitions the cluster into independent rails (e.g., 8 rails) with single-tier switches; cheaper (fewer switches/optics), good for smaller clusters, but no inter-rail path.
- **Traditional leaf-spine (fat-tree):** still used, often as the building block underneath rail optimization (NVIDIA describes its compute fabric as a "Fat-Tree Spine-Leaf Non-blocking Rail-Optimized Topology").

**Non-blocking / 1:1 subscription** is the rule for the backend. Juniper's rail-optimized JVD notes that under-provisioning leaf-spine bandwidth (e.g., creating a 2:1 oversubscription per stripe) leaves the fabric unable to carry all-inter-stripe traffic, causing congestion and loss.

**Pod / Scalable Unit (SU) sizing.** NVIDIA DGX SuperPOD is built from **Scalable Units of 32 DGX nodes** (256 GPUs for 8-GPU nodes). Reference points (H100/H200 generation): 4 SU = 128 nodes = 1,024 GPUs (32 leaf / 16 spine); 8 SU = 256 nodes = 2,048 GPUs; scaling with a spine-leaf-group / core layer to 16+ SU (4,096+ GPUs) and "beyond 64 SU with 2,000+ nodes." Each SU is rail-aligned so that intra-SU same-rail traffic is one hop.

### 5. RoCEv2 vs. InfiniBand — honest 2025-2026 architect tradeoff

**Performance.** InfiniBand NDR delivers ~1 µs-class small-message latency with the most predictable/deterministic tail behavior, due to native credit-based flow control and built-in adaptive routing. Well-tuned RoCEv2 reaches **2–5 µs** application latency and **85–95% of InfiniBand training throughput** for the majority of workloads (tier-2/3 clusters, 256–1,024 GPUs); the gap is mostly tail latency and the effort to tune PFC/ECN and load balancing. NVIDIA states Spectrum-X is "purpose-built to accelerate generative AI networking performance by 1.6x, delivering breakthrough 95% efficiency at 100,000+ GPU scale" versus roughly **60% effective bandwidth** on general-purpose off-the-shelf Ethernet.

**Operational complexity.** InfiniBand is operationally simpler *if* you accept its closed stack (subnet manager, NVIDIA NICs+switches). RoCEv2 requires disciplined DCB config on every switch and NIC and AI-specific telemetry; misconfiguration yields "the operational overhead of a lossless fabric with the performance of a lossy one." This is precisely where the EVPN-VXLAN engineer's existing Ethernet/BGP skills lower the barrier.

**Ecosystem / lock-in / cost.** InfiniBand = NVIDIA lock-in (NIC, switch, management) and a 1.5–2.5× per-port cost premium; RoCEv2 = multi-vendor Ethernet (Arista, Cisco, Juniper, Nokia, NVIDIA Spectrum, white-box/SONiC), broader optics sourcing, and typically 20–30% lower cost for comparable capacity. Multi-tenancy/isolation favors Ethernet: VXLAN/EVPN overlays + Spectrum-X performance isolation provide tenant separation that pure InfiniBand doesn't natively offer.

**Why hyperscalers increasingly use Ethernet/RoCEv2.** Following Broadcom's March 2026 earnings, industry analysis put it bluntly: "As of 2026, roughly 70% of all new AI infrastructure deployments are opting for Ethernet (RoCEv2) protocols" (Broadcom holds an estimated ~80% share of high-end Ethernet switching). Cloud providers diverge: Microsoft Azure leans InfiniBand for HPC/AI; Google Cloud is Ethernet-only; AWS offers both (with its own EFA). The decisive proof point is **Meta**, which built two parallel clusters of **24,576 NVIDIA H100 GPUs each** — one RoCE ("based on the Arista 7800 with Wedge400 and Minipack2 OCP rack switches"), one InfiniBand ("an NVIDIA Quantum2 InfiniBand fabric") — and trained **Llama 3 405B on 16,384 H100s over 54 days** on the RoCE cluster without network bottlenecks. Critically, Meta's SIGCOMM 2024 paper ("RDMA over Ethernet for Distributed AI Training at Meta Scale," Gangidi et al.) reports they **initially deployed DCQCN, found tuning intractable, and state verbatim: "We proceeded without DCQCN for our 400G deployments. At this time, we have had over a year of experience with just PFC for flow control, without any other transport-level congestion control"** — after discovering "DCQCN implementation in firmware has changed, introducing bugs and reduced visibility with problems relating to correct CNP counting." Instead they rely on PFC plus **receiver-driven (clear-to-send) admission co-designed with the collective library**, plus deep-buffer switches. This is the single most important real-world signal that DCQCN is contested at scale.

Meta also documents the **load-balancing evolution** every RoCE architect should know: plain **ECMP failed** on low flow entropy (elephant-flow collisions); **path pinning** worked until fragmented job placement caused >30% degradation; **enhanced ECMP** (UDF hash on the RoCE destination-QP field) plus **QP scaling** improved AllReduce by up to **40%**; a centralized **traffic-engineering** controller (CSPF recomputing flow placement every 30 s) beat E-ECMP by a further 5–10%; and **flowlet switching** is their stated future direction.

**Ultra Ethernet Consortium (UEC) and UEC 1.0.** Released **June 11, 2025**, UEC Specification 1.0 is a **562-page** spec (for scale, the QUIC spec RFC 9000 is ~151 pages) defining a purpose-built, open, multi-vendor Ethernet stack for AI/HPC. Its core is the **Ultra Ethernet Transport (UET)**: modern RDMA over Ethernet/IP, **packet spraying** across all viable paths, relaxed/out-of-order delivery, rapid loss recovery, sender-based congestion control tuned for µs latency, optional **packet trimming** for fast loss detection, and built-in security — all while remaining compatible with standard Ethernet optics/tooling. UEC's founding members (July 2023) are AMD, Arista, Broadcom, Cisco, Eviden (Atos), HPE, Intel, Meta, and Microsoft; NVIDIA later joined. UEC-ready silicon (e.g., Broadcom Tomahawk Ultra; Tomahawk 6 at 102.4 Tbps) is emerging in 2025-2027. What it changes: it engineers InfiniBand's native advantages (multipath, in-sequence delivery, congestion awareness) into open Ethernet, narrowing the gap "from below."

**NVIDIA Spectrum-X as "enhanced RoCE."** Spectrum-X (Spectrum-4 switches + BlueField-3/ConnectX SuperNICs) is fully standards-based RoCE plus three NVIDIA enhancements: **RoCE Adaptive Routing** (per-packet least-congested path selection, with BlueField-3 reordering out-of-order packets transparently via Direct Data Placement), **RoCE Congestion Control** (telemetry-driven, handles incast that adaptive routing can't route around), and **Performance Isolation** (one tenant/job can't congest another). It is the strongest Ethernet option today for better-than-vanilla RoCE while UEC products mature.

**SONiC and disaggregated/open networking.** SONiC (open, containerized NOS, proven at Microsoft Azure and Alibaba scale) supports RoCEv2 (PFC, ETS, ECN), EVPN/VXLAN, dynamic load balancing, and 800G, on white-box hardware (Edgecore, Celestica, Dell, NVIDIA Spectrum). It is highly relevant to **sovereign** builds because it decouples NOS from ASIC, improving supply-chain resilience and avoiding lock-in. Real sovereign-relevant proof points: SAKURAONE (Japan, 800-GPU SONiC fabric, TOP500 #49) and MKI Tokyo-1 (400G multi-tenant RoCEv2 on SONiC).

### 6. Explicit Transfer Map — what an EVPN-VXLAN/ACI engineer already knows vs. what's new

**Transfers directly (≈70% of the skillset):**
- **BGP underlay + L3 Clos**: AI backends are routed leaf-spine fabrics; eBGP (often unnumbered, IPv6 link-local) per rail/subnet is exactly your underlay design. (Meta uses BGP defaults overridden by traffic engineering.)
- **ECMP**: the mechanism is identical; what changes is that it *fails differently* (see below).
- **VXLAN/EVPN overlays**: still used — on the **frontend** for tenant/VRF/MAC isolation, and RoCEv2 can run over a VXLAN fabric (with ECN/CNP carried in inner/outer headers per Cisco's NX-OS RoCE-over-VXLAN guidance). The "underlay = lossless Ethernet, overlay = tenant isolation" pattern is the modern multi-tenant AI answer.
- **ACI policy/automation and intent-based mindset**: transfers cleanly to intent-based AI-fabric automation (Cisco Nexus Dashboard Fabric Controller / Hyperfabric AI, Arista CloudVision/AVD, NVIDIA-validated designs). You think in templates and validated designs, not per-box CLI — same as ACI.
- **QoS exists in both**: you already do classification, marking, queuing, strict-priority.

**Transfers with modification:**
- **QoS becomes lossless QoS**: classification/marking/queuing are familiar, but PFC no-drop classes, ECN/WRED thresholds, and DCQCN are a new, far more consequential discipline. In enterprise QoS a misconfig degrades a class; here it stalls a multi-million-dollar GPU job.
- **ECMP intuition**: you trusted ECMP to spread many flows evenly. With low-entropy elephant flows it collides and you must add QP scaling / enhanced-ECMP / adaptive routing / packet spraying.
- **Buffering**: deep buffers and headroom math (BDP per lossless priority) replace "default buffers are fine."

**Genuinely new (must learn):**
- **RDMA/RoCEv2 semantics**: QPs, verbs, memory registration, kernel bypass, go-back-N — a transport model unlike anything in MPLS/EVPN.
- **Lossless Ethernet engineering**: PFC headroom, PFC watchdog, deadlock avoidance, ECN-before-PFC ordering, DCQCN tuning.
- **Unlearning oversubscription** for the backend: 1:1 non-blocking is mandatory; the "design for the average, oversubscribe the leaf" instinct is actively harmful here.
- **Topology semantics**: rails, stripes, rail-alignment, SU sizing, scale-up vs scale-out boundary.
- **The troubleshooting inversion**: classic NOC asks "is there a path / is the link up / is utilization high?" The AI-fabric question is **"is any single flow experiencing drops, pause, or incast?"** — because one degraded flow throttles the whole job while aggregate utilization looks healthy.

### 7. Observability and operational reality

**What to monitor (and why it differs from classic NOC):**
- **PFC pause frames** per port, **per priority** — the leading indicator of backpressure and potential storms. Watchdog triggers on sustained pauses (Meta alarms on pauses >200 ms).
- **ECN marks / CNP counts** per egress queue — confirms DCQCN is doing its job *before* PFC; misalignment shows here.
- **Buffer/queue occupancy and depth distribution** — incast and microburst detection (Meta alarms at 80% buffer utilization, a threshold they report not having breached in production).
- **Drops, link flaps, RDMA NACKs / out-of-sequence (OOS) counters, local ACK timeouts** — any of these means retransmission and stalled collectives.
- **Job Completion Time (JCT)** correlated with network events — the only metric that matters to the customer. Arista CloudVision UNO and similar platforms build a "network data lake" to correlate ECN marks/PFC pauses/RDMA errors with JCT, so you can pinpoint whether a slow job is a congested link, a bad NIC, or a server.
- **Streaming telemetry** (gNMI/gRPC at 1-second or sub-second granularity) is the norm, not SNMP polling.

**The cultural shift:** "Running a lossless fabric blind is a failure mode of its own." The most common operational failure is not a misconfigured PFC — it's **operating without the telemetry that would reveal PFC misbehaving**. Aggregate utilization is a misleading health metric; you must watch for the single degraded flow and for incast at receivers.

### 8. The Sovereign-AI Worked Example — a Vietnam Gov/FSI sovereign AI training+inference zone

**Scenario.** An isolated sovereign-AI tier inside a National Data Center / FPT-AI-Factory-style buildout — e.g., an NVIDIA H100/H200/B200-based GPU cluster for training and serving Vietnamese-language and Gov/FSI models, operated as a high-assurance, in-country zone. Concrete Vietnamese anchors exist: **FPT AI Factory** (a USD 200M build that "will serve as a sovereign cloud," thousands of H100s live since Jan 2025, "all data stored and processed within Vietnam," echoing Jensen Huang's "Vietnam's AI should be processed here, built here, operated here"); **Viettel's Hoa Lac 2** (22× DGX B200, ~1.5 ExaFLOPs, Uptime-certified, Viettel Cloud sovereign stack); and the **National Data Centre** under the Ministry of Public Security (operational Aug 19, 2025).

**Regulatory drivers (network/segmentation-relevant).** Vietnam's **Law on AI No. 134/2025/QH15** (passed 10 Dec 2025, effective 1 Mar 2026) is the first standalone AI law in Southeast Asia. The network-relevant provisions:
- **Chapter III "Infrastructure development and assurance of national AI sovereignty" (Articles 16–18):** designates **National AI Infrastructure as strategic infrastructure coordinated by the State**; high-risk AI systems are expected to be deployed on this unified, secure ecosystem under State oversight.
- **High-risk AI** (finance/FSI, healthcare, education, critical infrastructure, government decisions) requires conformity assessment, registration in the **National AI Database**, human oversight, and continuous monitoring before deployment.
- **Data localization / in-country processing:** Vietnam's broader framework (cybersecurity-law data-localization, the Data Law's cross-border transfer impact assessments, and draft AI decrees prioritizing **state-invested / in-Vietnam infrastructure for "important AI applications"**) pushes Gov/FSI training data and models to stay and be processed in-country. The defense/state-security carve-out (Article 2) means truly classified workloads sit outside the general regime in even more isolated enclaves.

**Network/architecture design decisions (this is where your strengths apply):**

1. **Treat the lossless backend GPU fabric as its own security zone — physically separate, ideally air-gapped from external networks.** Keep the East-West RoCEv2 backend fabric on dedicated switches and cabling, with **no routed path to the internet or to general enterprise networks.** This satisfies both the performance requirement (flat, non-blocking, lossless, no shared congestion) and the sovereignty/security requirement (data can't leave the perimeter).

2. **Deliberately segment the three/four networks.** Backend (GPU RDMA, 1:1 non-blocking, lossless, no overlay), storage (RoCEv2 or RDMA, slight oversubscription tolerated), frontend/in-band management (conventional, where EVPN-VXLAN tenant isolation lives), and OOB management (fully isolated). The backend should connect to frontend/storage only through controlled, inspected boundaries (e.g., the CPU/DPU host, BlueField-3 DPUs that "offload, accelerate, and isolate" network/storage/security) — **not** via a flat L2 bridge. This is exactly your ACI EPG/contract zoning instinct applied to AI.

3. **Multi-tenant isolation if the sovereign zone is shared** (e.g., multiple ministries or FSI tenants on one National-DC GPU pool): use **EVPN-VXLAN overlays for tenant VRF/MAC isolation on the frontend/management plane**, and **Spectrum-X performance isolation (or UEC-class mechanisms)** on the backend so one tenant's collective traffic cannot congest another's. For the strongest separation (classified vs. commercial), prefer **physical partitioning into separate rails/SUs or separate fabrics** over logical-only isolation — defense-in-depth aligned to the high-risk classification.

4. **Choose the transport for sovereignty, not just speed.** For a sovereign build, **RoCEv2 over open/multi-vendor Ethernet (optionally SONiC on white-box)** is the architecturally sound default: it avoids single-vendor (InfiniBand/NVIDIA) lock-in, improves supply-chain resilience under sanctions/availability risk, runs on skills your team already has, and operates without cloud-based management planes or vendor telemetry callbacks that could exfiltrate data. Reserve InfiniBand for a tightly-coupled, single-vendor training block only if jitter-sensitive workloads justify the lock-in. Spectrum-X is the middle path (enhanced RoCE) if you want NVIDIA's performance with Ethernet's ecosystem.

5. **Control-plane independence.** Sovereign fabric automation should run **on-premises** (NDFC/CloudVision/SONiC controllers hosted in-country), with no dependency on external SaaS, so the fabric meets data-residency and operates even when disconnected from the internet.

6. **Apply lossless discipline as a security-grade control.** Document and validate PFC/ECN/DCQCN config as part of the conformity/assurance dossier (the AI Law's monitoring obligations), and stream PFC/ECN/CNP/JCT telemetry into an in-country observability stack — both for performance and for the auditable "continuous monitoring" the high-risk regime expects.

---

## Recommendations

**Stage 0 — Build the mental model (before any design).** Internalize the transfer map (§6): accept that the backend fabric inverts your oversubscription instinct and that "is any flow paused/dropped/incast" replaces "is there a path." Read the Meta SIGCOMM 2024 paper and NVIDIA DGX SuperPOD + Spectrum-X reference architectures as your two anchors (one Ethernet-at-scale operator truth, one vendor reference).

**Stage 1 — Lock the non-negotiables.** Backend = 1:1 non-blocking rail-optimized leaf-spine; MTU 9000 end-to-end; single lossless priority for RoCEv2 (DSCP→TC3) + strict-priority CNP (DSCP 48→TC7); PFC on the RoCE class only; PFC watchdog on; ECN/WRED tuned to mark *before* PFC. Start from vendor-validated defaults (Cisco AI/ML CVD WRED 150KB/3000KB; Arista/NVIDIA `nv set qos roce`) rather than hand-tuning.

**Stage 2 — Solve load balancing explicitly.** Don't trust plain ECMP. Specify QP scaling + enhanced-ECMP (UDF hash on dest-QP) at minimum; prefer adaptive routing / packet spraying (Spectrum-X, Broadcom DLB, or UEC-class) for clusters beyond a single SU. Benchmark with NCCL all-reduce/all-to-all, not synthetic streaming.

**Stage 3 — Decide DCQCN posture from evidence.** Begin with DCQCN at relaxed ECN thresholds. Watch PFC counters: if tightening ECN to avoid PFC collapses collective throughput (as Meta found — 3% gain for 2–3× worse PFC), be prepared to relax ECN and lean on deep buffers + collective-library/receiver-driven admission. Treat DCQCN tuning as an empirical, per-workload exercise — not a fixed recipe.

**Stage 4 — Sovereign zone specifics.** Physically separate and (where mandated) air-gap the backend; segment backend/storage/frontend/OOB; use EVPN-VXLAN for frontend tenant isolation + Spectrum-X/UEC performance isolation on the backend; host all fabric automation/telemetry in-country; default to RoCEv2-on-Ethernet (consider SONiC/white-box) for supply-chain and lock-in resilience; document lossless config + stream JCT/PFC/ECN telemetry as part of the Law 134/2025 high-risk monitoring dossier.

**Benchmarks/thresholds that should change the design:**
- If sustained PFC pause counts rise (especially upstream leaf→spine) or watchdog fires → you have a storm/deadlock risk: relax ECN, add buffer, or revisit topology/load-balancing.
- If NCCL all-reduce achieves <~85–90% of line-rate roofline → load-balancing (ECMP collisions) is the likely culprit before congestion control.
- If tail latency / JCT variance is unacceptable for jitter-sensitive workloads and you can accept lock-in → InfiniBand or Spectrum-X over vanilla RoCE.
- If cluster grows beyond a single SU / multi-tenant → mandate adaptive routing + performance isolation, and physical partitioning for classified tenants.

## Caveats

- **DCQCN best practice is genuinely unsettled.** Vendor guidance (Cisco/Arista/NVIDIA/Juniper) presents DCQCN as the standard, but Meta's production experience (abandoning DCQCN on 400G in favor of PFC + receiver-driven admission) shows the largest operators diverge. Treat any single "recommended" threshold set as a starting point, not gospel.
- **Adaptive-routing approaches differ and partly compete** (NVIDIA Spectrum-X per-packet AR + NIC reordering; Broadcom DLB flowlets; UEC packet spraying; Meta's path pinning → enhanced-ECMP → traffic engineering → flowlet evolution). There is no single industry-standard method yet; some (UEC) are still maturing in silicon (2026-2027).
- **DSCP marking is not universally consistent.** The common scheme is DSCP 26→TC3 (data) / DSCP 48→TC7 (CNP), but some Cisco AI/ML documents use DSCP 24 (CS3) for RoCEv2. Always verify the host NIC's actual marking and enforce it fabric-wide; a mismatch silently breaks losslessness.
- **Vietnam AI Law implementing detail is still emerging.** Law 134/2025 takes effect 1 Mar 2026, but key specifics (the high-risk list, the national-AI-infrastructure hosting/localization rules) depend on government decrees still being finalized in early 2026; early drafts softened a strict "must host on local infrastructure" mandate to a "prioritize state-invested/in-Vietnam infrastructure" framework. Confirm against the final decrees before committing compliance-driven architecture.
- **Several market/share figures (e.g., "~70% of new AI deployments choose Ethernet," "85–95% of InfiniBand throughput," the 1.5–2.5× IB cost premium) come from vendor commentary and analyst/industry blogs**, not peer-reviewed sources; directionally consistent across many sources but treat the precise percentages as indicative.
- Some named Meta switch models (Arista 7800, Wedge400, Minipack2, NVIDIA Quantum2) come from Meta's engineering blog, not the SIGCOMM paper itself, which uses generic role names (RTSW/CTSW/ATSW).