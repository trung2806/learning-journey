#!/usr/bin/env bash
# Prepend CORRECTION banner (Day 27 reckoning) vào 11 entry Day 16-26.
# Idempotent: chạy lại không nhân đôi. Tự tìm file dù phẳng hay dưới daily/.
set -euo pipefail
JOURNAL_DIR="${JOURNAL_DIR:-$HOME/work/learning/learning-journal}"
MARK="CORRECTION (Day 27 reckoning"
 
annotate () {
  local fname="$1"; local banner="$2"; local path
  path="$(find "$JOURNAL_DIR" -name "$fname" -type f 2>/dev/null | head -1 || true)"
  if [ -z "$path" ]; then echo "SKIP (không thấy $fname dưới $JOURNAL_DIR)"; return; fi
  if grep -qF "$MARK" "$path"; then echo "đã annotate, bỏ qua: $path"; return; fi
  { printf '%s\n\n' "$banner"; cat "$path"; } > "$path.tmp" && mv "$path.tmp" "$path"
  echo "annotated: $path"
}
 
HDR='> ⚠️ CORRECTION (Day 27 reckoning, 2026-06-20 — đối chiếu bằng `find ~` + `pytest --collect-only`). Tại đầu Day 27 trên đĩa CHỈ có `srl_engine.py` + `test_srl_engine.py` (6 test). Phần dưới giữ nguyên để làm bản ghi, nhưng các điểm sau trong entry này CHƯA TỪNG ở đĩa:'
FTR='> Bản ghi đúng: Day 27 (2026-06-20, reckoning ba tầng drift) + baseline Day 28 (28 green trên real shape, có git mốc).'
 
read -r -d '' B16 <<SRLEOF || true
$HDR
> — PHANTOM: \`test_srl_app.py\` (7 test), tầng \`build_row\`, wire PUSH/PULL. Không có trên đĩa.
> — GIỮ (thật): kỷ luật capture-trước-code; lesson 2-trục lỗi Transport/Parse.
$FTR
SRLEOF
 
read -r -d '' B17 <<SRLEOF || true
$HDR
> — PHANTOM: platform \`dispatch\` + \`registry\` + \`build_row\` (per-cell ladder, errors_collected); đếm "10 test xanh".
> — GIỮ (thật): lesson false-green / parser-hardcode-đội-lốt-thật; RED-on-defect.
$FTR
SRLEOF
 
read -r -d '' B18 <<SRLEOF || true
$HDR
> — PHANTOM: \`ios_engine.py\` move + tầng app; đếm "17/17 xanh".
> — GIỮ (thật, vẫn áp tới Day 28): rule fixture-echo, honest-stub, negative-pin, evidence-ordering.
$FTR
SRLEOF
 
read -r -d '' B19 <<SRLEOF || true
$HDR
> — Entry tự ghi "không có dòng code mới" → KHÔNG có green-count phantom ở đây (đúng kỷ luật).
> — SUPERSEDED: doc-fact 22-3 \`cpuacct-statistics\` bị capture Day 20 lật (FALSE cho 26.3.2). Tầng alert/display set up từ đây về sau KHÔNG được build.
> — GIỮ (thật): criterion pin-count-theo-hậu-quả; doc-echo/device-truth.
$FTR
SRLEOF
 
read -r -d '' B20 <<SRLEOF || true
$HDR
> — THẬT, đã được \`control_A.json\` xác nhận lại ở Day 27/28: shape cpu = \`control[].cpu[]\`, \`index=="all"\`, \`total.instant/average-1\`, %-nguyên 0..100. Đây là shape ĐÚNG.
> — PHANTOM/REGRESSED: \`parse_cpu_aggregate\` list-based viết ở đây KHÔNG sống tới Day 27 — repo Day 27 có cpu parser dict-based VỠ; tầng credential-guard/inventory không có trên đĩa. Fixture vẫn trim (entry tự ghi "còn nợ verbatim").
$FTR
SRLEOF
 
read -r -d '' B21 <<SRLEOF || true
$HDR
> — PHANTOM: đếm "14 test"; tầng \`validate_inventory_credentials\`/inventory. Trên đĩa Day 27: \`test_srl_engine.py\` = 6 test.
> — LƯU Ý: anchor "real" 6/2/28 lệch \`control_A.json\` (2/29/50) — sample khác hoặc chưa verbatim. memory parser (khái niệm) sống thành \`parse_memory_utilization\`.
$FTR
SRLEOF
 
read -r -d '' B22 <<SRLEOF || true
$HDR
> — PHANTOM: \`srl_display.py\` (\`render_pct\`, \`render_metrics_for_humans\`) + orchestrator %-render; đếm "19 xanh (5 display + 14 engine)". Day 27 không tìm thấy display layer.
> — GIỮ (thật): lesson stand-in-green ≠ real-bytes-green (Day 27/28 chứng minh lại).
$FTR
SRLEOF
 
read -r -d '' B23 <<SRLEOF || true
$HDR
> — PHANTOM: \`srl_alert.py\` (\`CpuAlert\`, \`evaluate_cpu_alert\`), type \`CpuAggregate\`; đếm "11 test mới (8 alert + 3 guard)". Day 27: KHÔNG có \`srl_alert.py\` trên đĩa. Day 28 mới viết alert thật: MỘT \`evaluate_alert\` scalar, KHÔNG \`CpuAggregate\`.
> — GIỮ (thật, Day 28 giữ y): đọc \`average-1\` không \`instant\`; strict \`>\` pin hai phía.
$FTR
SRLEOF
 
read -r -d '' B24 <<SRLEOF || true
$HDR
> — PHANTOM: \`MetricAlert\` + \`evaluate_memory_alert\`; đếm "17 xanh (9 cpu + 8 memory)". Alert layer journal-only.
$FTR
SRLEOF
 
read -r -d '' B25 <<SRLEOF || true
$HDR
> — PHANTOM: \`evaluate_temperature_alert\`; helper \`_extract_control_zero\`/\`_guard_threshold\`/\`_check_breach\`; **\`parse_temperature\` design \`control[0]["temperature"]["sensor"]\` → \`index=="all"\` → \`current\`** (CHƯA TỪNG tồn tại; repo dùng \`temperature.instant\`); đếm "25 alert".
> — CLAIM VERIFY SAI: entry kết luận "git log + pytest xác nhận repo ĐÃ có MetricAlert + 17 xanh → khả năng a (snapshot cũ)". Day 27 không tìm thấy \`srl_alert.py\` → đúng là khả năng b (alert trên giấy). "Verify bằng pytest" ở đây không đáng tin.
> — CREDIT: entry đã TỰ FLAG "31 CHƯA reconcile, không nhận '31 passed' là sạch" — đúng kỷ luật. Day 27 chốt: combined thật = 6.
$FTR
SRLEOF
 
read -r -d '' B26 <<SRLEOF || true
$HDR
> — RULING RETIRED: "giữ-ba-evaluator-tách" là ruling cho thiết kế ba-evaluator KHÔNG tồn tại trên đĩa; Day 27 collapse còn MỘT \`evaluate_alert\` (cả ba parser trả scalar trần, không field để chọn). Đúng cho thiết kế của nó, không chuyển sang được.
> — CREDIT: entry đã TỰ FLAG "KHÔNG khẳng định repo xanh: đặc tả action + expected" + "documented không bằng actualized" — đúng kỷ luật.
> — GIỮ (thật): pin no-range-check temperature (both-sides) — Day 28 \`parse_temperature\` giữ omission này.
$FTR
SRLEOF
 
annotate "2026-06-10.md"    "$B16"
annotate "2026-06-11.md"    "$B17"
annotate "2026-06-12.md"    "$B18"
annotate "2026-06-14.md"    "$B19"
annotate "2026-06-16.md"    "$B20"
annotate "2026-06-17.md"    "$B21"
annotate "2026-06-18.md"    "$B22"
annotate "2026-06-19.md"    "$B23"
annotate "2026-06-19-02.md" "$B24"
annotate "2026-06-19-03.md" "$B25"
annotate "2026-06-19-04.md" "$B26"
echo "--- xong ---"
