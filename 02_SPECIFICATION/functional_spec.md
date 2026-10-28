# C02 · Đặc tả chức năng (Functional Specification)

Tài liệu mô tả **hành vi đúng**, độc lập với cách hiện thực. RTL trong
`04_IMPLEMENTATION/rtl/c02_core.sv` là **một** cách hiện thực — và ở một điểm quan trọng,
RTL hiện tại **hẹp hơn** đặc tả mà Charter yêu cầu (xem §4).

---

## 1. Chức năng ở một câu

C02 **ép** một mẫu 8 bit về nằm trong dải `[min_val, max_val]`: giá trị nào vượt biên thì
bị thay bằng chính biên đó, giá trị trong dải thì đi qua nguyên vẹn.
giá trị ra
▲
max ─┤                    ┌──────────────────  ← bão hoà ở max
│                   /
│                  /  (đường y = x)
│                 /
min ─┤────────────────┘                        ← bão hoà ở min
│
└─────┬───────────┬──────────────┬──────▶ giá trị vào
0          min            max     255
Đây là hàm **không giảm, liên tục, đơn điệu** — khác hẳn phép cắt bằng mặt nạ AND (xem §6).

## 2. Bảng hành vi

### 2.1 Cấu hình hợp lệ (`min_val ≤ max_val`)

| Điều kiện | `clamped_out` | Có bị kẹp không? |
|---|---|:-:|
| `sample_in < min_val` | **`min_val`** | ✅ kẹp dưới |
| `min_val ≤ sample_in ≤ max_val` | **`sample_in`** (đi qua nguyên vẹn) | ❌ |
| `sample_in > max_val` | **`max_val`** | ✅ kẹp trên |

### 2.2 Cấu hình sai (`min_val > max_val`)

| `sample_in` | `clamped_out` theo RTL | Ghi chú |
|---|---|---|
| bất kỳ | **`min_val`** | Đây là một **quy ước tuỳ chọn**, không phải hệ quả logic — xem §3 |

Phương trình:
clamped_out = (min_val > max_val)  ? min_val        // quy ước cho cấu hình sai
: (sample_in < min_val) ? min_val        // kẹp dưới
: (sample_in > max_val) ? max_val        // kẹp trên
:                         sample_in;     // đi qua
## 3. Hành vi khi cấu hình sai — một quyết định cần được nêu rõ

RTL ghi thẳng trong chú thích (dòng 9): `// reference behavior for invalid configuration`.
Nghĩa là người viết **biết** đây là một lựa chọn, không phải kết quả bắt buộc.

| Phương án khi `min > max` | Ưu | Nhược |
|---|---|---|
| **Trả `min_val`** *(RTL hiện tại)* | Xác định, dễ mô phỏng; trùng với nhánh "kẹp dưới" nên **tổng hợp gộp được hai nhánh** (xem `block_diagram.md` §4) | Không phân biệt được với trường hợp kẹp dưới hợp lệ |
| Trả `max_val` | Đối xứng với phương án trên | Cùng nhược điểm |
| Trả `sample_in` (không can thiệp) | "Không biết thì đừng sửa" | Cho dữ liệu ngoài dải đi thẳng vào tầng sau — nguy hiểm hơn |
| Trả giá trị bất kỳ **+ bật cờ lỗi** | Tầng sau biết chắc là không tin được | Cần thêm một cổng ra |

> ❗ **Điểm phải hỏi giảng viên:** với RTL hiện tại, tầng sau nhận `clamped_out = min_val`
> trong **hai** tình huống hoàn toàn khác nhau — (a) mẫu thật sự thấp hơn `min` (bình thường),
> và (b) cấu hình hỏng (bất thường). Không có tín hiệu nào phân biệt hai trường hợp đó.
> Xem §4.

## 4. ⚠️ Khoảng cách giữa Charter và RTL: **thiếu cờ kẹp**

Đây là phát hiện quan trọng nhất của đặc tả C02 và **phải** được nêu, không được lờ đi.

| Nguồn | Nội dung |
|---|---|
| **Charter mục 4** (ánh xạ chân) | `ui_in[7:0]=mẫu · uio_in[7:0]=ngưỡng · uo_out[7:0]=mẫu đã kẹp · **uio_out[0]=cờ kẹp**` |
| **Charter mục 2 câu 2** | *"Cờ 'đang bị kẹp' nói cho tầng trên biết điều gì mà giá trị đầu ra không nói được?"* |
| **Charter mục 10 (rủi ro chính)** | *"Chỗ hay tắc: **Xuất giá trị kẹp đúng nhưng quên cờ** — rồi không giải thích được vì sao cần cờ."* |
| **RTL thật** (`c02_core.sv`) | Chỉ có **một** cổng ra: `clamped_out[7:0]`. **Không có cờ kẹp.** |
| **Mô hình chuẩn** | `c02_reference.sv` **có** `config_error_ref`; `reference_model.py` trả về cặp `(giá_trị, cờ_lỗi)` |
| **Testbench** | Chỉ so `clamped_out === clamped_ref` (dòng 28). **Không kiểm cờ nào** — `config_error_ref` được tính nhưng **không bao giờ được đối chiếu** |

**Kết luận:** RTL trong hồ sơ hiện thực **đúng phần giá trị**, nhưng **thiếu phần cờ** mà
Charter yêu cầu. Và đây chính xác là cái bẫy mà Charter mục 10 cảnh báo trước.

### 4.1 Cờ kẹp nói lên điều gì mà giá trị không nói được?

| Tình huống | `clamped_out` | Cờ kẹp *(nếu có)* | Tầng sau suy được gì **chỉ từ giá trị**? |
|---|---|:-:|---|
| `sample=30, min=50, max=100` | `50` | **1** | Không phân biệt được với ca dưới |
| `sample=50, min=50, max=100` | `50` | **0** | Không phân biệt được với ca trên |
| `sample=75, min=100, max=50` (cấu hình hỏng) | `100` | **1** *(hoặc cờ lỗi riêng)* | Trông như một mẫu hợp lệ bằng 100 |

Ba tình huống **hoàn toàn khác nhau về ý nghĩa**, mà chỉ nhìn `clamped_out` thì không phân
biệt được hai tình huống đầu, và tình huống thứ ba trông như bình thường.

**Cờ kẹp mang thông tin về *độ méo*, không phải về *giá trị*.** Một chuỗi mẫu có cờ kẹp bật
liên tục nghĩa là tín hiệu vào đang **bão hoà** — tầng sau cần biết để: giảm hệ số khuếch
đại, cảnh báo cảm biến ngoài dải, hoặc đánh dấu đoạn dữ liệu là không tin cậy. Nhìn giá trị
ra thì không thấy được điều đó: `50` trông giống nhau dù là mẫu thật hay là biên.

### 4.2 Đề nghị bổ sung (chưa áp dụng — cần thầy duyệt)

```systemverilog
module c02_core (
    input  logic [7:0] sample_in,
    input  logic [7:0] min_val,
    input  logic [7:0] max_val,
    output logic [7:0] clamped_out,
    output logic       clamp_flag,     // ← THÊM: 1 khi giá trị ra ≠ giá trị vào
    output logic       config_error    // ← THÊM (tuỳ chọn): min_val > max_val
);
    always_comb begin
        config_error = (min_val > max_val);
        clamp_flag   = 1'b0;
        if (config_error)            begin clamped_out = min_val;   clamp_flag = 1'b1; end
        else if (sample_in < min_val) begin clamped_out = min_val;   clamp_flag = 1'b1; end
        else if (sample_in > max_val) begin clamped_out = max_val;   clamp_flag = 1'b1; end
        else                          begin clamped_out = sample_in; clamp_flag = 1'b0; end
    end
endmodule