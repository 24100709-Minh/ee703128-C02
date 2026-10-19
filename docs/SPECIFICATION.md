# BẢN ĐẶC TẢ KỸ THUẬT (SPECIFICATION)
## Đề tài C02: Bộ kẹp giá trị bão hoà (Saturating Clamp) 8-bit

---

## 1. Tổng quan và Bối cảnh ứng dụng
* **Vị trí trong hệ thống:** Khối kẹp bão hoà (Saturating Clamp) được đặt ở tầng tiền xử lý tín hiệu (Pre-processing), ngay trước các khối chuyển đổi số-tương tự (DAC) hoặc bộ lọc số nhằm bảo vệ hệ thống khỏi hiện tượng tràn số.
* **Mức độ cần thiết:** Ngăn chặn hiện tượng cuộn vòng dữ liệu (wrap-around) khi tín hiệu vượt ngưỡng (ví dụ: giá trị $255 + 1$ bị nhảy thốc về $0$), đồng thời cung cấp cờ báo động để các tầng xử lý phía trên nhận biết trạng thái can thiệp biên[cite: 2].

---

## 2. Giao diện phần cứng và Sơ đồ chân (Interface)
Áp dụng cấu trúc phân bổ chân tiêu chuẩn cho mạch tổ hợp[cite: 2]:

| Tên tín hiệu | Hướng (Dir) | Độ rộng | Mức tích cực | Mô tả chi tiết |
| :--- | :---: | :---: | :---: | :--- |
| `ui_in[7:0]` | Input | 8 bit | Active-High | Mẫu dữ liệu đầu vào cần kiểm tra kẹp ($0 \to 255$)[cite: 2]. |
| `uio_in[7:0]` | Input | 8 bit | Active-High | Ngưỡng trên cấu hình động ($TH_{upper}$)[cite: 2]. |
| `uo_out[7:0]` | Output | 8 bit | Active-High | Mẫu dữ liệu đầu ra sau khi đã được kẹp bão hoà[cite: 2]. |
| `uio_out[0]` | Output | 1 bit | High | Cờ kẹp (`clamp_flag`): Bằng `1` nếu bị kẹp; bằng `0` nếu an toàn[cite: 2]. |
| `uio_out[7:1]`| Output | 7 bit | - | Các chân không sử dụng (gán giá trị `0`). |

* **Giả định thiết kế:** Ngưỡng dưới ($TH_{lower}$) được cố định trong phần cứng ở mức `8'h10` (16 thập phân) để tối ưu hóa số lượng chân kết nối phần cứng[cite: 2].

---

## 3. Đặc tả hàm truyền chức năng
Mạch thực hiện biểu thức logic tổ hợp:
$$\text{uo\_out} = \begin{cases} 0\text{x10} & \text{nếu } ui\_in < 0\text{x10} \\ uio\_in & \text{nếu } ui\_in > uio\_in \\ ui\_in & \text{nếu } 0\text{x10} \le ui\_in \le uio\_in \end{cases}$$

Tín hiệu cờ kẹp:
$$\text{uio\_out}[0] = (ui\_in < 0\text{x10}) \lor (ui\_in > uio\_in)$$

---

## 4. Ma trận Ca kiểm thử (Test Plan)
Giả định cấu hình ngưỡng trên $TH_{upper} = 8'\text{hD0}$ (208):

| STT | Tên ca kiểm thử | Giá trị `ui_in` | Ngưỡng trên `uio_in` | `uo_out` mong đợi | `uio_out[0]` | Ý nghĩa kiểm chứng |
| :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| **1** | Dưới ngưỡng dưới | `0x05` | `0xD0` | `0x10` | `1` | Kiểm tra kẹp sàn và bật cờ[cite: 2] |
| **2** | Đúng biên dưới | `0x10` | `0xD0` | `0x10` | `0` | Kiểm tra tại biên ($\le$), không bật cờ[cite: 2] |
| **3** | Trong khoảng an toàn | `0x60` | `0xD0` | `0x60` | `0` | Kiểm tra trạng thái truyền suốt[cite: 2] |
| **4** | Đúng biên trên | `0xD0` | `0xD0` | `0xD0` | `0` | Kiểm tra tại biên ($\ge$), không bật cờ[cite: 2] |
| **5** | Trên ngưỡng trên | `0xF0` | `0xD0` | `0xD0` | `1` | Kiểm tra kẹp trần và bật cờ[cite: 2] |
| **6\***| Cực tiểu tuyệt đối | `0x00` | `0xD0` | `0x10` | `1` | Bắt lỗi tràn ngược về 0[cite: 2] |
| **7\***| Cực đại tuyệt đối | `0xFF` | `0xD0` | `0xD0` | `1` | Bắt lỗi tràn dải bit cao nhất[cite: 2] |