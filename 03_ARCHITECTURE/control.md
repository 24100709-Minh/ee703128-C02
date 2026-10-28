```markdown
# C02 · Phần điều khiển (Control)

---

## 1. Kết luận: không có **khối** điều khiển, nhưng có **hai tín hiệu điều khiển nội bộ**

C02 là ví dụ rõ nhất trong nhóm C về sự tách bạch **đường dữ liệu** / **đường điều khiển**
bên trong một mạch tổ hợp[cite: 22].

| Khái niệm | C02 có không? | Bằng chứng |
|---|:-:|---|
| **Khối điều khiển** (FSM, bộ đếm, máy trạng thái) | ❌ Không | RTL chỉ có một `always_comb`; không clock, không reset; netlist 0 cell tuần tự[cite: 22] |
| **Tín hiệu điều khiển từ bên ngoài** (enable, mode, start) | ❌ Không | Giao diện chỉ có 3 cổng vào, cả ba là dữ liệu 8 bit[cite: 22] |
| **Tín hiệu điều khiển sinh bên trong** | ✅ **Có — hai cái**: `_042_` và `_052_` | Chúng lái chân `S` của hai tầng mux[cite: 22] |

## 2. Bằng chứng không có phần điều khiển theo thời gian

| # | Bằng chứng | Trạng thái | Nguồn |
|---|---|:-:|---|
| B-1 | RTL không có `always_ff`, không có `posedge`, không có biến trạng thái | ✅ | `c02_core.sv`[cite: 22] |
| B-2 | Giao diện không có `clk`, không có `rst` | ✅ | `02_SPECIFICATION/interface.md`[cite: 22] |
| B-3 | **Netlist có 0 cell tuần tự** | ✅ | Báo cáo tổng hợp[cite: 22] |
| B-4 | **Công suất nhóm Sequential = 0,0 %**, nhóm Clock = 0,0 % | ✅ | Báo cáo công suất[cite: 22] |
| B-5 | Clock trong STA là **clock ảo** `vclk` | ✅ | `design.sdc`[cite: 22] |
| B-6 | Chuỗi `if/else if` **có nhánh `else` cuối** ⟹ mọi đường đều gán `clamped_out` | ✅ | `c02_core.sv`[cite: 22] |

> **B-6 đáng nhấn mạnh.** C02 không dùng mẫu "gán mặc định đầu khối" như C01, mà dùng cách
> khác cũng an toàn: **chuỗi `if/else if` kết thúc bằng `else`**. Bảo đảm mọi đường thực thi
> đều gán biến ⟹ không suy ra latch[cite: 22].

## 3. Hai tín hiệu điều khiển — bảng tác dụng

| Tín hiệu | Hiện thực | Điều khiển gì | Nghĩa logic |
|---|---|---|---|
| `_052_` | Cuối chuỗi `sample > max` | Chân `S` của mux tầng 1 | `1` ⟹ chọn `sample_in`; `0` ⟹ chọn `max_val`[cite: 22] |
| `_042_` | `_102_/Y = NOR(_023_, _041_)` | Chân `S` của mux tầng 2 | `1` ⟹ chọn kết quả tầng 1; `0` ⟹ chọn `min_val`[cite: 22] |

## 4. Quan hệ điều khiển ↔ datapath

> 🎓 **Toàn bộ thời gian của đường tới hạn nằm trên đường ĐIỀU KHIỂN, không phải đường dữ liệu.**
> Đây là đặc trưng của mọi bộ kẹp/bộ chọn: dữ liệu đi rất ngắn, *quyết định* đi rất dài[cite: 22].

---

*Phiên bản: v1.0 · Ngày: 2026-10-25*
