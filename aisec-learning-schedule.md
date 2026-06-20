# AI Sec: lịch học (architect, 15h/tuần, khoảng 12 tháng)

> Vai trò trong project: đây là **lớp lịch thực thi** của track AI Security, tick hằng tuần. Nó biến Phase A đến D của mô hình domain (`aisec-domain-model.md`) thành lịch có mốc. **"Học" ở đây nghĩa là nghiên cứu reference architecture cộng threat model cộng framework, rồi tự dựng lại và phản biện. Không học cú pháp code.** Output mỗi phase là một artifact kiểu HLD, dùng được luôn cho khách Gov/FSI.
>
> Chiến lược, cert và career ở `aisec-strategy-and-certs.md`.

## Nhịp tuần (engine, 15h)

| Khối | Giờ | Nội dung |
|---|---|---|
| Đọc/nghiên cứu | 6h | Framework, kiến trúc tham chiếu, threat model, khóa học |
| Dựng artifact | 5h | Việc thiết kế artifact của phase (sở trường của anh) |
| Review/phản biện | 2h | Áp lên một hệ tham chiếu; tự soi theo senior rubric |
| Ôn cert | 2h | Khi phase đó có cert đang chạy |

## Các phase

| Phase | Tháng | Học gì (input mức kiến trúc) | Artifact đầu ra | Checkpoint, biết đã lên | Cert |
|---|---|---|---|---|---|
| **0: Foundation** | 0 đến 0.75 (3 tuần) | Mô hình 8 lớp; OWASP LLM Top 10 (2025); OWASP Agentic Top 10; cấu trúc MITRE ATLAS | Tự vẽ lại reference architecture cộng 1 trang crib taxonomy mối đe dọa | Đọc bất kỳ rủi ro AI, gắn đúng lớp cộng 1 mục OWASP/ATLAS | (không) |
| **A: Control catalog** | 1 đến 2 | NIST AI RMF (Govern/Map/Measure/Manage cộng GenAI profile); ISO/IEC 42001 (AIMS cộng Annex A); Google SAIF; Databricks DASF | Control catalog hợp nhất, map 4 framework vào 8 lớp (kiểu HLD) | Cho 1 control, đặt đúng lớp cộng nêu framework nào yêu cầu | **AIGP** (ôn từ tuần 4) |
| **B: Pattern & Threat model** | 3 đến 4 | 8 pattern tái sử dụng; threat modeling cho AI (MAESTRO, STRIDE-for-AI) | Template threat-model cộng 2 đến 3 threat model mẫu (RAG chatbot, agentic workflow, AI gateway) | Threat-model một hệ AI lạ trong một buổi, ra control set bảo vệ được | (không) |
| **C: Tích hợp & Assurance** | 5 đến 7 | Mô hình tích hợp (identity spine, gateway, vòng lặp govern); crosswalk NIST, ISO 42001, EU AI Act; thiết kế sovereign/isolated tier | Reference architecture đầy đủ cộng assurance crosswalk, đây là **tài sản bán Gov/FSI** | Chạy gap analysis một AIMS theo ISO 42001, map finding sang NIST/EU AI Act | **ISO/IEC 42001 Lead Auditor** (ôn từ đầu phase) |
| **D: Review & Assess** | 8 đến 10 | Phương pháp assessment; đọc hiểu bằng chứng (báo cáo garak/eval ở mức literacy); cách đặc tả việc cho implementer | Methodology "AI security assessment" (template cộng rubric cộng báo cáo mẫu) cộng design-review checklist | Dẫn một AI security architecture review, ra assessment có điểm cộng evidence sẵn để attest | **AAIA** (nếu có CISA/CIA/CPA) hoặc **AAISM** (nếu có CISM/CISSP) |
| **E: Mastery & currency** | 11 đến 12+ | Một engagement thật; theo dõi EU AI Act timing, release OWASP/ATLAS mới | Một engagement tham chiếu trong portfolio (kiến trúc cộng assess end-to-end) | Có một case thật bảo vệ được trước hội đồng | duy trì CPE |

## Cert đặt ở đâu, vì sao (tóm tắt; chi tiết verdict ở `aisec-strategy-and-certs.md`)

- **AIGP (IAPP)**: neo Phase A. Không prereq, recognition cao nhất mảng AI governance, monetize thẳng sức compliance anh đang có. Khoảng 799 USD, Body of Knowledge v2.1 (hiệu lực 02/2026). Làm trước vì rẻ thời gian và mở cửa khách sớm.
- **ISO/IEC 42001 Lead Auditor (PECB)**: neo Phase C. Credential assurance/conformity, ghép thẳng nền ISO 27001 của anh, đúng cho Gov/FSI và khách dính EU AI Act. Khoảng 799 USD self-study.
- **AAIA hoặc AAISM (ISACA)**: Phase D, **có điều kiện**. AAIA cần CISA/CIA/CPA; AAISM cần CISM/CISSP. Nếu anh đang giữ một trong số đó, đây là flagship đóng đinh năng lực. Nếu chưa có prereq thì bỏ qua, không bắt buộc cho năng lực kiến trúc.

## "Học" ở đây nghĩa là gì (nhắc lại, vì là trục)

Literacy, không phải fluency. Anh đọc một kiến trúc, đặc tả control, đọc hiểu bằng chứng. Phần gõ phím (garak, llm-guard, gateway) giao cho implementer/junior/AI assistant dưới sự chỉ huy của anh. 5h "dựng artifact" mỗi tuần là việc thiết kế, không phải viết code. Phần hands-on lab chi tiết tách riêng ở `Planning_Moat1_AI_Security_Hands-on_Sprint-1.md`.

## Caveat thật

- Đây là năng lực **architect**, không phải operator hands-on. Đánh đổi có chủ đích (literacy not fluency).
- Khoảng 12 tháng là vì nền security architecture của anh gánh khoảng nửa tải; người mới sẽ lâu hơn đáng kể.
- AAIA/AAISM phụ thuộc prereq anh có thể chưa có, đã đánh dấu điều kiện.
- EU AI Act timing đang trôi (có khả năng dời mốc high-risk sang 12/2027); phần NIST AI RMF cộng ISO 42001 đứng vững bất kể.
- Output mỗi phase dùng được làm tài sản Gov/FSI, nên không phải chi phí chìm.

## Điểm flex theo khách (giả định A1 ở mô hình domain)

- Khách còn ở mức hỏi đáp: Phase C và D nghiêng về governance cộng biên dữ liệu (L0, L1, L2, L4, L6).
- Khách đã có agent hành động: thêm trọng tâm tool/action security cộng action broker (L5). Bản plan chạy được cho cả hai, chỉ đổi trọng số.
