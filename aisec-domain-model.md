# AI Sec: mô hình domain (reference architecture) và lộ trình làm chủ mức kiến trúc

> Vai trò trong project: đây là **lớp kiến thức bền** của track AI Security. Nắm domain ở mức kiến trúc như anh nắm security architecture: nguyên tắc, pattern, mô hình tích hợp, để **chỉ huy và review**, không phải để gõ code. Sản phẩm (garak, llm-guard, AI gateway, một model cụ thể) thay thế được; kiến trúc là phần bền.
>
> File anh em: chiến lược cộng cert cộng career ở `aisec-strategy-and-certs.md`; lịch học hằng tuần ở `aisec-learning-schedule.md`.

## Giả định (xác nhận hoặc chỉnh nếu sai)

| # | Giả định | Hệ quả nếu khác |
|---|---|---|
| A1 | Phạm vi là **agentic / RAG chạy production**, không chỉ chatbot Q&A | Nếu chỉ Q&A: chỉ L0, L1, L2, L6 cộng biên dữ liệu áp dụng; L5 (tool/action) chưa kích hoạt |
| A2 | Khách **Gov/FSI**, có ràng buộc chủ quyền dữ liệu cộng compliance (Luật ANM, NĐ 13/2023, TT 09 NHNN) | Quyết định tier model (sovereign vs cloud) đổi hoàn toàn |
| A3 | Anh đã thạo **security architecture cổ điển** (zoning, zero trust, least privilege, PEP/PDP) | Tôi neo mọi thứ vào cái anh đã biết, không giải thích lại nền |

## Điểm khác biệt cốt lõi so với security architecture cổ điển

Lõi hệ thống là **xác suất, không xác định**. Trong kiến trúc mạng anh chứng minh được "gói từ zone A không tới được zone B". Với LLM, anh **không** chứng minh được "model sẽ không tiết lộ dữ liệu X" hay "sẽ không gọi tool Y". Đảo chiều tư duy: thay vì làm lõi an toàn, anh **bọc một lõi không đáng tin bằng các biên xác định, kiểm thử được**. Mọi pattern bên dưới là hệ quả của một câu đó.

---

## 1. Mô hình phân lớp: AI system như kiến trúc có trust boundary

Đọc theo vòng đời một request, từ ngoài vào lõi rồi ra. Mỗi lớp là một control plane, ánh xạ thẳng sang OWASP LLM Top 10 (2025), OWASP Agentic Top 10 (2025) và MITRE ATLAS.

| Lớp | Vai trò | Mối đe dọa nó trả lời | Control pattern chính | Moat |
|---|---|---|---|---|
| **L0 Governance & Accountability** (lớp bọc ngoài cùng) | Policy, rủi ro, ai ký chịu trách nhiệm, vòng đời | Không tuân thủ; không có chủ thể chịu trách nhiệm | NIST AI RMF (Govern); ISO/IEC 42001 AIMS; risk register; human sign-off; lifecycle gate | **M5** |
| **L1 Identity & Access** | Danh tính người gọi cộng danh tính của chính AI | Excessive agency; confused deputy; agent mạo danh | NHI / agent identity; credential scoped cộng time-bound; kiểm soát delegation vs impersonation; thẩm quyền HITL | **M1** (nền IAM của anh) |
| **L2 Ingress / Prompt** (north-south vào) | Lọc đầu vào trước khi tới model | LLM01 prompt injection; jailbreak | Input validation; injection/jailbreak detection; content policy, đặt tại AI gateway | **M1** |
| **L3 Model** | Bản thân model cộng nguồn gốc | LLM03/05 supply chain & poisoning; model theft (ATLAS) | Provenance cộng model signing cộng AIBOM; data governance cho fine-tune; **sovereign/isolated tier** | **M1 + M5** |
| **L4 Knowledge / Data** (RAG, vector store, memory) | Cái model biết và có thể nhả ra | LLM06 sensitive info disclosure; data poisoning | **Retrieval gắn theo danh tính người gọi**; phân loại dữ liệu; minimization; **biên DLP** | **M1 + M5** |
| **L5 Tool / Action** (east-west, blast radius) | Cái agent được phép *làm* | LLM08 excessive agency; lạm dụng tool / MCP | **Action broker (PEP/PDP)**; allowlist tool; sandbox; **approval gate cho hành động không đảo ngược** | **M1** |
| **L6 Egress / Output** (north-south ra) | Lọc đầu ra trước khi trả | LLM02 insecure output handling; rò rỉ | Output filtering; redact PII/secret; **coi output là untrusted** (chống injection downstream); DLP egress | **M1** |
| **L7 Observability & Assurance** (xuyên suốt mọi lớp) | Thấy được cộng chứng minh được | Không phát hiện được; không attest được | Full-context logging; **eval/red-team harness**; drift/anomaly; **evidence store** | **M1 (detect) + M5 (attest)** |

> Cách dùng bảng này như một security architect: với mỗi hệ AI khách hàng đưa ra, anh đi từ L0 xuống L7 và hỏi "lớp này có control nào, gắn vào đâu, ai sở hữu". Lớp nào trống là một finding.

---

## 2. Nguyên tắc thiết kế: ánh xạ từ cái anh đã biết

| # | Cổ điển anh biết | Biến thể AI | Vì sao |
|---|---|---|---|
| P1 | Defense in depth | **Guardrail nhiều lớp** (L2+L4+L5+L6), giả định mỗi filter đều bị vượt | Prompt injection chưa có lời giải căn cơ; một lớp không đủ |
| P2 | Least privilege | **Least agency**: agent nhận tối thiểu tool/scope/autonomy | Đây là control agentic số 1; cắt blast radius tại gốc |
| P3 | Zero trust | **Coi output của model là untrusted input** | Model là confused deputy; output có thể chứa injection cho hệ downstream |
| P4 | Assume breach | **Giả định prompt sẽ bị injected**; thiết kế containment, không chỉ prevention | Anh không chặn được hết; anh giới hạn thiệt hại khi nó xảy ra |
| P5 | Separation of duties | **Model đề xuất, biên xác định (hoặc người) định đoạt** với hành động hệ trọng | Không giao quyết định không đảo ngược cho một lõi xác suất |
| P6 | Data classification | **Kiểm soát biên dữ liệu** (cái gì vào context/RAG) | Không lọc đáng tin được cái đã phơi ra; chặn ở đầu vào dữ liệu |
| P7 | (mới) | **Biên xác định bọc lõi xác suất**: schema enforcement, allowlist, validator | Trụ của cả kiến trúc, không làm model xác định được thì ràng nó bằng biên xác định |
| P8 | Audit trail | **Auditability by design**: log đủ để tái dựng và attest mọi quyết định/hành động | Bake M5 vào kiến trúc ngay từ đầu, không bắt vào sau |

---

## 3. Pattern tái sử dụng: cách các mảnh ghép lại

| Pattern | Giải quyết gì | Tương đương cổ điển |
|---|---|---|
| **AI Gateway / inference-path proxy** | Một chokepoint duy nhất cho lọc ingress cộng egress, redact, rate-limit, log | Reverse proxy / WAF |
| **Dual-LLM / privilege separation** | LLM cách ly xử lý nội dung untrusted; LLM đặc quyền không bao giờ thấy input thô | DMZ / tách vùng đặc quyền |
| **Guardrail sandwich** | input guard, model, output guard | Ingress cộng egress filtering |
| **Action broker (PEP/PDP cho tool)** | Agent không gọi tool trực tiếp; broker thực thi policy/scope/approval | Policy Enforcement Point |
| **Identity-bound retrieval** | RAG chỉ trả về cái danh tính người gọi được phép xem (row-level trên vector store) | Row-level security |
| **Human-in-the-loop checkpoint** | Chặn người duyệt cho hành động không đảo ngược / giá trị cao | Four-eyes / maker-checker |
| **Eval / red-team-as-CI-gate** | Harness regression khóa thuộc tính bảo mật để không tái phát | Regression test gate |
| **Sovereign / isolated tier** | Model local/air-gapped cho dữ liệu mật/NDA | Air-gapped enclave |

---

## 4. Mô hình tích hợp: làm cả hệ chạy trơn

Đây là phần "tích hợp": các control rời rạc chỉ thành kiến trúc khi có trục nối.

**Trục danh tính (identity spine).** Một danh tính chảy xuyên các lớp: `người gọi, danh tính agent (NHI), scope của tool broker, quyền retrieval`. Cùng một danh tính khóa cả L1, L4, L5. Đây là cái ngăn "privilege confusion", agent không được làm/đọc nhiều hơn người đứng sau nó.

**Điểm thực thi đơn nhất.** AI gateway bọc model; L2 và L6 sống bên trong nó. Hệ quả: có **một chỗ duy nhất** để reason về kiểm soát ingress/egress và một chỗ duy nhất để audit, thay vì rải rác.

**Mặt phẳng quan sát cắm ngang.** L7 tap vào mọi lớp, nuôi đồng thời hai thứ: phòng thủ realtime (anomaly) và kho bằng chứng audit.

**Vòng lặp khép kín.**
```
L0 Govern định policy
   -> kiến trúc hiện thực thành control rải khắp L1 đến L6
      -> L7 chứng minh control đang chạy đúng (eval, log, red-team)
         -> Assurance attest (M5)
            -> feedback về L0 để chỉnh policy
```

**Hợp nhất M1 và M5: lý do xây chung.** Cùng một artifact phục vụ hai người tiêu thụ: một kết quả red-team / điểm eval / log hành động vừa là **output bảo mật** (M1 dùng để gia cố) vừa là **bằng chứng audit** (M5 dùng để attest). Một pipeline, hai đầu ra. Đây là chỗ hai moat của anh không tách rời.

### Trace một request agentic đi xuyên đủ lớp

> Đọc như trace một gói qua các security zone. Đây là cách kiểm tra kiến trúc có liền mạch không.

1. **L1**: Xác thực người gọi, dẫn xuất danh tính cộng scope của agent từ đó (agent không vượt quyền người gọi).
2. **L2**: Ingress guard quét injection/jailbreak trên prompt cộng nội dung lấy về.
3. **L4**: Retrieval chỉ trả về tài liệu danh tính người gọi được phép xem; phân loại cộng minimize.
4. **L3**: Model suy luận (nếu dữ liệu mật thì tier sovereign/local).
5. **L5**: Với mỗi tool call model đề xuất, broker đối chiếu policy/scope; hành động không đảo ngược bị chặn chờ người duyệt.
6. **L6**: Egress guard redact PII/secret, coi output là untrusted trước khi trả.
7. **L7**: Toàn bộ trace được log làm bằng chứng (phục vụ cả phát hiện realtime lẫn audit).

Một control thiếu ở bất kỳ bước nào là một lỗ trên trace. Đó là checklist review của anh.

---

## 5. Bảng quyết định kiến trúc then chốt (có đánh đổi)

Đây là các quyết định một AI Security Architect phải ra và bảo vệ trước hội đồng.

| Quyết định | Lựa chọn | Đánh đổi | Khuyến nghị cho Gov/FSI |
|---|---|---|---|
| Tự chủ agent | Full autonomy vs HITL gate cho hành động không đảo ngược | Tốc độ/chi phí vận hành vs blast radius | HITL gate cho mọi hành động ghi/giao dịch; autonomy chỉ cho read-only |
| Triển khai model | Cloud API vs sovereign/local tier | Năng lực cộng chi phí thấp vs chủ quyền dữ liệu | Tier: cloud cho dữ liệu công khai; local cho NDA/mật (đúng mô hình second-brain của anh) |
| Chống injection | Filter đơn lớp vs dual-LLM privilege separation | Đơn giản vs độ vững | Dual-LLM khi agent xử lý nội dung từ nguồn ngoài không kiểm soát |
| Biên dữ liệu | Lọc output vs identity-bound retrieval | Dễ làm vs đúng từ gốc | Identity-bound retrieval; đừng để model thấy cái lẽ ra không được thấy |
| Eval | Ad-hoc vs red-team-as-CI-gate | Nhanh vs chống regression cộng tạo bằng chứng audit | CI-gate; output dùng luôn làm evidence cho M5 |

---

## 6. Lộ trình làm chủ: ở mức kiến trúc, không phải code

**Reframe quan trọng nhất, trả lời thẳng "không học class/function nữa":** anh cần **literacy, không phải fluency**. Như anh biết firewall CLI *làm gì* mà không cần là người admin firewall. Anh học để **đọc một kiến trúc, đặc tả control, và đọc hiểu bằng chứng** (đọc báo cáo garak, đọc điểm eval). Phần gõ phím giao cho implementer / junior / một AI coding assistant **dưới sự chỉ huy của anh**. Giá trị bền của anh là kiến trúc và phán quyết, không phải cú pháp.

| Phase | Anh làm gì (study / design / review) | Artifact đầu ra (cơ bắp HLD của anh) |
|---|---|---|
| **A: Nội hóa mô hình** | Học mô hình 8 lớp cộng taxonomy mối đe dọa (OWASP LLM/Agentic, ATLAS) cộng framework (NIST AI RMF, ISO 42001, Google SAIF, Databricks DASF) **như một control catalog**. Tự vẽ lại, không chép. | Reference architecture diagram của riêng anh cộng control catalog (kiểu HLD) |
| **B: Pattern cộng threat modeling** | Làm chủ 8 pattern; học threat modeling cho AI (MAESTRO, STRIDE-for-AI); model hóa 2-3 kịch bản tham chiếu | Template threat-model cộng 2-3 threat model mẫu (RAG chatbot, agentic workflow) |
| **C: Tích hợp cộng crosswalk assurance** | Dựng mô hình tích hợp cộng bảng crosswalk control sang framework (NIST, ISO 42001, EU AI Act) | Reference architecture cộng assurance crosswalk, đây là **tài sản bán cho Gov/FSI** (cầu M1 sang M5) |
| **D: Review cộng chỉ huy** | Review thiết kế AI của người khác; chạy assessment; **đặc tả** implementer phải xây và test gì; đọc hiểu bằng chứng | Assessment methodology cộng design-review checklist |

> Ở mỗi phase, "học" nghĩa là nghiên cứu reference architecture cộng threat model cộng framework rồi tự dựng lại và phản biện, **không phải học cú pháp**. Phần hands-on (garak, llm-guard, gateway) anh cần biết nó *làm gì* và *output nghĩa là gì* để chỉ huy và review, đủ để đặc tả, không cần thành người vận hành.

---

**Vai trò đích:** AI Security Architect, người sở hữu kiến trúc và phán quyết, chỉ huy người hiện thực. garak, llm-guard, AI gateway là gạch; tài liệu này là bản vẽ.
