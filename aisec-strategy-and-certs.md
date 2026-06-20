# AI Sec: chiến lược, cert và career

> Vai trò trong project: đây là **lớp chiến lược cộng cert cộng định vị nghề** của track AI Security, lớp đổi theo thị trường. Mô hình domain (kiến trúc, bền) ở `aisec-domain-model.md`; lịch học hằng tuần ở `aisec-learning-schedule.md`; sprint hands-on ở `Planning_Moat1_AI_Security_Hands-on_Sprint-1.md`.
>
> File này gộp từ 3 bản cũ (multi-year roadmap, reference career roadmap, mentor roadmap). Calibration canonical: **Middle ở ops bảo mật (vùng CySA), Junior ở audit/assurance (vùng CISA), mạnh ở security architecture.** Một verdict mâu thuẫn về CySA+ đã được resolve (xem mục Chiến lược cert).

---

## 0. Hồ sơ và ràng buộc

- **Ai:** infra/security architect kiêm tư vấn Gov/FSI/enterprise (VN), đi lên từ thực chiến. Reason tốt ở tầng kiến trúc; bản năng vận hành mạnh nhưng formal framework/vocabulary còn patchy (nguồn của cảm giác thiếu tự tin).
- **Level tự chốt:** Middle ở ops (blue/purple/SOC/vuln mgmt/detection, vùng CySA); Junior ở audit/assurance (vùng CISA); mạnh ở security architecture.
- **Ràng buộc:** 15h/tuần; tài liệu tiếng Anh; ngân sách mở miễn có giá trị thực; ưu tiên hành động, đo bằng bằng chứng, ghét fluff, không em dash.
- **Mục tiêu:** chuyên môn hoá **AI security (Moat 1)** cộng **AI assurance (Moat 5)** bền vững, đặt TRÊN nền security broad cộng architecture, monetize qua tệp Gov/FSI hiện có.

> **Calibration note (đọc trước):** người đi lên từ tay nghề thường UNDER-rate mảng họ làm tay hằng ngày. Level tự khai trên có thể thấp hơn thực tế. Với anh, CySA+/CISA thường là "đặt tên và sắp xếp cái đã làm theo phản xạ" chứ không phải học từ số 0, nên nhanh hơn và fix đúng confidence gap. Nên chạy một phiên **ASSESS** (profile-mentor) sớm để đo level thật, đặc biệt blue/purple, NGFW cộng config review, vuln mgmt, threat intel.

---

## 1. Luận điểm chiến lược (vì sao đi đường này)

- **AI commoditize phần toil tầng junior** (SOC T1-T2, pentest web cơ bản, viết compliance doc, malware/phishing triage thường quy). Phần bền cần một trong: AI là bề mặt tấn công mới; thế giới vật lý; ràng buộc pháp lý cấm giao AI; người phải chịu trách nhiệm pháp lý; người độc lập attest.
- **Hai moat đã chọn:** Moat 1 = Security *for* AI (bảo vệ chính con AI). Moat 5 = Assurance (chứng minh con AI đáng tin).
- **Ba ô đừng lẫn:**
  - (A) **AI for Security** (dùng AI để canh công ty) = table stakes đang commoditize, **KHÔNG phải moat**.
  - (B) **Security for AI** = Moat 1, là **enabler** để dám deploy AI, không phải phanh. Ô offensive/kỹ thuật nhất.
  - (C) **Governance/Assurance** = Moat 5, là **giấy phép** để ship trong môi trường quản lý.
- **Thị trường:** dịch chuyển từ hỏi-đáp sang **agentic** (79% doanh nghiệp adopt agent, chỉ 11% production; khoảng cách bị chặn đúng bởi data access cộng security cộng governance). Gartner: dưới 5% lên khoảng 40% ứng dụng nhúng agent trong 2026. VN trễ 2-4 năm = **cửa sổ chuẩn bị**; **sovereign AI** kéo Gov/FSI tới nhanh hơn đường cong chung.
- **Khung đúng:** đây là **consulting/advisory play trên khách hiện có**, KHÔNG phải nộp đơn xin việc. Headcount chuyên trách ít, nhưng với người tư vấn thì khan hiếm nguồn cung = quyền định giá.
- **On-ramp bán được NGAY ở giai đoạn hỏi-đáp:** AI-use governance cộng **DLP** (chống nhân viên dán dữ liệu NDA/Gov/FSI vào model ngoài). Là cầu vào Moat 5 cộng một lát Moat 1. DLP là **tầng hạ tầng của on-ramp**, không phải đích; chỉ là bước đệm nếu gói trong framing governance và kéo dài sang AI-native data control (redact trên inference path, AI gateway).

**Hai moat chia chung khoảng 40% nền rồi rẽ.** Phần chung: hiểu LLM/ML chạy thế nào, threat landscape (OWASP LLM Top 10, MITRE ATLAS), ba framework governance ai cũng nhắc (NIST AI RMF, ISO/IEC 42001, EU AI Act). Sau đó Moat 1 rẽ technical/offensive-defensive (Python, adversarial ML, red-team tooling, MLSecOps), Moat 5 rẽ process/evidence/attestation (audit methodology, conformity assessment, control testing, ISAE 3000).

**Không cần thành data scientist cho cả hai.** Moat 1 cần Python *làm việc được* (đọc/sửa script, dùng library, chạy Jupyter) cộng ML khái niệm (embeddings, RAG, fine-tuning, tokenization), đủ để vận hành garak/PyRIT; không cần train model từ đầu hay master đại số tuyến tính. Moat 5 cần ít code hơn nữa; giá trị là audit rigor, control design, regulatory mapping.

**Tilt khởi đầu:** dẫn bằng moat gần doanh thu hiện tại nhất. Với senior compliance-and-architecture phục vụ Gov/FSI, **dẫn Moat 5 (AIGP trước)** vì monetize nhanh nhất sức mạnh đang có và đường cầu EU AI Act/ISO 42001 đang dốc; rồi layer Moat 1 để khác biệt (ít auditor red-team được, kết hợp đó hiếm và đắt giá). Vì calibration Middle/Junior, **track nền cộng breadth (CySA+, CISA) chạy SONG SONG sớm**, không đợi.

---

## 2. Mô hình sự nghiệp: senior hình lược (comb-shaped)

```
   AI Sec   AI Assurance   Security Architecture     <- răng lược (depth, khác biệt hoá)
     |            |                 |
 ----+------------+-----------------+--------------  <- thanh ngang: BREADTH
 blue · purple · red · vuln mgmt · CVE/TI · firewall/config review · detection · IR
                         |
                  +------+------+
                  | Leadership   |                    <- nắp: accountability tier
                  | (CISO-track) |
                  +-------------+
```

- **Thanh ngang (breadth)** = nền uy tín và phán đoán. AI commoditize *phiên bản junior* của nó (SOC T1-T2); ở tầng senior nó là judgment cộng orchestration, phần sống sót.
- **Răng lược (depth)** = nơi anh khác biệt: AI security (Moat 1), AI assurance (Moat 5), security architecture.
- **Nắp (leadership)** = tier trách nhiệm, "người ký", moat bền nhất.
- Nguyên tắc: **đừng đua toil với AI**; leo lên orchestrate/architect/assure, dùng AI là răng lược kịp thời. Breadth của anh **không bị thay, nó mở rộng vào AI**.

### Bốn track

| Track | Mục tiêu | Anh làm gì |
|---|---|---|
| **A: Nền cộng cert chiến lược** | Validate nền cộng mở khoá flagship AI | Lấy cert theo thang prereq (mục 3); không học lại cái đã giỏi |
| **B: Breadth (duy trì cộng mở rộng AI)** | Giữ nền hiện tại sắc cộng nối vào AI | Maintain blue/purple/red, vuln mgmt, TI, config review; **mở rộng từng cái sang AI** (mục 5) |
| **C: AI Spike (Moat 1 cộng 5)** | Năng lực AI Security Architect | Phase 0 đến D của mô hình domain (`aisec-domain-model.md`); lịch ở `aisec-learning-schedule.md` |
| **D: Ascent kiến trúc cộng lãnh đạo** | Lên tier architect cộng accountability | Security architecture tổng thể cộng một engagement thật cộng định vị CISO-track |

---

## 3. Chiến lược cert

### Bảng verdict (recalibrated cho Middle/Junior)

| Cert | Verdict cho anh | Khi nào | Vai trò / prereq-unlock |
|---|---|---|---|
| **CySA+** | **Nên làm** | Quý 1-2 | Đóng khung nền blue/SOC/vuln/TI cộng tăng tự tin cho ops base |
| **CISA** | **Nên, học foundation thật** | Quý 2-4 | Nền audit; **prereq mở khoá AAIA**; nể ở FSI |
| **AIGP** | Nên, làm sớm | Quý 1 | AI governance; no prereq; monetize sớm; khoảng 799 USD |
| **ISO 42001 LA** | Nên | Phase C (khoảng tháng 6-9) | AI assurance/conformity; ghép nền ISO 27001; khoảng 799 USD |
| **CISSP hoặc CISM** | Nên (1 trong 2) | Năm 2 | Baseline/leadership; **mở khoá AAISM** |
| **AAIA** | Nếu đã có CISA/CIA/CPA | Phase D | AI audit flagship (**cần CISA trước**) |
| **AAISM** | Nếu đã có CISM/CISSP | Năm 2+ | AI security mgmt (**cần CISM/CISSP trước**) |
| **CCISO** | Tuỳ chọn muộn | Năm 3+ | Executive positioning; trọng số thấp hơn CISSP/CISM |
| CompTIA SecAI+ | Watch, đừng vội | Khi đủ traction | Mới (17/02/2026), brand nền/mid ổn, recognition chưa rõ |
| AI-900 | Tuỳ chọn rẻ | Sớm nếu muốn | Vocab nền AI/ML; retire 30/06/2026, check successor trước khi mua |
| GAIPS / GOAA (GIAC) | Premium, nếu employer trả | Năm 2+ | Moat 1 flagship/offensive; GIAC ANAB-accredited |
| CAISP | Value pick Moat 1 | Năm 1-2 | Thay thế rẻ cho SANS, nhiều giờ lab/đô hơn |
| AAIR (ISACA) | Đánh giá sau | Sau Q2 2026 ổn định | AI risk; còn beta |
| BABL AI / ForHumanity FHCA | Optional depth | Tuỳ | Học methodology audit; chưa government-accredited |

**Thang prereq:** AIGP -> CySA+ -> CISA -> AAIA. Nhánh song song: CISSP/CISM -> AAISM.

> **Insight chốt:** CISA và (CISSP hoặc CISM) **không chỉ là đệm**. Chúng là prereq mở khoá hai flagship AI của ISACA. Cert nền và cert moat là **một cái thang**, không phải hai việc rời.

> **Đã resolve (CySA+):** giữ verdict "Nên làm" theo calibration Middle ở vùng blue/SOC. Một bản cũ calibrate theo "self-declared senior" từng phán CySA+ là "bỏ qua, dưới level anh"; bản đó đã bị xóa để corpus không mang hai verdict mâu thuẫn. Verdict này **lật lại thành "bỏ qua"** chỉ khi một phiên ASSESS đo ra anh thật sự senior vững ở blue/purple/detection. Tới lúc đó, "nên làm" là mặc định an toàn (đóng khung cộng tăng tự tin rẻ hơn rủi ro bỏ sót gap).

### Honest assessment từng cert (giá xấp xỉ USD, verify trang chính thức trước khi mua)

**Nền/shared**

- **AI-900 (Microsoft, exam khoảng 99):** vocab nền AI/ML/Azure, không phải differentiator. Lịch retire 30/06/2026, kiểm tra successor (AI-901) trước khi mua.
- **CISSP/CISA/CISM đang có:** baseline để vào phỏng vấn, và là prereq mở khoá ISACA AI certs. Giữ active.

**Moat 1**

- **GIAC GAIPS** (gắn SEC545 GenAI & LLM Application Security): course cộng cert thường 8,000 đến 9,000 (SEC545 từ khoảng 8,260). Exam CyberLive hands-on. Validate năng lực audit cộng secure GenAI app cộng LLM pipeline (GenAI fundamentals, RAG/agent security, MCP, MLSecOps, MAESTRO). Bán lẻ từ 28/07/2026. Premium, được Gov/regulated công nhận (GIAC là body ANAB ISO/IEC 17024). Best-in-class nếu đủ ngân sách, hợp Gov/FSI.
- **GIAC GOAA** (gắn SEC535 Offensive AI, 3 ngày, 14 lab): offensive/red-team. Cùng tier giá SANS. Mới (2026), mạnh cho nửa offensive Moat 1.
- **CAISP (Practical DevSecOps, khoảng 999 đến 1,099):** self-paced, 30+ bài, 60 ngày lab browser, task-based exam, 36 CPE, không phí gia hạn. Quanh OWASP LLM Top 10 cộng MITRE ATLAS. Rẻ hơn SANS, nhiều giờ lab/đô hơn; vendor-issued nên ít recognition hơn GIAC, nhưng thực dụng thật. Lựa chọn value mạnh.
- **ISACA AAISM** (exam 459 member / 599 non, cộng 50 application; **cần CISM hoặc CISSP active**): 90 câu, 2.5h, pass 450/800. 3 domain (Governance & Program Mgmt 31%, Risk & Opportunity 31%, Technologies & Controls 38%). Maintenance 10 CPE/yr AI (30/3yr), phí 20/35 USD/yr. Đáng nếu có CISM/CISSP và muốn tín hiệu leadership/architecture hơn hands-on hacking. Mới (19/08/2025) nhưng brand ISACA nặng ở Gov/FSI/audit.
- **CompTIA SecAI+ (CY0-001):** launch 17/02/2026; khuyến nghị 3-4 năm IT cộng 2+ năm security. Quá mới để đánh giá recognition; brand CompTIA ổn ở tier nền/mid. Watch, đừng rush.
- **Microsoft Azure AI Security (vendor, khoảng 165):** chỉ nếu khách Azure-heavy.

**Moat 5**

- **IAPP AIGP** (exam 799 non / 649 member; retake 625/475; **no prereq**; BoK v2.1 hiệu lực 02/02/2026; 100 câu, 2.75h, pass 300/500; 2 năm, 20 CPE): credential AI governance được công nhận nhất, first cert tốt nhất cho Moat 5. Caveat: chưa ANAB-accredited (khác CIPP/CIPM/CIPT của IAPP). Vẫn là leader thị trường, cung chưa đủ cầu.
- **ISACA AAIA** (exam 459 member / 599 non, cộng 50 application; **cần CISA, CIA, hoặc CPA active**, mở rộng 07/2025 sang ACCA/FCCA, Canadian CPA, CPA Australia/FCPA, Japanese CPA, ICAEW ACA): 90 câu, 2.5h, pass 450/800. 3 domain (Governance & Risk 33%, Operations, Audit Tools & Techniques). Maintenance 10 CPE/yr AI. All-in khoảng 850 đến 1,100. First purpose-built AI audit credential, flagship tự nhiên cho Moat 5 nếu có audit credential đủ điều kiện. Khan hiếm người đủ tiêu chuẩn = tín hiệu thật. Công bố 19/05/2025.
- **PECB ISO/IEC 42001 Lead Auditor** (khoảng 799 self-study / 899 eLearning, gồm exam cộng 2 lần thi lại cộng 31 CPD): audit AIMS theo ISO 19011 / ISO/IEC 17021-1. Giá trị thực dụng cao cho mảng conformity của Moat 5, nhất là khách EU-exposed. Ghép nền ISO 27001 của anh. Đặc biệt liên quan EU, UAE, Singapore, UK.
- **PECB ISO/IEC 42001 Lead Implementer** (instructor-led thường khoảng 3,000; có tier self-study/eLearning rẻ hơn): để build/run AIMS thay vì audit. Chọn Auditor cho independent assurance; Implementer nếu tư vấn khách build hệ. Nhiều người đi Foundation -> Implementer -> Auditor.
- **ISACA AAIR** (launch Q2 2026, còn volunteer beta; giá chưa chốt, ước khoảng 575 member / 760 non): domain AI Risk Governance & Framework Integration, AI Risk Program Mgmt, AI Life Cycle Risk Mgmt. Mới nhất bộ ba ISACA; đánh giá sau khi ổn định.
- **BABL AI / ForHumanity FHCA:** credential independent-auditor do vendor/nonprofit cấp. Uy tín trong cộng đồng responsible-AI, tốt để học methodology audit, nhưng chưa government-accredited. Optional depth, không phải market gate.

> **Take thẳng về hype:** số lương trong blog vendor (150k đến 280k USD AI security; 182k AI governance) là marketing, không phải bằng chứng. Cert có tín hiệu bền: AIGP, bộ ba advanced ISACA (gated bởi prereq thật), PECB 42001, bộ AI của GIAC. Mọi thứ gắn nhãn "masterclass" trên Udemy là study aid, không phải credential.
>
> **Đừng mua** cert mới toanh (CompTIA SecAI+, ISACA AAIR) cho tới khi có 12+ tháng traction thị trường.

### Ngưỡng làm đổi kế hoạch

- *Nếu không giữ nổi 15h/tuần:* rút về một moat (Moat 5) và kéo Năm 1 thành 18 tháng.
- *Nếu khách bắt buộc EU AI Act conformity:* fast-track ISO 42001 Lead Auditor trước Moat 1.
- *Nếu muốn khác biệt kỹ thuật tối đa:* đảo, làm CAISP/SEC545 trước, AIGP sau.
- *Nếu ngân sách chặt:* toàn bộ foundation cộng AIGP cộng PECB 42001 cộng CAISP làm được trong khoảng 2,500 đến 3,000 USD bằng audit-mode/free course cộng free lab cộng self-study; bỏ SANS trừ khi employer trả.

---

## 4. Timeline

- **Quý 1 (tháng 0-3):** AIGP cộng Foundation AI (8 lớp, OWASP, ATLAS) cộng khởi động CySA+. Breadth chạy nền.
- **Quý 2 (3-6):** thi CySA+ cộng bắt đầu CISA cộng AI Phase A-B (control catalog, threat modeling).
- **H2 năm 1 (6-12):** thi CISA cộng AI Phase C cộng ISO 42001 LA; AI Phase D cộng AAIA. Tài sản assessment thành hình.
- **Năm 2 (12-24):** CISSP hoặc CISM; security architecture tổng thể; AAISM nếu đi nhánh đó.
- **Năm 2-3 (24-30):** accountability tier cộng một engagement thật end-to-end (kiến trúc cộng assess), publish.

Bức tranh đầy đủ khoảng 30 tháng (nền cộng breadth cộng spike cộng ascent); riêng AI spike khoảng 12 tháng và chạy SONG SONG với track nền.

---

## 5. Bản đồ tích hợp: breadth mở rộng vào AI (không bị thay)

| Broad đang có | Mở rộng sang AI thành | Bám lớp nào (xem `aisec-domain-model.md`) |
|---|---|---|
| Vuln mgmt cộng CVE | Model/dependency CVE cộng AIBOM cộng model supply chain | L3 Model |
| Threat intel | MITRE ATLAS (ATT&CK cho AI) | L7 cộng threat model |
| Blue / detection / alerting | AI observability (logging, eval, anomaly, drift) | L7 |
| Firewall / config review cộng zoning | AI gateway cộng egress control cộng agent zoning | L2 / L6 / L5 |
| Purple team | AI red-team-as-CI-gate | L7 cộng Phase D |
| Incident response | IR cho AI incident (model abuse, agent compromise, prompt-injection breach) | L0 / L7 |

> Đây là phần trấn an có căn cứ: anh không vứt gì cả. Mỗi mảng broad là substrate để răng lược AI mọc lên, và đó cũng là điểm khác biệt của anh so với một người AI-only không có nền defense thật.

### Quan hệ với Enterprise Architecture (EA)

Không "inseparable" mà **ghép chặt tại mối nối có tên** (phân loại dữ liệu, identity spine, risk/compliance taxonomy), nhưng là **practice riêng**, tự chủ về nhịp (EA chậm, AI threat đổi theo tháng) và về phương pháp (nửa offensive của AI security không phải paradigm gốc của EA). Bề mặt rủi ro **tràn ra ngoài biên EA** (shadow AI, AI trong SaaS/chuỗi cung ứng). Loại suy chuẩn: SABSA so với TOGAF (ánh xạ được, method riêng, không hoà tan).

---

## 6. Cách học (operating model)

- **Nhịp tuần (15h):** chi tiết hour-by-hour ở `aisec-learning-schedule.md` (6h đọc, 5h dựng artifact, 2h review, 2h ôn cert). Không lặp ở đây để tránh trùng.
- **Mỗi phase đẻ một artifact kiểu HLD** = vừa là skill vừa là tài sản Gov/FSI (không phải chi phí chìm).
- **Vòng theo dõi tiến bộ (profile-mentor):** ASSESS (đo level bằng câu hỏi-rubric, có gotcha, không Google) -> ghi `competency-matrix.md` -> DRILL (lab chạy trên kit thật) -> REVIEW mỗi 4-6 tuần. Ưu tiên theo **rủi ro nhân khoảng cách nhân khớp mục tiêu**, không theo điểm thấp đơn thuần.
- **3 file state trong group:** `about-me.md`, `competency-matrix.md`, `growth-backlog.md`.
- **Literacy, không phải fluency:** anh đọc kiến trúc, đặc tả control, đọc hiểu bằng chứng (báo cáo garak/eval). Phần gõ phím delegate cho implementer/junior/AI assistant dưới chỉ huy của anh. Giá trị bền là kiến trúc cộng phán quyết, không phải cú pháp.

---

## 7. Việc cần làm khi kích hoạt track này

1. Chạy **profile-mentor ASSESS** sớm để đo level thật (anh hay under-rate): blue/purple, NGFW cộng config review, vuln mgmt, threat intel; dựng `competency-matrix.md`.
2. Báo các cert đang giữ (CISSP? CISA? CISM?) để **gập thang cert**, bỏ bước thừa và mở khoá AAIA/AAISM sớm nếu đủ prereq.
3. Chốt **fork**: khách Gov/FSI đang ở mức hỏi-đáp hay đã có agent hành động -> đổi trọng số Phase C/D.
4. Bắt đầu Quý 1: **AIGP cộng Foundation AI cộng khởi động CySA+**.

---

## 8. Tầm nhìn endpoint (3-5 năm)

Một senior security architect/leader mà practice trải defense ops (judgment, không phải toil) cộng architecture cộng assurance, với AI security và AI assurance là hai răng lược khác biệt hoá, định vị ở tier trách nhiệm (người ký, người regulator/HĐQT/bảo hiểm cần). AI ăn toil operational tầng junior; anh ngồi ở tầng orchestrate/architect/assure. Hình lược bền vì không một lớp nào đứng một mình, và vì bốn moat (architecture cộng AI security cộng assurance cộng accountability) chồng đúng lên hình này.

---

## 9. Caveat thật

- **Space đổi theo tháng.** Nhiều flagship mới: ISACA AAIA (19/05/2025) cộng AAISM (19/08/2025), AAIR (Q2 2026, beta), GIAC GAIPS (GA 28/07/2026) cộng GOAA, CompTIA SecAI+ (17/02/2026). Recognition data mỏng; nghi ngờ mọi số "market value"/lương 2025-2026, nhất là số từ vendor.
- **EU AI Act timing đang trôi.** Mốc high-risk 02/08/2026 hay được nhắc đang bị dời: 07/05/2026 EU đạt political agreement ("Digital Omnibus") đẩy nghĩa vụ Annex III high-risk sang **02/12/2027** (Annex I product-related sang 08/2028), chờ formal adoption. Nếu không adopt kịp thì mốc 02/08/2026 giữ nguyên. Track trực tiếp trước khi tư vấn khách. Phần NIST AI RMF cộng ISO 42001 đứng vững bất kể.
- **Số lương/ROI online phần lớn từ marketing vendor**, đừng dựa để ra quyết định tài chính.
- **Giá xấp xỉ USD;** phí ISACA/IAPP/PECB đổi theo membership/region, SANS đổi giá, exam fee đổi. Verify trang chính thức trước khi mua.
- **AI assurance như nghề độc lập đang nổi nhưng immature:** chuẩn năng lực auditor, hạ tầng accreditation (ISO/IEC 42006:2025), methodology còn đang chốt. Cơ hội thật chính vì còn sớm; FHCA/BABL là path học đáng tin nhưng chưa là market gate.
- **Legal/ethical:** chỉ chạy offensive AI tooling lên hệ anh sở hữu hoặc được phép test; không bao giờ lên public third-party API.
- **ISACA AAIA/AAISM** giới hạn physical testing center (no live remote proctoring) cho cư dân India, Mainland China, Hong Kong; verify testing-center cho VN trước khi đăng ký.
- **Thang cert phụ thuộc cái đã có;** mọi verdict cộng timeline calibrate theo tự khai cho tới khi ASSESS đo lại; level thật có thể cao hơn.

---

## 10. Tài nguyên (tiếng Anh, globally accessible)

> Hands-on lab execution chi tiết tách ở `Planning_Moat1_AI_Security_Hands-on_Sprint-1.md` cộng hướng dẫn cài lab RAG. Phần dưới là danh mục tham chiếu.

**Khóa học chọn lọc**

- AI Python for Beginners (DeepLearning.AI, Coursera). Nền shared. coursera.org/learn/ai-python-for-beginners
- Microsoft AI-900 Exam Prep Specialization (Coursera). Nền shared. exam khoảng 99.
- Red Teaming LLM Applications (DeepLearning.AI cộng Giskard). Moat 1 nhập môn. deeplearning.ai/courses/red-teaming-llm-applications
- SEC545 GenAI & LLM Application Security (SANS) -> GIAC GAIPS. Moat 1 flagship. khoảng 8,260+.
- SEC535 Offensive AI (SANS) -> GIAC GOAA. Moat 1 offensive.
- CAISP (Practical DevSecOps). Moat 1 flagship rẻ. khoảng 999 đến 1,099. practical-devsecops.com
- Secure AI: Red-Teaming & Safety Filters (Coursera). PyRIT, garak, Promptfoo. Moat 1.
- AIGP Online Training (IAPP). Moat 5 flagship prep. khoảng 995 (third-party prep rẻ hơn). store.iapp.org
- PECB ISO/IEC 42001 Lead Auditor. Moat 5. self-study khoảng 799. pecb.com
- BABL AI: AI & Algorithm Auditor Certificate Program. Moat 5 methodology depth. khoảng 899 đến 1,199. babl.ai
- (Free) ISACA "Introduction to AI for Auditors" cộng "Auditing Generative AI" cộng AI Audit Toolkit; ForHumanity "Foundations of Independent Audit of AI Systems".

**Lab platforms / practice (chủ yếu free)**

- Gandalf (gandalf.lakera.ai): prompt-injection 7+ level. Điểm khởi đầu canonical. Lakera cũng có dataset 279,000 prompt attacks (arXiv:2501.07927) trên Hugging Face.
- HackAPrompt (Learn Prompting): AI red-teaming competition.
- PortSwigger Web Security Academy LLM attacks: 4 lab (indirect prompt injection, data exfiltration, cross-user leakage, excessive agency). Methodology-driven.
- MITRE ATLAS (atlas.mitre.org): knowledge base adversarial-ML cộng Navigator cộng case studies. Release 2026.05: 16 tactics, 170 techniques, 35 mitigations, 57 case studies.
- OWASP GenAI Security Project (genai.owasp.org): LLM Top 10 (2025), Agentic Top 10 (2026), AI Red Teaming Guide, AIBOM generator, governance checklist.
- Arcanum AI Security Lab Hub; Hugging Face; Kaggle; DEF CON AI Village; DeepTeam/Promptfoo/Giskard hubs.

**Home lab cộng tools** (laptop 16-32 GB RAM đủ; GPU chỉ cần nếu fine-tune)

- Ollama / LM Studio (chạy local LLM offline: llama3.2, mistral, qwen2.5, nomic-embed-text).
- garak (NVIDIA): scanner vuln LLM rộng, "Nmap for LLMs". `pip install garak`.
- PyRIT (Microsoft): multi-turn adaptive red-teaming (Crescendo, TAP, Skeleton Key); chạy Jupyter; MIT.
- Promptfoo: eval/regression harness CI/CD với preset OWASP/NIST (thông báo OpenAI mua 03/2026; open-source tiếp tục).
- llm-guard (Protect AI), NeMo Guardrails (NVIDIA): lớp defensive để học mitigation.
- LangChain cộng vector DB (Qdrant/Chroma): dựng RAG/agent app để tự tấn công.
- Moat 5: workflow GRC/templates (AI system inventory, risk register, model cards, crosswalk NIST/ISO/EU AI Act) trong Notion/Excel.

> **Critical rule:** không bao giờ bắn automated attack tool vào public third-party API (OpenAI, Azure OpenAI, Google, Anthropic); dùng local Ollama hoặc app của chính anh, kẻo bị ban.

**Lab project ladder** (chi tiết execution ở `Planning_Moat1...`)

- Moat 1: (1) Beat Gandalf cộng baseline garak scan; (2) Attack vulnerable agent (DVLA/DVAIA), map sang OWASP Agentic Top 10 cộng ATLAS; (3) Build/break/defend/CI-gate (LangChain cộng Qdrant cộng Ollama, PyRIT Crescendo, llm-guard/NeMo, Promptfoo trong CI, viết red-team report có CVSS).
- Moat 5: (1) Map một hệ sang NIST AI RMF (Govern/Map/Measure/Manage); (2) ISO 42001 gap analysis cộng crosswalk cho model credit-scoring FSI giả định; (3) Mock conformity assessment EU AI Act high-risk (technical doc, risk evidence, bias/fairness, dùng lại output red-team Moat 1 làm evidence, mock assurance report kiểu ISAE 3000). Đây là chỗ hai moat fuse.

**Frameworks/standards (free, học trực tiếp)**

- OWASP LLM Top 10 (2025) cộng Agentic Top 10 (2026); MITRE ATLAS; NIST AI RMF 1.0 (AI 100-1) cộng Playbook cộng GenAI Profile (AI 600-1) cộng Adversarial ML taxonomy (AI 100-2); ISO/IEC 42001:2023, 23894, 42006:2025; EU AI Act (prohibited practices từ 02/02/2025, GPAI từ 02/08/2025); Google SAIF 2.0, Databricks DASF 3.0, CSA AI Controls Matrix, MAESTRO; AIDEFEND (aidefend.net).

**Sách**

- The Developer's Playbook for Large Language Model Security (Steve Wilson, O'Reilly).
- AI-Native LLM Security (Vaibhav Malik, Ken Huang, Ads Dawson; Packt, 12/2025).
- Adversarial AI Attacks, Mitigations, and Defense Strategies.
- Moat 5: ISACA AAIA Review Manual cộng QAE; IAPP AIGP textbook/BoK v2.1; ISO/IEC 42001 cộng ISO 19011; ISACA CISA Review Manual (nếu theo prereq).

**Blog/newsletter/người theo dõi**

- OWASP GenAI Security Project blog; Lakera blog; Trail of Bits blog.
- Người: Steve Wilson, Ken Huang, Ads Dawson (AI security/OWASP); Shea Brown (BABL AI), Ryan Carrier (ForHumanity) (audit/assurance); Lalit Choda ("Mr. NHI") (non-human identity).
- Newsletter: "Stats and Bytes"; AISecHub. Governance: IAPP Resource Center; NIST AI Resource Center; CSA AI Safety working groups.
