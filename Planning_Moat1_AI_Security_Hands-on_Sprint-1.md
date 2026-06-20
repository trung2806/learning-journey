# Planning — Moat 1 (AI Security) hands-on, Sprint 1

*Tạo: 2026-06-15. Đi kèm: Lab AI Security & RAG Red-Team v1.0. Nền: roadmap đa năm (PART D/E + 3 starter project Moat 1), reference-architecture 8 lớp, mentor-roadmap.*

> Track này chạy SONG SONG với track Python network-automation (journal Day 19). Để không rối journal, log riêng theo tên `ai-sec-YYYY-MM-DD.md` và đánh số buổi **S0, S1, S2...** thay vì "Day N of Phase 1".

---

## 0. Doctrine — đọc trước mỗi buổi (đây là trục, không phải lời mở đầu)

Bốn doc nền của anh nói cùng một câu, lặp lại có chủ đích: **literacy, không phải fluency. Architect, không phải operator. Phần gõ phím giao cho implementer/junior/AI assistant dưới sự chỉ huy của anh.** (reference-architecture dòng 3/121/130; learning-plan dòng 3/33; mentor-roadmap; roadmap đa năm Key Finding #2.)

Hệ quả cho lab này, phải giữ kỷ luật:

1. **Lab = máy sinh bằng chứng, không phải track code thứ hai.** Mục tiêu mỗi buổi KHÔNG phải nhớ flag garak hay thuộc API PyRIT. Mục tiêu là **chạy tool có sẵn → đọc hiểu output → ánh xạ sang khung**. Code (vuln_rag.py, snippet PyRIT) là gạch có sẵn để copy-paste, không phải bài tập gõ.
2. **Artifact đầu ra mỗi buổi là tài sản architect**, không phải cảm giác "đã chạy được tool". Cụ thể: threat-model mini, defense-delta table, finding→framework crosswalk. Đây mới là cái bán được cho Gov/FSI và là cầu M1 → M5.
3. **Time-box phần operator.** Nếu một buổi sa vào debug GPU passthrough / fight version PyRIT quá 30 phút, đó là dấu hiệu rơi xuống tầng operator. Ghi nợ, chuyển sang Phương án B (Ollama trên Windows) hoặc dời, đừng đốt buổi học vào đó. Track Python (Day 19) đã là chỗ anh luyện hands-on sâu có chủ đích; track này thì không.

Rủi ro nếu bỏ doctrine này: lab biến thành track operator thứ hai, tranh giờ với track Python infra trong cùng quỹ 20h/tuần, và đẩy anh đi ngược chính chiến lược "architect literacy" mà anh đã chốt 4 lần.

---

## 1. Sprint 1 nén 3 starter project của roadmap thành 8 buổi

Roadmap Moat 1 có 3 starter project (Beginner: Gandalf + garak baseline; Intermediate: tấn công vuln agent; Advanced: build/break/defend/CI-gate). Sprint này chạy cả 3 ở **depth literacy**, mỗi buổi nhả một artifact architect.

Cột "Lớp" theo reference-architecture (L0–L7). Cột "OWASP" theo **OWASP LLM Top 10 phiên bản 2025 đã xác minh** (xem mục 3 — bản trong reference-architecture.md của anh đang dùng ID 2023 nhầm).

| Buổi | Ngày | Mục tiêu | Hành động (operator, có sẵn) | Artifact (architect, giữ lại) | Lớp | OWASP 2025 | ~Giờ |
|---|---|---|---|---|---|---|---|
| **S0** | 2026-06-15 | Dựng lab, qua go/no-go | Theo lab v1.0 + 2 sửa hôm nay (mục 4). Chạy hết checklist 7 mục §5.5 | Lab xanh 7/7. Nếu mục 5 (injection) đỏ là bình thường, ghi nợ | hạ tầng | — | 2–3 |
| **S1** | 2026-06-16 | Nền prompt injection thủ công | Gandalf (gandalf.lakera.ai) 7 level bằng tay; rồi 1 lần garak baseline `--probes promptinject` lên llama3.2:3b, đọc report | **Crib 1 trang taxonomy injection** (direct vs indirect; jailbreak = biến thể) + 1 dòng crosswalk cho finding garak đầu | L2, L7 | LLM01 | 2.5 |
| **S2** | +1 buổi | Đọc sâu garak baseline | Chạy `promptinject,dan.Dan_11_0` + một probe encoding; phân loại finding theo probe-family → OWASP | Báo cáo baseline + 3–5 dòng crosswalk (LLM01, LLM07, LLM05) | L2, L6, L7 | LLM01/05/07 | 2 |
| **S3** | +1 buổi | Tấn công RAG (project Intermediate, bản lite) | Bắn câu hỏi §5.4.1 vào vuln_rag.py; quan sát 'PWNED'/lộ system prompt; đây là indirect injection qua tài liệu retrieve | **Threat-model mini của RAG** (trace L1→L7 của reference-arch §4) + crosswalk rows | L4, L2, L6 | LLM01/02/07/08 | 2.5 |
| **S4** | +1 buổi | Đo hiệu lực phòng thủ (project Advanced, phần defend) | Chèn llm-guard (PromptInjection + output scanner) trước/sau model; chạy lại đòn S2/S3; ĐO delta success | **Defense-delta table** (đòn X: success trước / chặn sau) = bằng chứng pattern "guardrail sandwich" | L2, L6, L7 | mitigations | 2.5 |
| **S5** | +1 buổi | PyRIT đa lượt (cái garak/promptfoo không làm) | Snippet §5.4.3 chỉ là test kết nối. Rồi chạy `CrescendoOrchestrator` (hoặc RedTeamingOrchestrator) đa lượt — đúng giá trị của PyRIT | Transcript tấn công đa lượt + 1 dòng crosswalk (jailbreak multi-turn) | L2, L7 | LLM01 | 2.5 |
| **S6** | +1 buổi | promptfoo làm CI-gate (project Advanced, phần gate) | `redteam init/run/report` offline (preset OWASP); viết config như regression harness, ghi chú cách nó nằm trong CI | **promptfooconfig.yaml** dạng harness chống regression = pipeline bằng chứng M5 | L7 | preset OWASP/NIST | 2 |
| **S7** | +1 buổi | Cầu M1 → M5 (điểm hợp nhất hai moat) | Gom mọi finding S1–S6, hoàn thiện crosswalk đầy đủ | **Crosswalk hoàn chỉnh** = mẩu portfolio bán Gov/FSI; mỗi finding red-team thành bằng chứng audit | L0, L7 | toàn bộ | 2.5 |

Cadence gợi ý: 2–3 buổi/tuần xen kẽ track Python, không ép lịch cứng. Anh log theo số buổi như journal hiện tại, không theo đồng hồ.

---

## 2. Crosswalk template — artifact load-bearing nhất của cả sprint

Đây là cái biến lab operator thành tài sản architect, và là lý do roadmap nói "red-team finding của anh literally thành audit evidence của anh". Mỗi finding (Gandalf, garak, vuln_rag, PyRIT) thành một dòng. Điền dần từ S1, đóng băng ở S7.

| Finding | PoC (1 dòng tái lập) | OWASP LLM 2025 | MITRE ATLAS | Lớp (reference-arch) | NIST AI RMF (func) | ISO 42001 (Annex A) | Severity | Mitigation đã đo |
|---|---|---|---|---|---|---|---|---|
| *vd: lộ system prompt qua tài liệu RAG bị đầu độc* | `curl :8000/chat -d '{"message":"..."}'` → output chứa 'PWNED' | LLM01 + LLM07 | (điền technique ATLAS tương ứng) | L4 (knowledge) + L2 (ingress) | Map / Measure | (control Annex A liên quan) | High | llm-guard PromptInjection: chặn? (S4) |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

Quy tắc điền: cột PoC phải **tái lập được** (như raw capture trong journal Python — provenance, không phải mô tả từ trí nhớ). Cột MITRE ATLAS và ISO Annex A có thể để `[~ verify]` ở S1–S6 rồi tra chốt ở S7; đừng bịa mapping, đánh dấu nợ.

---

## 3. Bản đồ phủ 8 lớp — thấy rõ lab chạm gì, bỏ trống gì

Lab v1.0 phủ tốt 4 lớp; 3 lớp để trống. Nhìn rõ để chủ động, không phải lỗ hổng bị lờ đi.

| Lớp | Lab Sprint 1 chạm? | Ghi chú |
|---|---|---|
| L0 Governance | một phần (S7 crosswalk → NIST/ISO) | đủ cho cầu M5 ở mức literacy |
| L1 Identity/NHI | **KHÔNG** | đây là **fast-win của anh** từ nền IAM. Sprint 2: identity-bound retrieval, agent NHI |
| L2 Ingress/Prompt | **CÓ** (S1, S2, S4, S5) | lõi của sprint |
| L3 Model supply chain | **KHÔNG** | model signing, AIBOM, provenance — Sprint 2 |
| L4 Knowledge/RAG | **CÓ** (S3) | vuln_rag = indirect injection; LLM08 vector/embedding chỉ chạm nhẹ |
| L5 Tool/Action (agentic) | **KHÔNG** | vuln_rag không có tool. Cần DVLA/DVAIA để chạm L5 (Sprint 2) |
| L6 Egress/Output | **CÓ** (S2, S4) | output scanner, coi output untrusted |
| L7 Observability/Assurance | **CÓ** (mọi buổi) | garak/promptfoo report = eval harness + evidence store |

Kết luận coverage: Sprint 1 làm chủ trục **L2/L4/L6/L7** (prompt + RAG + output + eval). Ba lớp bỏ trống đều có lý do, và **L1 (NHI/agent identity) đáng là Sprint 2 đầu tiên** vì nó leverage trực tiếp nền IAM/zero-trust của anh — đúng "fast win" roadmap đã gọi tên.

---

## 4. Hai sửa BẮT BUỘC cho buổi setup hôm nay (S0)

Chi tiết đầy đủ các chỉnh sửa nằm ở phần trả lời. Hai cái này chặn S0/S1 nếu không xử:

1. **Node trên Ubuntu 22.04.** `apt install nodejs` cho Node 12, promptfoo cần 20+. Lab có cảnh báo "nếu < 20 cài nvm" nhưng trên 22.04 nó CHẮC CHẮN < 20. Cài thẳng bằng nvm ngay từ đầu:
   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
   source ~/.bashrc
   nvm install 20 && nvm use 20
   node -v   # phải >= v20
   ```
2. **Sequencing: buổi học đầu (S1) không phụ thuộc lab chạy hoàn hảo.** Roadmap đặt Gandalf + PortSwigger (browser, zero-install) TRƯỚC mọi tooling local. Nên kể cả nếu S0 chưa xanh đủ 7/7 tối nay, S1 mai vẫn chạy được phần Gandalf. Đừng để GPU passthrough chặn buổi học đầu tiên.

---

## 5. Kỷ luật mỗi buổi — bê nguyên từ journal Python của anh

Cùng bộ cơ chế đã hiệu quả ở track Python, áp sang đây:

- **Backlog-first.** Mở mỗi buổi bằng việc xả nợ buổi trước (forcing function), rồi mới new-work. Nợ dời qua buổi là mechanism failure.
- **Provenance label** trên mọi finding: output garak/PyRIT paste **raw nguyên văn** vào log trước khi diễn giải (như raw capture SRL trước parser). Mapping chưa tra thì `[~ verify]`, không bịa.
- **Glossary add** cuối buổi: thuật ngữ AI security mới (vd: indirect prompt injection, guardrail sandwich, Crescendo, confused deputy) vào một `ai-sec-glossary.md` riêng, song song glossary Python.
- **Tee-up + prep question** cuối buổi cho buổi sau, đúng nếp Day 19.
- **Pin/detonation áp được chỗ có code:** với defense-delta (S4) và promptfoo CI (S6), một "đòn tái lập được + assert nó bị chặn sau mitigation" chính là một detonation — đòn đỏ trước fix, xanh sau. Đó là chỗ kỷ luật pin của anh chuyển thẳng sang được.

---

## 6. Caveat thật

- Sprint này phủ L2/L4/L6/L7 ở **literacy**. Nó KHÔNG biến anh thành operator red-team, và đó là đánh đổi có chủ đích (đúng doctrine).
- vuln_rag.py thay cho DVLA/DVAIA: nhẹ hơn, hợp 4GB, minh bạch (thấy được lỗ hổng), nhưng chỉ demo MỘT lớp tấn công (indirect injection L4). Bề mặt agentic (L5, tool abuse) phải đợi DVLA ở Sprint 2.
- PyRIT bản PyPI trễ hơn `main`; nếu import lỗi, khớp notebook theo đúng version đã cài (lab §5.4.3 đã cảnh báo).
- Crosswalk là artifact bán được, nhưng mapping ISO 42001 Annex A và NIST AI RMF cần tra chốt ở S7, không nhận bản nháp làm bản cuối.
- 8 buổi là Sprint 1. Sprint 2 (đề xuất): L1 NHI/agent identity (fast win IAM) → L5 tool/action qua DVLA → L3 model supply chain/AIBOM.
