```markdown
# C02 · Giao diện (Interface)

---

## 1. Ánh xạ chân theo Charter (mục 4)

> Theo danh mục đề: ui_in[7:0]=mẫu · uio_in[7:0]=ngưỡng · uo_out[7:0]=mẫu đã kẹp · uio_out[0]=cờ kẹp
> Ngân sách chân: 16 bit vào + 9 bit ra = 25 trên 24 chân.
> Vượt ngân sách chân: thiết kế cần 25 bit trong khi ô chỉ có 24 chân. Khối này là mạch tổ hợp nên nạp hai nhịp sẽ thêm ô nhớ; phải hỏi giảng viên trước khi chọn cách xử lý.
> Một ô Tiny Tapeout có đúng 24 chân: ui_in 8 chỉ vào, uo_out 8 chỉ ra, uio 8 chọn chiều từng chân. uio_in và uio_out là cùng một bộ chân vật lý.

## 2. Bảng giao diện đã CHỐT — module `c02_core`

Bảng dưới đây **đọc trực tiếp từ RTL** (`04_IMPLEMENTATION/rtl/`), không phải chép tay,
nên luôn nhất quán với mã nguồn.

| Tín hiệu | Chiều | Độ rộng (bit) | Vai trò | Mức tích cực / giả định |
|---|---|---:|---|---|
| `sample_in[7:0]` | input | 8 | dữ liệu vào | Không dấu (unsigned) |
| `min_val[7:0]` | input | 8 | ngưỡng kẹp dưới | Không dấu (unsigned) |
| `max_val[7:0]` | input | 8 | ngưỡng kẹp trên | Không dấu (unsigned) |
| `clamped_out[7:0]` | output | 8 | kết quả ra đã kẹp | Không dấu (unsigned) |

**Tổng hợp:** 3 cổng vào (24 bit) · 1 cổng ra (8 bit).

**Không có clock** — khối tổ hợp thuần.

**Không có reset** — không có trạng thái để đặt lại.

## 3. Ngân sách chân Tiny Tapeout

| Hạng mục | Số bit |
|---|---:|
| Tổng bit vào | **24** |
| Tổng bit ra | **8** |
| **Tổng cộng** | **32** |
| Ô Tiny Tapeout có | **24** |
| **Chênh lệch** | **+8 (VƯỢT)** |

> Nhắc lại cấu trúc chân Tiny Tapeout: một ô có đúng 24 chân — `ui_in` 8 chỉ vào,
> `uo_out` 8 chỉ ra, `uio` 8 chọn chiều từng chân; **`uio_in` và `uio_out` là cùng một bộ
> chân vật lý**.

> 🟡 **ĐIỂM MỞ.** Thiết kế cần nhiều hơn 24 bit. Charter mục 4 yêu cầu **hỏi giảng viên
> trước khi chọn cách xử lý**. Gói này chốt lõi logic và **cố ý không** tự bịa ra lớp vỏ
> vật lý. Ba hướng thường dùng: (1) nạp/phát nhiều nhịp — thêm ô nhớ; (2) thu hẹp độ rộng
> một toán hạng; (3) bỏ bớt tín hiệu ra. Mỗi hướng đều đánh đổi khác nhau.

## 4. Điều kiện hợp lệ của đầu vào

| Điều kiện | Ai bảo đảm |
|---|---|
| Các cổng vào không chứa `X`/`Z` khi lấy mẫu | Tầng ngoài |
| Đầu ra được lấy mẫu sau khi mạch đã ổn định | Tầng ngoài, theo số liệu `06_GDSII/sta/` |

---

*Phiên bản: v1.0 · Ngày: 2026-10-25 · Truy vết: REQ-C02-002, AC-1.*