# C02 · Ca biên và lý do chọn (Corner Cases)

Mỗi ca phải trả lời được: *"ca này bắt được lỗi nào mà ca khác không bắt được?"*

Nguồn đối chiếu: `05_VERIFICATION/testbench/c02_core_tb.sv` và
`05_VERIFICATION/golden_model/reference_model.py` (đọc từng dòng).
Trạng thái: mô phỏng **PASS** (`simulation.log`).

---

## 1. Ca bắt buộc của Charter mục 8 — và lý do kỹ thuật

| # | Ca Charter | Kích thích | Bắt lỗi gì | Dòng TB |
|---|---|---|---|---|
| 1 | Dưới ngưỡng dưới | `check(49, 50, 100)` | Nhánh kẹp dưới sai | 36 |
| 2 | **Đúng biên dưới** | `check(50, 50, 100)` | **Ca then chốt.** Dùng `<` hay `<=`? Sai một dấu thì `sample=min` bị kẹp thay vì đi qua — mà kết quả *vẫn bằng 50*, nên chỉ ca này phát hiện được nếu có cờ | 37 |
| 3 | Trong khoảng | `check(75, 50, 100)` | Nhánh "đi qua" sai | 38 |
| 4 | **Đúng biên trên** | `check(100, 50, 100)` | Đối xứng với #2: `>` hay `>=` | 39 |
| 5 | Trên ngưỡng trên | `check(101, 50, 100)` | Nhánh kẹp trên sai | 40 |
| 6 | *(thêm ngoài Charter)* Cấu hình `min>max` | `check(75, 100, 50)` | Nhánh cấu hình sai | 41 |

> 🔎 **Nghịch lý của ca #2 và #4 khi KHÔNG có cờ kẹp.** Với `sample=50, min=50, max=100`:
> đúng thì `out=50` (đi qua); sai (dùng `<=`) thì cũng `out=50` (kẹp về min). **Giá trị ra
> giống hệt nhau.** Nghĩa là testbench hiện tại **không thể** phân biệt hai hiện thực này!
> Chỉ khi có `clamp_flag` (đúng thì `0`, sai thì `1`) thì ca biên mới có sức phân biệt.
>
> Đây là một lập luận rất mạnh, và **định lượng được**, cho câu hỏi Charter mục 2 câu 2
> ("cờ nói cho tầng trên biết điều gì mà giá trị không nói được"): nó cũng nói cho **người
> kiểm chứng** biết điều mà giá trị không nói được. Xem `functional_spec.md` §4.

## 2. Ca tự xây dựng bổ sung (Charter mục 8 yêu cầu ≥ 2, có ca biên)

| # | Ca | Kích thích | Vì sao cần | Dòng TB |
|---|---|---|---|---|
| 7 | **Dải rộng 0, ở đáy miền** | `check(0,0,0)` | `min=max=0`: mọi mẫu đều ra `0`; không tồn tại kẹp dưới | 44 |
| 8 | **Dải rộng 0, ở đỉnh miền** | `check(255,255,255)` | Đối xứng; bắt lỗi tràn khi tính `max+1` | 45 |
| 9 | **Dải phủ toàn miền, mẫu ở đáy** | `check(0,0,255)` | Không bao giờ kẹp; mẫu nhỏ nhất phải đi qua nguyên vẹn | 46 |
| 10 | **Dải phủ toàn miền, mẫu ở đỉnh** | `check(255,0,255)` | Bắt lỗi so sánh **có dấu**: nếu dùng `signed`, `255` là `-1` ⟹ sẽ bị kẹp về `0` | 47 |
| 11 | **Dải rộng 0 ở giữa miền** | `check(128,128,128)` | Biên `128` = bit 7 lật — điểm chuyển của so sánh có dấu | 48 |
| 12 | **Sát biên dưới, ngưỡng lệch** | `check(127,128,200)` | `sample = min-1` với `min` không phải lũy thừa của 2 | 49 |
| 13 | **Sát biên trên, ngưỡng lệch** | `check(201,128,200)` | `sample = max+1` | 50 |
| 14 | **Quét rộng có hệ thống** | `lo` bước 17, `hi` từ `lo` bước 19, `s` toàn bộ 0…255 | Phủ kín dải mẫu cho từng cửa sổ; kiểm INV-5 (đơn điệu) gián tiếp | 53–56 |

### Vì sao bước nhảy 17 và 19

Cả hai **nguyên tố cùng nhau với 256** (`gcd(17,256)=gcd(19,256)=1`). Nhờ vậy tập ngưỡng thử
không bị "đồng bộ" với biên lũy thừa của 2. Nếu dùng bước 16 hay 32, mọi ngưỡng thử sẽ có
4–5 bit thấp bằng 0 — và lỗi ở chuỗi mượn bit thấp sẽ **không bao giờ** bị kích hoạt.

### Quy mô thật của lần chạy

`simulation.log` ghi `$finish called at 29453`. Testbench dùng `#1` cho mỗi vector
(`c02_core_tb.sv` dòng 26), nên con số đó xấp xỉ **số vector đã chạy** — cỡ **29 000 ca**.

> ⚠️ `29453` là **số bước thời gian mô phỏng**, **không** phải 29453 ns. Mô phỏng là
> zero-delay; con số này không mang thông tin vật lý nào.

## 3. Lỗ hổng phủ đã phát hiện khi đọc testbench

| # | Lỗ hổng | Hậu quả | Đề nghị bổ sung |
|---|---|---|---|
| L-1 | **Không kiểm cờ nào.** TB chỉ so `clamped_out === clamped_ref` (dòng 28). Mô hình chuẩn có tính `config_error_ref` (dòng 14) nhưng **không bao giờ được đối chiếu** | Ca #2 và #4 mất sức phân biệt (xem §1); nhánh cấu hình sai chỉ được kiểm qua giá trị | Thêm `assert(config_error_dut === config_error_ref)` — **cần RTL có cờ trước** |
| L-2 | **Vòng quét `hi` bắt đầu từ `lo`** (dòng 54) ⟹ phần quét rộng **không bao giờ** sinh `min>max` | Cấu hình sai chỉ được kiểm bởi **một** vector (`check(75,100,50)`) | Thêm vòng quét `hi < lo`, như mô hình chuẩn Python đã làm (dòng 46–51) |
| L-3 | Không có ca `min = max + 1` (cấu hình sai **sát biên**) | Không kiểm ranh giới giữa "dải rộng 0 hợp lệ" và "cấu hình sai" | `check(s, 100, 99)` — lệch đúng 1 so với `check(s,100,100)` |

> Mô hình chuẩn Python **có** quét cấu hình sai (dòng 46–51: `lo` bước 13, `hi < lo` bước 11,
> `x` bước 7) nhưng testbench SystemVerilog thì **không**. Chênh lệch phủ giữa hai lớp kiểm
> chứng chính là lý do phải chạy cả hai.

## 4. Phân loại ca theo tiêu chí kỹ thuật riêng của C02

Tiêu chí tự nhiên của đề này là **nhánh nào trong bốn nhánh của RTL được kích hoạt**, kết hợp
với **tầng ghép kênh nào quyết định đầu ra**.

| Lớp | Điều kiện | Nhánh RTL | Tầng mux quyết định (netlist) | Có trong TB? |
|---|---|---|---|:-:|
| A | `min > max` | dòng 8–9 | mux tầng 2 chọn `min_val` | ✅ (1 vector) |
| B | `min ≤ max`, `s < min` | dòng 10–11 | mux tầng 2 chọn `min_val` | ✅ |
| C | `min ≤ max`, `s = min` | dòng 14–15 | mux tầng 2 chọn kết quả tầng 1 | ✅ **ca biên** |
| D | `min ≤ max`, `min < s < max` | dòng 14–15 | tầng 1 chọn `sample`, tầng 2 cho qua | ✅ |
| E | `min ≤ max`, `s = max` | dòng 14–15 | như D | ✅ **ca biên** |
| F | `min ≤ max`, `s > max` | dòng 12–13 | tầng 1 chọn `max_val` | ✅ |
| G | `min = max` | D hoặc B hoặc F | dải rộng 0 | ✅ |

> 🔎 **Lớp A và lớp B kích hoạt hai nhánh RTL khác nhau nhưng cho cùng một đầu ra `min_val`.**
> Chính vì vậy Yosys **gộp được hai nhánh** thành một tín hiệu chọn duy nhất
> (`_042_ = NOR(min>max, sample<min)`, xem `block_diagram.md` §4). Hệ quả kiểm chứng: về mặt
> **giá trị**, không có ca nào phân biệt được lớp A với lớp B — nên nếu ai đó vô tình xoá
> nhánh `config_error` khỏi RTL thì testbench hiện tại **vẫn PASS** với mọi vector có
> `min ≤ max`, và chỉ trượt ở đúng **một** vector `check(75,100,50)`.

## 5. Ca **KHÔNG** áp dụng cho đề này — và vì sao

| Ca | Vì sao không áp dụng |
|---|---|
| Ca reset, giá trị sau reset | Mạch tổ hợp; không có `rst` |
| Ca theo chu kỳ clock, độ trễ N chu kỳ | Không có clock; 0 cell tuần tự trong netlist |
| Ca setup/hold, metastability | Không có phần tử tuần tự |
| **Ca kẹp có dấu** (signed clamp) | Charter mục 3: **ngoài phạm vi** |
| **Ca kẹp mềm** (soft clipping, bão hoà cong) | Charter mục 3: **ngoài phạm vi**. Kẹp mềm cần hàm phi tuyến (bảng tra hoặc xấp xỉ), là một đề khác hẳn |
| **Ca nén dải động** (dynamic range compression) | Charter mục 3: **ngoài phạm vi**; cần trạng thái theo thời gian |
| Ca `sample`, `min`, `max` ngoài dải 0…255 | Không tồn tại: cổng rộng đúng 8 bit |
| Ca ngưỡng thay đổi giữa chừng một phép kẹp | Không có khái niệm "giữa chừng" — mạch tổ hợp, mỗi lần đánh giá độc lập |

## 6. Ca cần bổ sung khi chuyển sang gate-level / post-layout

| Ca cần thêm | Bắt lỗi gì | Điều kiện để chạy |
|---|---|---|
| Mô phỏng gate-level trên `netlist.v`, chạy lại toàn bộ ~29 000 vector | Tổng hợp làm lệch chức năng; đặc biệt kiểm lại **việc gộp hai nhánh A và B** và **cell `a31o_1` gộp hai tầng mux cho bit 7** | Thư viện mô phỏng `sky130_fd_sc_hd` |
| `sample` đổi từ `min-1` sang `max+1` trong một bước | **Glitch trên `clamped_out`**: hai tín hiệu chọn `_042_` và `_052_` ổn định ở hai thời điểm khác nhau ⟹ đầu ra có thể đi qua giá trị trung gian **không thuộc** `[min,max]` — **vi phạm INV-1 tức thời** | Mô phỏng có SDF |
| `min_val` đổi làm `min>max` chuyển 0→1 | Glitch qua chuỗi so sánh dài nhất (7 tầng `maj3`) | Mô phỏng có SDF |
| Đo `clamped_out` ổn định sau **3,30 ns** | Tầng ngoài lấy mẫu quá sớm | Đã có STA |
| Đo riêng `clamped_out[7]` (ổn định ở **1,71 ns**) so với `clamped_out[1..5]` (**3,30 ns**) | Chênh lệch **1,59 ns** giữa các bit của cùng một bus — nếu tầng sau chốt từng bit độc lập thì đây là nguồn lỗi | Đã có STA, xem `timing_diagram.md` §3 |
| Kiểm ở góc `ss` và `ff` | Biên an toàn; `ff` bắt lỗi hold | Liberty góc khác — **chưa có** |

> 🔎 **Ca glitch vi phạm INV-1 rất đáng dạy.** INV-1 nói *"đầu ra luôn trong dải `[min,max]`"*.
> Đó là bất biến ở **trạng thái ổn định**. Ở trạng thái quá độ, hai tín hiệu chọn ổn định
> lệch nhau nên mux có thể xuất ra tạm thời một giá trị lai. Mô phỏng zero-delay **không bao
> giờ** dạy được phân biệt này — và một tầng sau dùng `clamped_out` làm địa chỉ bộ nhớ hoặc
> làm enable sẽ gặp rắc rối thật.

## 7. Ca cần bổ sung nếu RTL được bổ sung cờ kẹp

Nếu bản vá ở `functional_spec.md` §4.2 được thầy duyệt, cần thêm:

| Ca | Kỳ vọng |
|---|---|
| `check(50,50,100)` — mẫu **đúng biên dưới** | `clamp_flag == 0` ← phân biệt `<` với `<=` |
| `check(100,50,100)` — mẫu **đúng biên trên** | `clamp_flag == 0` ← phân biệt `>` với `>=` |
| `check(49,50,100)` | `clamp_flag == 1` |
| `check(101,50,100)` | `clamp_flag == 1` |
| `check(75,100,50)` — cấu hình sai | `config_error == 1` |
| Quét toàn dải: `clamp_flag === (clamped_out != sample_in)` | INV-9 trên mọi vector |

---

*Phiên bản: v1.0 · Ngày: 2026-09-24*