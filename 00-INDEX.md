# 00-INDEX: Bản đồ Project

> File định hướng. Đọc trước ở mỗi cuộc mới. Mục đích: nói rõ track nào đang chạy, track nào đang đỗ, và file nào là source of truth cho từng việc.

Cập nhật: 2026-06-29.

## Trạng thái hiện tại

**AI Infrastructure track: Python Phase 1 — DONE.** D1–D47 (2026-05-25 → 2026-06-29). Daemon `srl-monitor` đã production-grade. Tiếp tục thêm feature = over-invest vào craft, vi phạm roadmap anti-pattern. Chuyển sang **RoCEv2/RDMA** (Q1 Phase 1 mục tiêu chính).

**AI Security track: ĐANG ĐỖ.** Kế hoạch đầy đủ, chưa khởi động. Kích hoạt sau khi Q1 infra xong.

---

## Hai track, một vòng cung sự nghiệp

Đích cuối: **Sovereign AI Infrastructure Architect** cho hạ tầng critical VN (chi tiết ở `about_me.md`). Hai track phục vụ cùng vòng cung và **không đối xứng**:

- **AI Infrastructure: ĐANG CHẠY (active trunk).** Đang ở Phase 1 Q1. Python literacy đã xong. Tiếp theo: RoCEv2/RDMA → artifact "EVPN-VXLAN engineer's guide to RoCEv2 AI fabric."
- **AI Security & Assurance: ĐANG ĐỖ (parked branch).** Kích hoạt sau Q1 infra, hội tụ ở tầng bảo mật sovereign AI.

Quy ước mặc định: khi nói "phase 1", "bước tiếp theo", "hôm nay học gì" mà không nói rõ track, mặc định là **AI Infrastructure**.

---

## TIẾP THEO (Q1 Phase 1 — RoCEv2/RDMA)

Per roadmap tháng 0–3:
- **Học gì:** RoCEv2/RDMA — PFC, ECN, DCQCN, lossless Ethernet, jumbo frames, ECMP. Tại sao AI fabric khác EVPN-VXLAN DC fabric: synchronous all-reduce gradient exchange → 1% packet drop idle cả 1,024-GPU cluster.
- **Góc tiếp cận:** chuyển dịch từ EVPN-VXLAN kiến thức sẵn có, không bắt đầu từ đầu.
- **Artifact mục tiêu:** "EVPN-VXLAN engineer's guide to RoCEv2 AI fabric" — bài viết public đầu tiên, credibility piece Q1.
- **Lab:** không cần GPU cluster. Build lossless-Ethernet topology trong simulation; tune PFC/ECN; đọc NVIDIA reference architectures (DGX SuperPOD / Spectrum-X) như design reference.

---

## Source of truth theo mối quan tâm

| Việc | File |
|---|---|
| Hồ sơ, gap, định hướng 36 tháng (cả hai track) | `about_me.md` |
| Roadmap tổng AI Infrastructure | `Sovereign_AI_Infrastructure_Architect_in_Vietnam__36-Month_Roadmap...md` |
| Nền kỹ thuật fabric (EVPN-VXLAN sang RoCEv2) | `From_EVPN-VXLAN_to_RoCEv2_AI_Fabric...md` |
| Glossary Python Phase 1 | `python_glossary_phase1.md` |
| Nhật ký thực thi hằng ngày (Infra) | `YYYY-MM-DD[-NN].md` |
| AI Sec: mô hình domain | `aisec-domain-model.md` |
| AI Sec: chiến lược + cert | `aisec-strategy-and-certs.md` |
| AI Sec: lịch học | `aisec-learning-schedule.md` |

**Nhật ký Infra mới nhất: `2026-06-29-07.md` (Day 47, Phase 1).** Đọc STATE block trong đó để lấy baseline cộng repo URL. Baseline xác nhận bằng clone-zero-paste chạy qua WSL2. Không đọc con số ở file này.

---

## Python Phase 1 — Lineage tóm tắt (D1–D47)

| Giai đoạn | Days | Nội dung chính | Commit cuối |
|---|---|---|---|
| Tooling + Python cơ bản | D1–D10 | venv, types, functions, classes, git, pytest | — |
| Netmiko + SR Linux transport | D11–D30 | netmiko SSH, JSON parsing, real device capture, 40 green | `c712649` |
| asyncio migration | D31–D38 | asyncio, asyncssh, signal handling, error boundaries | `95a656a` |
| Configuration + Fleet | D36–D40 | load_thresholds, load_nodes, SIGTERM, srl_fetcher refactor | `046257a` |
| Async patterns nâng cao | D41–D43 | _wrapped_poll watchdog, asyncio.wait FIRST_COMPLETED, Set task registry | `e79a740` |
| Observability + Guards | D44–D47 | DaemonStats, SIGUSR1, filter guard, GUARD CHECKLIST, _DAEMON_VERSION | `a04f2e2` |

**90 green total, 13s.** Repo public: `github.com/trung2806/srl-monitor`.

**Điểm dừng hợp lý:** daemon đang production-grade. Feature backlog còn (`STATS.infra_error_count`, STATS persistence) nhưng không học thêm gì mới — đừng làm. Python track đã đạt literacy và vượt qua rồi.

---

## Convention đặt tên

- File AI Sec: prefix `aisec-*`.
- File AI Infra: prefix `infra-*` khi tạo mới. Nhật ký giữ định dạng ngày `YYYY-MM-DD.md`; nhiều phiên cùng ngày thêm hậu tố `-NN`.
- Mọi nhật ký phải có ngày trong tên file.

---

## Ba lớp tài liệu AI Sec (vì sao tách)

Tách theo **nhịp thay đổi**: `aisec-domain-model.md` (kiến thức bền) / `aisec-strategy-and-certs.md` (đổi theo thị trường) / `aisec-learning-schedule.md` (lịch tick hằng tuần). Gộp → churn của lịch đụng vào kiến thức bền → retrieval kéo nhầm chunk.

---

## Files AI Sec cũ cần xóa

Đã gộp vào 3 file mới (2026-06-16). Cần xóa:
- `AI_Security_and_AI_Assurance__Multi-Year_Specialization_Roadmap__2025-2026_.md`
- `ai-security-assurance-reference-architecture.md`
- `REFERENCE-ai-security-career-roadmap.md`
- `ai-security-learning-plan.md`
- `senior-security-ai-mentor-roadmap.md`
