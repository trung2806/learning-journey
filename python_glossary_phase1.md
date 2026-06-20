# Python Glossary — Phase 1 Reference

*Tạo: 2026-05-29 (Day 5). Dùng tra cứu khi đọc code hoặc journal cảm thấy mơ hồ.*

30 thuật ngữ Python cốt lõi bạn sẽ gặp trong 4-6 tuần đầu Q1. Mỗi mục: định nghĩa 1 câu, ví dụ chạy được, ghi chú từ góc nhìn người làm network/system.

---

## Section 1 — Môi trường & tooling (Tuần 1)

### 1. `venv` (virtual environment)

**Là gì:** Thư mục cô lập chứa Python + các package riêng cho 1 project, không đụng vào Python hệ thống.

**Ví dụ:**
```bash
python3 -m venv .venv          # Tạo
source .venv/bin/activate      # Bật (Linux/Mac)
pip install netmiko            # Cài chỉ trong venv này
deactivate                     # Tắt
```

**Analogy network:** Giống mỗi VRF có routing table riêng. Mỗi project có venv riêng để package version không conflict.

**Quy tắc:** Mỗi project Python mới đều mở đầu bằng `python3 -m venv .venv` rồi activate. Không bao giờ `pip install` ở Python hệ thống.

---

### 2. `pip`

**Là gì:** Package manager mặc định của Python. Cài thư viện từ PyPI.

**Ví dụ:**
```bash
pip install requests           # Cài 1 package
pip install -r requirements.txt   # Cài từ list
pip freeze > requirements.txt  # Export list package hiện tại
pip list                       # Liệt kê
```

**Analogy:** `apt` của Ubuntu nhưng cho Python.

---

### 3. `module` và `import`

**Là gì:** Module = 1 file `.py`. `import` để load module khác vào dùng.

**Ví dụ:**
```python
import json                    # Load toàn bộ module json
from pathlib import Path       # Load chỉ Path từ pathlib
import yaml as y               # Alias, gõ y. thay vì yaml.
```

**Quy tắc:** `from X import Y` chỉ load Y, nhanh hơn và rõ hơn `import X` rồi `X.Y`. Standard library nên `import X`, library lớn (numpy) thường alias (`import numpy as np`).

---

## Section 2 — Kiểu dữ liệu cơ bản (Tuần 1)

### 4. `int`, `float`, `bool`

**Là gì:** Số nguyên, số thực, true/false. Python tự suy ra type khi gán.

**Ví dụ:**
```python
age = 35                       # int
ratio = 3.14                   # float
is_active = True               # bool, viết hoa T và F
type(age)                      # <class 'int'>
```

**Trap:** `True + True == 2` trong Python vì `bool` là subclass của `int`. Đừng dùng tính chất này, viết code khó đọc.

---

### 5. `str` (string)

**Là gì:** Chuỗi ký tự. Immutable (không sửa được sau khi tạo).

**Ví dụ:**
```python
hostname = "core-sw-01"
hostname.upper()               # "CORE-SW-01" (trả về str mới, không sửa hostname)
hostname.split("-")            # ['core', 'sw', '01']
len(hostname)                  # 10
"core" in hostname             # True
```

**Quy tắc:** Quote đơn `'` và đôi `"` tương đương trong Python. Chọn 1 style và nhất quán (thường `"` cho text, `'` cho key/identifier).

---

### 6. `list`

**Là gì:** Mảng có thứ tự, mutable, có thể chứa kiểu khác nhau.

**Ví dụ:**
```python
devices = ["sw-01", "sw-02", "fw-01"]
devices[0]                     # "sw-01" (0-indexed!)
devices[-1]                    # "fw-01" (negative = từ cuối)
devices.append("sw-03")        # Thêm cuối
devices.remove("sw-02")        # Xoá theo value
len(devices)                   # 3
```

**Trap:** `list[1]` lấy phần tử thứ 2 (0-indexed). Khác Cisco IOS ACL index từ 10.

---

### 7. `dict` (dictionary)

**Là gì:** Map key-value. Tương đương HashMap / JSON object / YAML mapping.

**Ví dụ:**
```python
device = {
    "hostname": "core-sw-01",
    "ip": "10.0.0.1",
    "platform": "cisco_ios"
}
device["ip"]                   # "10.0.0.1"
device["role"] = "core"        # Thêm key mới
device.get("vendor", "unknown") # "unknown" nếu không có key
"hostname" in device           # True
```

**Quy tắc:** `dict.get(key, default)` an toàn hơn `dict[key]` (cái sau raise KeyError nếu thiếu key).

---

### 8. `tuple`

**Là gì:** Như list nhưng immutable. Khi tạo xong không sửa được.

**Ví dụ:**
```python
coordinates = (10.0, 20.5)
ip_port = ("10.0.0.1", 22)
host, port = ip_port           # Unpacking, host="10.0.0.1", port=22
```

**Khi dùng:** Khi data cố định (toạ độ, return nhiều giá trị từ function). Hashable nên làm key của dict được, list thì không.

---

### 9. `None`

**Là gì:** "Không có gì". Tương đương `null` của JSON, `None` của Java.

**Ví dụ:**
```python
result = None
if result is None:             # Dùng "is", không phải "=="
    print("No result yet")
```

**Quy tắc:** Luôn so sánh với `None` bằng `is None` / `is not None`. PEP 8 yêu cầu.

---

## Section 3 — Operator (Tuần 1)

### 10. Arithmetic & comparison

```python
# Số học
10 / 3                         # 3.333... (luôn float)
10 // 3                        # 3 (integer division)
10 % 3                         # 1 (modulo, dư)
2 ** 10                        # 1024 (luỹ thừa)

# So sánh
a == b                         # bằng giá trị
a is b                         # cùng object trong memory (khác == !)
a != b                         # khác
a >= b                         # lớn hơn hoặc bằng

# Logic
a and b                        # cả hai True
a or b                         # ít nhất 1 True
not a                          # đảo
```

**Trap:** `==` vs `is`. `[1,2] == [1,2]` True nhưng `[1,2] is [1,2]` False. Dùng `is` chỉ với `None`, `True`, `False`.

---

## Section 4 — Control flow (Tuần 1-2)

### 11. `if / elif / else`

```python
if temp > 80:
    status = "critical"
elif temp > 60:
    status = "warning"
else:
    status = "ok"
```

**Quy tắc:** Indent 4 space. Không có `{}` như C/Java. Indent SAI = code SAI.

---

### 12. `for` loop

```python
for device in devices:         # Lặp qua list
    print(device)

for i, device in enumerate(devices):    # Lặp có index
    print(f"{i}: {device}")

for key, value in device_dict.items():  # Lặp qua dict
    print(f"{key} = {value}")

for i in range(10):            # 0, 1, 2, ..., 9
    print(i)
```

**Quy tắc:** `for x in collection` là cách Pythonic. Đừng `for i in range(len(devices))` rồi `devices[i]`. Dùng `enumerate` nếu cần index.

---

### 13. `while` loop

```python
attempts = 0
while attempts < 3:
    if try_connect():
        break                  # Thoát loop
    attempts += 1
```

**Khi dùng:** Khi không biết trước số lần lặp. Cho lặp đã biết → `for`.

---

### 14. `break`, `continue`

```python
for device in devices:
    if device.is_down():
        continue               # Bỏ qua device này, sang device tiếp
    if device.is_critical():
        alert()
        break                  # Thoát loop ngay
```

---

## Section 5 — Function (Tuần 1-2)

### 15. `def` (function definition)

```python
def ping(ip, timeout=2):       # ip: required, timeout: optional với default
    """Ping a host. Return True if alive."""    # Docstring
    result = subprocess.run([...])
    return result.returncode == 0
```

**Cấu phần:**
- `def`: keyword định nghĩa function
- `ping`: tên function (snake_case)
- `ip, timeout=2`: **parameter** (định nghĩa) / khi gọi gọi là **argument**
- `"""..."""`: docstring, giải thích function làm gì
- `return`: trả giá trị về

---

### 16. Parameter vs Argument

**Parameter:** biến trong định nghĩa function.
**Argument:** giá trị thực truyền vào khi gọi.

```python
def ping(ip, timeout=2):       # ip, timeout là PARAMETER
    pass

ping("10.0.0.1", timeout=5)    # "10.0.0.1" và 5 là ARGUMENT
```

**Default argument:** parameter có giá trị mặc định (`timeout=2`). Optional khi gọi.

**Keyword argument:** truyền argument có tên (`timeout=5`). Rõ ràng hơn positional khi function nhiều tham số.

---

### 17. `return`

```python
def add(a, b):
    return a + b               # Trả giá trị

def log_message(msg):
    print(msg)
    # Không có return → tự động return None
```

**Trap:** Function không có `return` trả về `None`, không phải void. `result = print("hi")` → `result is None`.

---

## Section 6 — Cấu trúc đặc thù Python (Tuần 2-3)

### 18. List comprehension

**Là gì:** Cách tạo list mới từ list cũ, ngắn gọn hơn for loop.

```python
# Cách dài
upper_devices = []
for d in devices:
    upper_devices.append(d.upper())

# Cách Pythonic
upper_devices = [d.upper() for d in devices]

# Có filter
active = [d for d in devices if d.is_active()]

# Lồng (cẩn thận, khó đọc)
matrix = [[i*j for j in range(5)] for i in range(5)]
```

**Quy tắc:** Dùng list comprehension khi đơn giản. Nếu logic quá phức tạp → for loop bình thường, dễ đọc hơn.

---

### 19. Slice notation `[start:stop:step]`

```python
s = "core-sw-01"
s[0:4]                         # "core" (0 đến 3, không bao gồm 4)
s[:4]                          # "core" (từ đầu)
s[5:]                          # "sw-01" (đến hết)
s[-2:]                         # "01" (2 ký tự cuối)
s[::-1]                        # "10-ws-eroc" (reverse, step=-1)

devices[1:3]                   # 2 phần tử devices[1], devices[2]
```

**Quy tắc:** `stop` không bao gồm. `s[0:4]` = 4 ký tự, index 0-3.

---

### 20. f-string

**Là gì:** String formatting với biến nhúng bằng `{}`. Python 3.6+.

```python
hostname = "core-sw-01"
ip = "10.0.0.1"
uptime = 142.5

# f-string
msg = f"Device {hostname} at {ip} up for {uptime} days"

# Format spec
print(f"Uptime: {uptime:.1f} days")    # "Uptime: 142.5 days"
print(f"IP: {ip:>15}")                  # Right-align width 15

# Debug shortcut (Python 3.8+)
print(f"{hostname=}")                   # "hostname='core-sw-01'"
```

**Quy tắc:** F-string nhanh nhất, đọc dễ nhất. Dùng f-string mọi nơi trừ khi template string lưu config bên ngoài (lúc đó dùng `.format()` hoặc Jinja2).

---

### 21. Truthy / Falsy

**Là gì:** Giá trị nào "tương đương True" hoặc "tương đương False" khi dùng trong `if`.

```python
# Falsy: 0, 0.0, "", [], {}, None, False
if not devices:                # Tương đương "if len(devices) == 0"
    print("No devices")

if config:                     # Tương đương "if config is not None and config != ''"
    apply(config)
```

**Trap:** `if value:` khác `if value is not None:`. Nếu `value = 0` thì cách 1 False, cách 2 True. Dùng đúng cái cần.

---

## Section 7 — Class (preview Tuần 3-4)

### 22. `class`, `object`, `instance`

**Là gì:**
- `class`: template định nghĩa kiểu dữ liệu mới (như "Device")
- `object` / `instance`: 1 thực thể cụ thể của class (như "device core-sw-01")

```python
class Device:
    def __init__(self, hostname, ip):
        self.hostname = hostname
        self.ip = ip

    def ping(self):
        return subprocess.run(["ping", "-c", "1", self.ip]).returncode == 0

sw1 = Device("core-sw-01", "10.0.0.1")    # sw1 là instance
sw1.ping()                                # Gọi method
sw1.hostname                              # Truy cập attribute
```

---

### 23. `__init__`, `self`

**`__init__`:** Constructor. Tự chạy khi tạo instance mới.

**`self`:** Tham chiếu đến instance hiện tại. Parameter đầu tiên của mọi method. Tương đương `this` của Java/JavaScript.

```python
class Device:
    def __init__(self, hostname, ip):    # self là instance đang tạo
        self.hostname = hostname         # Lưu attribute vào instance
        self.ip = ip
```

**Trap:** Quên `self` ở method = method bị bug, không thấy attribute.

---

### 24. `attribute` vs `method`

**Attribute:** Biến thuộc về instance (`self.hostname`). Không có `()`.
**Method:** Function thuộc về class (`def ping(self)`). Có `()`.

```python
sw1.hostname                   # attribute, không có ()
sw1.ping()                     # method, có ()
```

---

## Section 8 — Error handling & I/O (Tuần 2-3)

### 25. `try / except`

```python
try:
    with open("config.yaml") as f:
        config = yaml.safe_load(f)
except FileNotFoundError:
    print("Config file missing, dùng default")
    config = {}
except yaml.YAMLError as e:
    print(f"YAML invalid: {e}")
    raise                                # Re-raise sau khi log
finally:
    print("Always runs")                 # Optional, luôn chạy
```

**Quy tắc:** Catch specific exception (`FileNotFoundError`), không catch all (`except:` hoặc `except Exception:`). Catch all che giấu bug.

---

### 26. `with` statement (context manager)

**Là gì:** Tự động cleanup resource (đóng file, đóng connection) khi block xong.

```python
# Dài, dễ quên close
f = open("config.yaml")
config = f.read()
f.close()

# Pythonic, tự đóng kể cả khi exception
with open("config.yaml") as f:
    config = f.read()
```

**Khi dùng:** Mở file, kết nối DB, lock, SSH session (Netmiko hỗ trợ).

---

### 27. `pathlib.Path`

**Là gì:** Object-oriented thay thế cho `os.path` cũ. Cross-platform.

```python
from pathlib import Path

config_file = Path("/etc/network/config.yaml")
config_file.exists()                     # True/False
config_file.is_file()                    # True
config_file.parent                       # Path("/etc/network")
config_file.suffix                       # ".yaml"
config_file.read_text()                  # đọc luôn, không cần open()

# Build path cross-platform
output = Path("output") / "report.json"  # "output/report.json" hoặc "output\report.json" trên Windows
```

**Quy tắc:** Dùng `Path` thay vì string path. Sau 2 năm sẽ cảm ơn.

---

## Section 9 — CLI & I/O (Tuần 2-3)

### 28. `argparse`

**Là gì:** Standard library để parse command-line argument, auto-generate `--help`.

```python
import argparse

parser = argparse.ArgumentParser(description="Ping all devices in inventory")
parser.add_argument("inventory", type=Path, help="Path to inventory.yaml")
parser.add_argument("--timeout", type=int, default=2, help="Ping timeout")
parser.add_argument("--verbose", "-v", action="store_true", help="Verbose output")

args = parser.parse_args()
print(args.inventory, args.timeout, args.verbose)
```

**Chạy:**
```bash
python tool.py inventory.yaml --timeout 5 -v
python tool.py --help          # Auto-generated help
```

---

### 29. `subprocess.run`

**Là gì:** Chạy lệnh hệ thống từ Python. Modern replacement cho `os.system`.

```python
import subprocess

result = subprocess.run(
    ["ping", "-c", "1", "10.0.0.1"],
    capture_output=True,                 # Bắt stdout/stderr
    text=True,                           # str thay vì bytes
    timeout=5
)
print(result.returncode)                 # 0 nếu thành công
print(result.stdout)
```

**Quy tắc:** Truyền command dưới dạng list, không string. `["ping", "-c", "1", ip]` an toàn hơn `f"ping -c 1 {ip}"` (tránh shell injection).

---

## Section 10 — Type hints (Tuần 2)

### 30. Type hints

**Là gì:** Annotation cho biết kiểu của biến/parameter/return. Không enforce runtime, nhưng tool (mypy, IDE) check.

```python
from pathlib import Path

def ping(ip: str, timeout: int = 2) -> bool:
    """Ping host, return True if alive."""
    ...

def load_inventory(path: Path) -> list[dict]:
    """Load YAML inventory, return list of device dicts."""
    ...

# Variable annotation (ít dùng hơn)
devices: list[str] = []
```

**Khi dùng:** Mọi function public. Tự document, IDE auto-complete tốt hơn, bắt bug khi refactor.

---

## Phụ lục — Idiom Pythonic phổ biến

```python
# Swap 2 biến (không cần biến trung gian)
a, b = b, a

# Multi-assignment
host, port = "10.0.0.1", 22

# Default value khi key thiếu trong dict
ip = device.get("ip", "0.0.0.0")

# Check empty
if not devices:                # Pythonic
    ...
# Đừng viết: if len(devices) == 0:

# Build string từ list
",".join(["a", "b", "c"])     # "a,b,c"

# Reverse list
list(reversed(devices))        # hoặc devices[::-1]

# Count occurrences
from collections import Counter
Counter(["a", "b", "a", "c"])  # Counter({'a': 2, 'b': 1, 'c': 1})

# Check 1 trong nhiều giá trị
if status in ("ok", "warning", "info"):
    log(status)
# Đừng viết: if status == "ok" or status == "warning" or status == "info":
```

---

## Cách dùng tài liệu này

1. **Lần đầu:** Đọc lướt 1 lần, biết có cái gì. Không cần thuộc.
2. **Khi code:** Gặp thuật ngữ lạ → mở file này tìm Ctrl+F.
3. **Khi review code AI sinh:** Đọc qua các example, đối chiếu code AI có theo Pythonic không.
4. **Update:** Mỗi 2 tuần thêm vào những idiom mới gặp ở dự án.

Không cần học thuộc lòng. Mục tiêu là **giảm friction đọc code**, không phải nhớ.
