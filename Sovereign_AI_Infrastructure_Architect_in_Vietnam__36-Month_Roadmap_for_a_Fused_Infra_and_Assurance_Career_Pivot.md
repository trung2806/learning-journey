# Sovereign AI Infrastructure Architect (Security/Assurance Overlay) — Vietnam-Only 36-Month Roadmap for Trung

## TL;DR
- **The bet is sound but front-loaded on infrastructure, not assurance.** Vietnam's AI-data-center buildout is real and capital-heavy now (US$7B+ in announced AI-DC investment across Viettel, FPT, CMC, VNG, and the KBC/G42 consortia), so the *infra spine* of your fused role has near-term demand; the *AI-assurance/compliance overlay* only becomes operationally mandatory in 2027 (general AI compliance 1 March 2027; finance/health/education 1 September 2027). Sequence accordingly: lead with infra, let assurance mature into a 2027 monetization wave.
- **Your moat is the fusion, not either half alone.** A generic GPU-infra engineer competes with cheaper code-native juniors; a generic compliance consultant has no deal flow until the implementing decrees fully land. Your EVPN-VXLAN/ACI + Gov-scale Checkpoint + Bộ Công an clearance is a rare credential that lets you own the *secure sovereign AI fabric* design conversation — the one buyers (DC operators, SIs, Gov, banks, EVN) cannot easily source.
- **Concentration risk is the real threat, not lack of demand.** Per CBRE (via VietnamPlus), "five major players… make up 97% of total capacity… Viettel IDC leads with a 41% market share (42 MW), followed by VNPT (25 MW)." The serious buyer set is small and state-anchored (Viettel, FPT, CMC, VNPT/VNG, MoPS/National Data Center, top banks, EVN). Treat this as a relationship-and-reference game, not a job-board game. Keep your SI seat warm 12–18 months while you build proof artifacts; do not quit early.

## Key Findings

**Market reality (Part A):**
1. Per the US International Trade Administration (trade.gov), citing a Vietnam MOST report, Vietnam has "41 active data centers with a total power capacity of 221MW… 12 data center investors." Mordor Intelligence projects the market from "524.7 MW in 2025… to reach 950.4 MW by 2030, growing at a CAGR of 12.61%," with colocation revenue rising from USD 588.9M (2025) to USD 1,403.4M (2030). Capacity is highly concentrated in five state-anchored operators (~97%).
2. The AI-specific buildout is genuine and well-funded: FPT AI Factory (NVIDIA H100/H200, expanding to HGX B300, US$200M), Viettel (11 DCs, >350 MW planned, ~800 supercomputers + 6,000 GPUs with NVIDIA), VNG/GreenNode (H100 clusters, STT JV), CMC (US$250M hyperscale, expandable to 120 MW), plus the NVIDIA–government R&D/AI-data-center MoU (Dec 2024) and the Bộ Công an National Data Center No.1 (inaugurated Aug 2025).
3. Regulatory timing is the linchpin: AI Law 134/2025/QH15 effective 1 March 2026; first implementing decree (Decree 142/2026/ND-CP) effective 1 May 2026; National AI Committee operational by 1 July 2026; high-risk AI list expected Q3 2026; compliance deadlines March 2027 (general) and Sept 2027 (finance/health/education).
4. Cybersecurity market: P&S Intelligence values it at "USD 322.6 million in 2025… projected to reach USD 926.8 million by 2032… CAGR of 16.3%"; Mordor puts 2026 at USD 355.36M growing at 14.55% to USD 700.87M by 2031. Workforce shortfall and BFSI demand are acute (see A4). AI-specific security is still nascent — it layers on top of an already-underserved cybersecurity base.
5. Compensation: senior architect bands are strong and rising. Robert Walters Salary Survey 2026 (released 25 Nov 2025) states "specialist roles in AI, data, and fintech may see 15–25 per cent salary increases, while general software roles typically receive 5–15 per cent." AI-specific security and infra command premiums.
6. Risks: GPU export-control/lead-time volatility, power constraints, capex cyclicality, and the gap between law-on-paper and operational decrees.

**Skills calibration (Part B):** Your profile (low-code, deep-expertise, decision-maker, hardware/systems pull) maps cleanly onto an architect-level path. Python stays at literacy. The transfer base is your DC/SDN expertise → GPU fabric (RoCEv2/RDMA). Rent GPU hours; do not buy hardware.

## Details

### PART A — VIETNAM MARKET DEEP DIVE

#### A1. The data-center / AI-factory landscape
Vietnam's DC market is small by regional standards but on a steep ramp. As of August 2025 there were "41 active data centers with a total power capacity of 221MW… 12 data center investors" (US ITA/trade.gov, citing Vietnam MOST), spanning Viettel IDC, VNPT, FPT Telecom, CMC Telecom, NTT DATA, ST Telemedia, and international players. Mordor Intelligence projects capacity from "524.7 MW in 2025… to 950.4 MW by 2030, growing at a CAGR of 12.61%." The market is highly concentrated: per CBRE (via VietnamPlus), "five major players… make up 97% of total capacity… Viettel IDC leads with a 41% market share (42 MW), followed by VNPT (25 MW)." Construction cost is among the world's lowest at ~US$7M/MW.

The AI-factory layer is where the real signal is:
- **FPT AI Factory**: NVIDIA partnership announced April 2024 (US$200M), live January 2025 with H100, scaled through H200, and announced an HGX B300 buildout March 2026; "sovereign cloud" framing; 43 AI-cloud services to 18,000+ users. FPT positions all data as stored/processed in Vietnam ("technological sovereignty").
- **Viettel**: planning 11 large-scale DCs (>350 MW, ~40% of national capacity); NVIDIA collaboration for ~800 supercomputers + 6,000 GPU cards; An Khanh DC (17.5 trillion VND / US$665M, Tier III, Aug 2025); 140 MW Tan Phu Trung hyperscale (completion 2030).
- **VNG/GreenNode**: merged cloud + AI infra under GreenNode; H100 clusters; STT JV building STT VNG HCMC 1 & 2 (60 MW, operational H1 2026); NVIDIA Cloud Partner.
- **CMC**: US$250M hyperscale (30 MW → 120 MW, approved July 2025); US$500M across Vietnam/Japan to 2028; Samsung C&T JV (US$1.3B).
- **National/sovereign**: NVIDIA–Vietnam government MoU (Dec 2024) for AI R&D + AI data center; NVIDIA acquired VinBrain; Bộ Công an National Data Center No.1 inaugurated August 2025 (>20 ha, ~US$639M per ERP.today), with National Data Center No.2 planned for HCMC from 2026.
- **Foreign/consortium**: G42 (UAE) + Microsoft/FPT/VinaCapital US$2B "AI Factory"; KBC + AIC + VietinBank ~US$2B AI DC (MoU Nov 2025); sector total >US$7B (ERP.today).

Realistic pipeline 2026–2029: continued hyperscale + AI-factory commissioning, edge buildout, and a maturing sovereign tier — but lumpy, capex-cyclical, and power-gated.

#### A2. The realistic buyer set
This is your binding concern, and the honest answer is: **the serious buyer set is small, concentrated, and state-anchored.** Realistic buyers/contractors for a senior fused architect:
- **DC/AI-cloud operators**: FPT (Smart Cloud/AI Factory), Viettel IDC, VNG/GreenNode, CMC, VNPT. These hire/contract for fabric design, sovereign-tier isolation, and increasingly AI-workload security.
- **System integrators**: FPT IS, CMC, HPT — the channel through which most Gov/FSI/Utility delivery actually flows. FPT IS built the Bộ Công an National Data Center integration; HPT and CMC have deep Gov/bank relationships and named MSSP practices (HPT was named in VNISA Golden Key 2024; CMC serves 150+ government and banking clients).
- **End-users / state enterprises**: MoPS/National Data Center, EVN (utility), top banks (Vietcombank, MB, Techcombank), ministries.
- **Security-specialist vendors**: Viettel Cyber Security (spun out Apr 2025, ~500 specialists), CMC Cyber Security, FPT IS Security/VSEC.

Honest read: there are probably only a few dozen organizations in Vietnam that will ever seriously buy "sovereign AI infrastructure architecture with a security/assurance overlay" at senior level, and a handful that buy it repeatedly. Channels are (a) employment at an operator/SI, or (b) consulting/SI-delivery subcontracting. This is a relationship-and-reference market, not a volume market — which actually favors your Gov-clearance + flagship-reference profile.

#### A3. Regulatory drivers and timing — when the assurance market goes live
- **AI Law No. 134/2025/QH15**: passed 10 Dec 2025, effective 1 March 2026. Risk-based (high/medium/low), EU-AI-Act-inspired, with conformity assessment for high-risk systems, National AI Database registration, human-oversight requirements, and local-representative obligations for foreign providers. Chapter III explicitly addresses "national AI sovereignty" and national AI infrastructure (Articles 16–18, defining national AI infrastructure as "strategic infrastructure… a unified, open and safe ecosystem"). Per Pertama Partners, "organizations face fines of up to VND 2 billion (approximately USD 75,800) per violation. Individuals can be fined up to VND 1 billion (approximately USD 37,900)," with revenue-based fines for serious violations.
- **Implementing instruments**: Decree 142/2026/ND-CP (first implementing decree) issued 30 April 2026, effective 1 May 2026. National AI Committee + national AI portal due operational 1 July 2026. The Prime Minister's high-risk AI list was not yet published as of May 2026 (expected Q3 2026). Healthcare, education, and finance are treated as high-risk by default.
- **Grace/ramp**: per Pertama Partners, "18 months for healthcare/education/finance" (1 Sept 2027) and "12 months for other sectors" (1 March 2027).
- **Data localization / protection stack**: PDPL (Law 91/2025/QH15) effective 1 Jan 2026 + Decree 356/2025/ND-CP (replaces Decree 13/2023); Law on Data (effective 1 July 2025, core/important/other data classes); Cybersecurity Law data-localization; cross-border transfer impact assessments to MoPS.

**Interpretation:** the assurance/compliance market is NOT yet operational in mid-2026 — the high-risk list and conformity-assessment machinery are still being stood up. This validates Trung's own finding that his compliance sketch was "un-actionable." The window where assurance becomes *mandatory and monetizable* is roughly Q3 2026 (high-risk list) → 2027 (deadlines bite, especially finance/health). Build assurance capability now; expect to sell it from 2027.

#### A4. Cybersecurity / AI-security services market
P&S Intelligence values the market at "USD 322.6 million in 2025… projected to reach USD 926.8 million by 2032… CAGR of 16.3%"; Mordor puts 2026 at USD 355.36M growing 14.55% to USD 700.87M by 2031. Services outpace products as orgs outsource to bridge a severe talent gap: per Vu Ngoc Son, Head of Research/Technology Development at the National Cybersecurity Association (NCA), at Vietnam Security Summit 2025 (23 May, HCMC), "Vietnam is expected to face a shortage of more than 700,000 specialized cybersecurity personnel in the next three years… about 56% of agencies and businesses lack sufficient information technology and information security personnel." The NCA Technology Committee's December 2024 survey of 4,935 organizations found "the total number of incidents estimated to exceed 659,000… 46.15% of agencies and businesses reported experiencing at least one cyberattack in the past year." MoPS A05 added that "critical units alone received over 74,000 cyberattack warnings, including 83 targeted APT campaigns."

BFSI is the demand engine (~71% of attacks). The DC-security sub-niche is tiny but fast-growing (Credence: USD 4.52M in 2023 → ~USD 15.58M by 2032, 16.73% CAGR). AI-specific security (securing LLM/RAG/agentic systems, AI-driven attacks) is genuinely nascent in Vietnam — it sits on top of an underserved general cybersecurity base. This is good news for timing: you can build AI-security architecture credibility before the field is crowded, anchored to a cybersecurity market that already has structural shortage and pricing power.

#### A5. Compensation and career-track reality
Vietnam senior architect compensation is strong and rising. Robert Walters Salary Survey 2026 states "specialist roles in AI, data, and fintech may see 15–25 per cent salary increases, while general software roles typically receive 5–15 per cent."
- **Senior/Principal Solution Architect at a large SI/tech corp**: ITviec puts Solution Architect at ~73.95M VND/month (2024–25 edition, 5.5 yrs); CTO/CIO/VPoE median 101.25M VND/month (2025–26 edition). Robert Walters' MNC-segment Solutions Architect band runs US$70–96k/yr (~140–200M VND/month); CTO US$120–240k/yr. Realistic blended band: ~70–150M VND/month (~US$2,800–6,000).
- **Head of architecture / infra director at state enterprise/bank** (EVN, VCB, MB, Viettel): thinnest public data; triangulated ~80–180M VND/month (~US$3,200–7,200), with SOEs lower-cash/higher-allowance and top private banks and Viettel at the upper end.
- **Senior security architect**: ITviec Security Engineer/Consultant median 60.6M VND/month (8 yrs); senior security architect/CISO band ~60–120M VND/month, top performers >VND 2B/yr.
- **Independent consultant**: defensible local day rate ~US$300–700/day, ~US$500–1,000+/day for international/specialized AI-security; specialist AI/ML & cybersecurity carry a 40–60% premium over generalist devs. Project economics require a handful of repeatable references to sustain pipeline.

**The moat differentiator**: a moat-protected senior who can own the *secure sovereign AI fabric* design + Vietnam-AI-Law conformity readiness commands the top of these bands and (more importantly) is sourced by name rather than by job board. A generic AI-infra engineer competing with cheaper, code-native juniors sits at the bottom.

#### A6. Honest risk and timing assessment — what could make this bet fail
- **GPU cost/availability volatility**: US export controls divert VN operators to A800/H800/MI250-class parts, stretching lead times (reports of 26-week+ waits) and inflating costs ~35%; DGX backlogs historically 36–52 weeks.
- **Power constraints**: Vietnam's reserve margin is thin (reported peak demand ~72,000 MW vs ~76,000 MW installed, July 2025; reported brownouts), and AI racks (20–120 kW) strain facility design. Globally ~20% of DC projects face grid-driven delays (IEA). This is a real gating factor on the VN buildout pace.
- **Capex lumpiness/cyclicality**: AI-DC investment is bursty; an AI-spending pullback or stranded-asset scenario would hit the infra-spine demand first.
- **Regulatory slippage**: decrees and the high-risk list could slip, delaying the assurance monetization window past 2027.
- **Concentration risk**: if 2–3 anchor buyers freeze hiring/projects, the thin buyer set bites hard.
- **Mitigation**: the fused position hedges — infra demand is near-term, assurance is 2027+, and the Gov/security brand keeps you sourced even in a downturn.

### PART B — INTEGRATED 36-MONTH ROADMAP

Design principles: architect/literacy level (read, specify, review, decide — not production coding); Python literacy only; infra spine first, assurance overlay maturing into 2027; rent GPU hours, never buy; every phase ships a moat-proof, sellable artifact; keep the SI seat and Gov/security brand warm; ~20h/week is the hard ceiling (~1,040h/yr).

#### PHASE 1 (Months 0–12): Convert DC/SDN mastery into GPU-fabric authority; stand up the fused reference architecture

**Q1 (Months 0–3) — GPU fabric as an extension of what you already own.**
- Learning objectives: RoCEv2/RDMA deeply (PFC, ECN, DCQCN, lossless Ethernet, jumbo frames, ECMP) and *why AI fabric differs from your EVPN-VXLAN DC fabric* — synchronous all-reduce gradient exchange means a 1% packet drop can idle a 1,024-GPU cluster; RoCEv2 vs InfiniBand tradeoffs (RoCEv2 delivers ~85–95% of InfiniBand throughput at lower cost, and is hyperscaler-standard at Meta/Microsoft/AWS). Map directly from your CCIE-DC-adjacent knowledge.
- Labs (no GPU cluster needed): build a lossless-Ethernet topology in simulation; tune PFC/ECN; read NVIDIA reference architectures (DGX SuperPOD / Spectrum-X) as design references.
- Artifact: a written "EVPN-VXLAN engineer's guide to RoCEv2 AI fabric" — your first public credibility piece.
- Tripwire: if RoCEv2/fabric material doesn't click as an extension of your DC expertise within the quarter, reassess infra-spine fit (low risk given tested conviction).

**Q2 (Months 3–6) — GPU cluster orchestration and serving, at architect literacy.**
- Learning objectives: Kubernetes-for-GPU (NVIDIA GPU Operator, MIG partitioning, scheduling/bin-packing, topology-aware placement); model serving concepts (vLLM, throughput vs latency, batching, KV-cache) at a *specify-and-measure* level, not implementation.
- Labs: rent GPU hours (RunPod/Vast/Lambda) to stand up vLLM, measure tokens/sec and latency under load; document the cost/performance envelope. Your GTX 1650 stays for security labs only.
- Artifact: a serving-performance measurement brief (rented-GPU benchmarks) + a GPU-cluster scheduling design note.

**Q3 (Months 6–9) — DC-for-AI physical design + sovereign/isolated tier.**
- Learning objectives: power/cooling for AI (liquid cooling, direct-to-chip, rear-door HX, PUE/WUE), rack densities 20–120 kW, VN power constraints; sovereign-tier design (air-gap/isolation, data residency, in-country processing) tied to the AI Law's "national AI sovereignty" provisions (Articles 16–18).
- Artifact: a sovereign-tier reference design for a Gov/FSI AI zone (zoning, isolation, power/cooling envelope), building on your water-cooled-cabinet vision.

**Q4 (Months 9–12) — Fuse infra + security into the flagship reference architecture v1.**
- Learning objectives: the 8-layer AI security model (governance, identity, ingress/prompt, model, knowledge/data, tool/action, egress, observability); AI gateway, dual-LLM pattern, action broker PEP/PDP, identity-bound retrieval, guardrails. Close your IAM/PAM/Zero-Trust gap to *architect-decision* level here — this is the one legacy-adjacent gap worth closing because it's the spine of AI security.
- Labs: AI red-team on GTX 1650 (garak/PyRIT/promptfoo vs local Ollama) mapped to OWASP LLM Top 10 (2025: prompt injection #1, plus new System Prompt Leakage and Vector/Embedding Weaknesses entries) — framed as CI-gate design, not as a career pull.
- **Flagship artifact**: Fused Reference Architecture v1 (infra spine + 8-layer security overlay) for a Gov/FSI AI system, building on your existing reference-architecture doc.
- Talk: submit to a VN venue (VNNIC, Vietnam Security Summit/VNISA, FPT Tech Day).
- **Phase 1 decision gate**: Have you (a) produced a fabric guide + serving brief + sovereign-tier design + fused RA v1, and (b) had ≥1 real conversation with a buyer (operator/SI/Gov) about it? If yes, proceed and start tilting toward assurance. If no buyer contact at all after 12 months, that's the tripwire to re-examine the buyer thesis — not the skills.

#### PHASE 2 (Months 12–24): Layer the assurance overlay as the AI Law machinery goes live; convert artifacts to deal flow

- Learning objectives: NIST AI RMF (Govern/Map/Measure/Manage) and ISO/IEC 42001 (AIMS, Annex A's 38 reference controls, certification path; auditor qualification under ISO/IEC 42006:2025) at a *map-and-specify* level; threat modeling for AI (MAESTRO, STRIDE-for-AI); conformity-assessment readiness mapped to Decree 142 and the Q3-2026 high-risk list. Use the published NIST AI RMF ↔ ISO/IEC 42001 crosswalk as your Rosetta Stone.
- Leverage: your competent compliance sketch + the fact that ~70% of EU-AI-Act conformity work transfers to Vietnam; you build the crosswalk once and reuse it.
- **Flagship artifact**: a Vietnam-AI-Law (134/2025) compliance crosswalk for a Gov/FSI AI system — risk classification, data residency, immutable WORM audit trail, human-oversight thresholds + kill-switch — now *actionable* because Decree 142 and the high-risk list exist. Fuse with RA v1 into a single "secure sovereign AI fabric + conformity readiness" package (your M1+M5 pipeline).
- Practice: rented-GPU red-team-as-CI-gate demo; identity-bound retrieval reference.
- Brand: 2–3 blog posts; a second talk; position on LinkedIn as "sovereign AI infrastructure + assurance" with the Bộ Công an reference as anchor.
- **Phase 2 decision gate / tripwires**: by month ~18 (post high-risk list), are buyers responding to the assurance angle? Target: ≥1 paid engagement or a concrete internal mandate at your SI to lead an AI-fabric or AI-assurance initiative. If the assurance market is still inert at month 24 (decrees slipped), stay weighted to infra and treat assurance as optionality. Income-floor tripwire: if the 12–18 month dip approaches with no monetization signal, lean back on the SI role and extend timeline rather than forcing the pivot.

#### PHASE 3 (Months 24–36): Establish the fused position; choose employment vs independent consulting

- Learning objectives: deepen the differentiator — agentic-AI security (OWASP Agentic Top 10, announced at Black Hat Europe 2025), multi-tenant sovereign-cloud isolation, AI observability/SOC integration; conformity-assessment-body landscape as it forms. Maintain infra currency (Blackwell-class power/cooling, 800 VDC trends) at literacy.
- **Flagship artifact**: a delivered or reference-grade *secure sovereign AI fabric* design + AI-Law conformity package for one named sector (Gov, FSI, or utility), ideally tied to a real project.
- Positioning decision: (a) senior/principal architect at an operator/SI (FPT, Viettel, VNG, CMC) or head-of-architecture at a bank/EVN — comp ~80–180M VND/month; or (b) independent/boutique consultant at ~US$500–1,000+/day requiring ~3+ repeatable references. Given concentration risk, employment-with-a-marquee-operator first, then optional independence once references compound, is the lower-variance path.
- **Phase 3 gate**: by month 36, do you hold the fused title (or its functional equivalent) and ≥2 reference engagements? If yes, the moat bet has paid off. If only the infra half landed, you still have a strong, well-paid infra-architect position and assurance as a growing call option.

#### Moat-warm thread (all phases)
- Keep the Bộ Công an / EVN / hospital / school / HITC references as the anchor narrative; lead every artifact and talk with the Gov-scale credential.
- Stay present in the VN security community (Vietnam Security Summit/VNISA, NCA), Cisco UG, and VNNIC — but as a *sovereign-AI-infra* voice, not a legacy-DC voice.
- LinkedIn: reposition deliberately from "DC/Cloud Manager" to "Sovereign AI Infrastructure Architect (security/assurance)."
- Do NOT deepen Cisco ACI or Checkpoint further — they're sunk moat; maintain, don't invest.

#### Anti-patterns to avoid
- **Tutorial hell / cert chasing**: resist collecting GPU or cloud certs for their own sake; ship artifacts instead. Optional, high-signal exceptions only (e.g., one AI-governance or ISO 42001 credential if a buyer explicitly values it).
- **Over-polishing code/TDD craft**: you've already over-invested here; cap Python at literacy.
- **Conviction-without-contact**: the single biggest risk is building artifacts no buyer sees — force buyer contact every phase.
- **Moat decay**: don't let the Gov/security brand go quiet during the build.
- **Burnout**: 20h/week is the ceiling, not a floor; protect the income floor and the SI seat for 12–18 months.

## Recommendations
1. **Months 0–3 — start at the fabric, not the model.** Build the RoCEv2/RDMA "EVPN-VXLAN engineer's guide to AI fabric" and publish it. This converts your existing mastery into the scarcest credential in the VN AI-infra market fastest. Benchmark to advance: piece published + first informed readership / one buyer-side conversation.
2. **Months 3–9 — rent, measure, design.** Stand up vLLM on rented GPUs and document the cost/performance envelope; produce the sovereign-tier Gov/FSI design. Do not buy hardware. Benchmark: a serving-benchmark brief + a sovereign-tier design a buyer would pay to read.
3. **Months 9–12 — ship Fused Reference Architecture v1 and give one VN talk.** Close the IAM/PAM/Zero-Trust gap only to architect-decision level. Benchmark: RA v1 + accepted talk + ≥1 buyer conversation = proceed.
4. **Months 12–24 — build the AI-Law conformity crosswalk once the high-risk list lands (Q3 2026), fuse it with RA v1.** Benchmark: ≥1 paid engagement or internal mandate to lead an AI-fabric/assurance initiative.
5. **Months 24–36 — convert to the fused title at a marquee operator/SI first; keep independence as optionality.** Benchmark: fused title + ≥2 reference engagements.
6. **Throughout — protect the income floor and SI seat for 12–18 months; force buyer contact every phase; keep the Gov/security brand loud.**

**Thresholds that change the plan:** if the high-risk AI list and conformity machinery slip well past 2027, stay weighted to infra and treat assurance as a call option. If GPU/power constraints visibly stall the VN buildout (project freezes at 2+ anchor buyers), slow the pivot and extend the SI runway. If a marquee operator offers the fused role before month 24, take it — the artifacts have done their job.

## Caveats
- **Forward-looking figures are projections, not facts.** Market-size and capacity forecasts (Mordor, Arizton, CBRE, P&S, Credence, ERP.today) are directional; the >US$7B AI-DC figure aggregates announced MoUs, many of which slip or shrink.
- **Compensation bands are triangulated.** ITviec (broad local market) and Robert Walters (MNC high-end) diverge significantly; state-enterprise/bank infra-director comp is the thinnest data point and is an estimate, not a published benchmark.
- **Regulatory specifics are still moving.** The high-risk AI list was unpublished as of May 2026; conformity-assessment-body capacity is unproven; decree details may shift. Treat 2027 as the earliest reliable assurance-monetization window.
- **No open public RFP/tender documents** with award amounts for the National Data Center or sovereign-cloud security were located; Gov/sovereign procurement appears to flow through MoPS and SOE vendors (Viettel/FPT/CMC) rather than open tenders — reinforcing that this is a relationship market.
- **Concentration risk is structural** and cannot be fully diversified inside a Vietnam-only lane; it is the single most important thing to monitor.