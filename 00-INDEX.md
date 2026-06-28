# 00-INDEX: Bản đồ Project

> File định hướng. Đọc trước ở mỗi cuộc mới. Mục đích: nói rõ track nào đang chạy, track nào đang đỗ, và file nào là source of truth cho từng việc, để không trộn nhầm hai track ở khâu retrieval.

Cập nhật: 2026-06-28.

**Nhật ký Infra mới nhất: `2026-06-28-02.md` (Day 40, Phase 1).** Đọc STATE block trong đó để lấy baseline cộng repo URL hiện hành. Baseline xác nhận bằng clone-zero-paste chạy qua WSL2 (`wsl.exe -- bash -lc "git clone ... && git log -1 && python3 -m pytest -q"`) — máy Windows host không có Python thật. Không đọc con số ở file này.

## Hai track, một vòng cung sự nghiệp

Đích cuối: **Sovereign AI Infrastructure Architect** cho hạ tầng critical VN (chi tiết ở `about_me.md`). Hai track phục vụ cùng vòng cung đó và **không đối xứng**:

- **AI Infrastructure: ĐANG CHẠY (active trunk).** Đang ở Phase 1, Python cho network automation. Execution sống ở nhật ký ngày cộng glossary. Đây là nơi memory của project đang được sinh ra.
- **AI Security & Assurance: ĐANG ĐỖ (parked branch).** Đã có kế hoạch đầy đủ nhưng chưa khởi động daily. Là moat chuyên môn hoá sẽ kích hoạt sau, hội tụ lại với Infra ở tầng bảo mật cho sovereign AI.

Quy ước mặc định: khi nói "phase 1", "bước tiếp theo", "hôm nay học gì" mà không nói rõ track, mặc định là **AI Infrastructure**.

## Source of truth theo mối quan tâm

| Việc | File |
|---|---|
| Hồ sơ, gap, định hướng 36 tháng (cả hai track) | `about_me.md` |
| Roadmap tổng AI Infrastructure | `Sovereign_AI_Infrastructure_Architect_in_Vietnam__36-Month_Roadmap...md` |
| Nền kỹ thuật fabric (EVPN-VXLAN sang RoCEv2) | `From_EVPN-VXLAN_to_RoCEv2_AI_Fabric...md` |
| Glossary Python Phase 1 (Infra) | `python_glossary_phase1.md` |
| Nhật ký thực thi hằng ngày (Infra) | `YYYY-MM-DD.md` |
| AI Sec: mô hình domain (kiến trúc, bền) | `aisec-domain-model.md` |
| AI Sec: chiến lược cộng cert cộng career | `aisec-strategy-and-certs.md` |
| AI Sec: lịch học (tick hằng tuần) | `aisec-learning-schedule.md` |
| AI Sec: sprint hands-on (lab) | `Planning_Moat1_AI_Security_Hands-on_Sprint-1.md` |
| AI Sec: hướng dẫn cài lab RAG | `Huong_Dan_Cai_Dat_Lab_AI_Security_RAG_v1_1.docx` |

## Convention đặt tên (áp dụng đi tới)

- File AI Sec: prefix `aisec-*`.
- File AI Infra: prefix `infra-*` khi tạo mới. Nhật ký giữ định dạng ngày `YYYY-MM-DD.md` cho gọn; nhiều phiên cùng ngày thêm hậu tố `-NN` (`2026-06-24.md` là Day 31, `2026-06-24-02.md` là Day 32).
- Mọi nhật ký phải có ngày trong tên file.

## Ba lớp tài liệu AI Sec (vì sao tách, không gộp làm một)

Tách theo **nhịp thay đổi**, không theo chủ đề:

- `aisec-domain-model.md`: kiến thức bền, hiếm đổi. Đọc để tư duy.
- `aisec-strategy-and-certs.md`: đổi theo thị trường (mốc EU AI Act, traction cert mới).
- `aisec-learning-schedule.md`: lịch tick hằng tuần.

Gộp ba lớp này vào một file sẽ bắt churn của lịch đụng vào kiến thức bền, và làm retrieval kéo nhầm chunk. Đó là lý do giữ ba file.

## Đã thay đổi 2026-06-16 (consolidation AI Sec)

5 file AI Sec cũ đã gộp cộng resolve còn 3 file (`aisec-domain-model` / `aisec-strategy-and-certs` / `aisec-learning-schedule`). Một mâu thuẫn sống về verdict CySA+ đã được resolve (giữ calibration Middle, xóa bản calibration senior cũ).

**Cần xóa khỏi project 5 file cũ sau khi đã thêm 3 file mới:**

- `AI_Security_and_AI_Assurance__Multi-Year_Specialization_Roadmap__2025-2026_.md`
- `ai-security-assurance-reference-architecture.md`
- `REFERENCE-ai-security-career-roadmap.md`
- `ai-security-learning-plan.md`
- `senior-security-ai-mentor-roadmap.md`

## Đã thay đổi 2026-06-28 (Infra trunk, Day 40)

`parse_control_output(raw_stdout)` tách ra top-level pure function trong `srl_fetcher.py` — stdlib exceptions (ValueError/TypeError/JSONDecodeError), không dùng SRLFetchError. `CONTROL_CMD` module-level constant dùng chung cho cả netmiko và asyncssh. `SRLCliFetcher.fetch_control()` wrap network error → SRLFetchError, bubble parse error. `poll_node` import CONTROL_CMD + parse_control_output, không còn mock dict. `test_srl_fetcher.py` 10 tests (thay 5 cũ). 72 green total, 9.01s. Commit `046257a`.

## Đã thay đổi 2026-06-28 (Infra trunk, Day 39)

`poll_node` refactor thành Raw Fetcher thuần (không except). `safe_poll_node` = Layer 1 Transport Boundary, 2-nhánh except tách biệt operational (OSError→ERROR+unreachable) vs bug (Exception→CRITICAL+error). `load_nodes(filepath)` Fail-Fast 5-lớp (list/empty/str/ipaddress.ip_address()/duplicate) + `nodes.json` externalize. `main_loop` thay TaskGroup bằng `asyncio.create_task()` + `asyncio.as_completed()` + `_wrapped_poll` identity-carrying tuple + Reactive Timestamping per-node. `test_load_nodes.py` 8 green. 67 green total, 8.79s. Commit `3cc5bdb`.

## Đã thay đổi 2026-06-27 (Infra trunk, Day 38)

`main_loop()` migrate sang async: `asyncio.Event` + `loop.add_signal_handler` + `asyncio.TaskGroup` fan-out N node + `state_registry` per-node isolation + `asyncio.wait_for` tighter sleep; `poll_node()` asyncssh transport — `known_hosts=None`, `connect_timeout=3`, fallback dict; `test_main.py` 2 async test + 1 fix. 62 green total, 8.62s. Commit `95a656a`.

## Đã thay đổi 2026-06-26 (Infra trunk, Day 37)

Externalize threshold: `load_thresholds(filepath)` — JSON + 3-lớp validation (dict check, required keys, int+bool+range per value) + whitelist return; `main_loop(config_path)` Fail-Fast trước while, re-raise cho entrypoint; `if __name__` xử lý sys.argv + sys.exit(1); `thresholds.json`; `test_load_thresholds.py` 5 green (tmp_path fixture). Commit `b5f4b96`, 60 green total.

## Đã thay đổi 2026-06-26 (Infra trunk, Day 36)

SIGTERM graceful-stop: `_stop_event = threading.Event()` module-level; `sigterm_handler` chỉ `set()` (Async-Signal Safe); `signal.signal` cho SIGTERM + SIGINT; `while not _stop_event.is_set()` + `_stop_event.wait(timeout)` thay `while True` + `time.sleep()`; `finally` cleanup. `test_sigterm.py` 2 green. Commit `b70f2ef`, 55 green total.

## Đã thay đổi 2026-06-26 (Infra trunk, Day 35)

`tick()` Functional Core extract ra khỏi `main_loop()` — pure function, 5 inject (raw_data, past_state, current_time, thresholds, cooldown_seconds), trả (alerts, next_state). `main_loop()` refactor thành Imperative Shell thuần. `dummy_fetcher()` biến thiên 3-phase via `_LOOP_COUNTER` — demo đủ TRIGGERED → REPEATED → RECOVERED. `test_tick.py` — 2 green, chạy 0.02s (không cần sleep thật). Commit `1205e7a`, 53 green.

## Đã thay đổi 2026-06-24 (Infra trunk, Day 31-32)

Phase 1 `srl-monitor`: live netmiko transport validated end-to-end trên SR Linux container thật (Day 31), envelope confirm flat trên device, `control_A.json` thay bản trim 941B bằng capture full-fidelity thật qua tee (Day 32). Re-pin toàn bộ test real-capture sang fixture-derived (miễn drift), synthetic giữ pin cứng. Baseline 40 green. Repo code public `github.com/trung2806/srl-monitor`. STATE chi tiết ở nhật ký mới nhất, không nhân đôi ở đây.
