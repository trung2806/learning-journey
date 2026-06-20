# 00-INDEX: Bản đồ Project

> File định hướng. Đọc trước ở mỗi cuộc mới. Mục đích: nói rõ track nào đang chạy, track nào đang đỗ, và file nào là source of truth cho từng việc, để không trộn nhầm hai track ở khâu retrieval.

Cập nhật: 2026-06-16.

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
- File AI Infra: prefix `infra-*` khi tạo mới. Nhật ký giữ định dạng ngày `YYYY-MM-DD.md` cho gọn.
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
