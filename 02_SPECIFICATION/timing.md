# C02 · Đặc tả thời gian (Timing)

---

## 1. Bản chất thời gian của khối này

C02 là mạch **Tổ hợp**.

Không có clock, không có setup/hold, không có chu kỳ. Đại lượng thời gian duy nhất
có nghĩa là **độ trễ lan truyền từ đầu vào đến khi đầu ra ổn định**.

| Khái niệm | Áp dụng? | Lý do |
|---|:-:|---|
| Chu kỳ clock | ❌ | Không có clock |
| Setup / hold | ❌ | Không có flip-flop trong khối |
| Clock skew, CTS | ❌ | Không có cây clock |
| WNS / TNS | ⚠️ | Chỉ có nghĩa **nếu** áp một clock ảo làm chuẩn phân tích |
| Độ trễ đường tổ hợp | ✅ | Đây là đại lượng cần đo |

## 2. Phương pháp ràng buộc đã dùng

Chế độ: **clock ảo (virtual clock)**.

File SDC: `04_IMPLEMENTATION/constraints/design.sdc`

```tcl
# Mach TO HOP: khong co clock that.
# vclk chi la MOC QUY CHIEU de STA tinh duoc slack tren duong to hop.
# KHONG dien giai period 10 ns thanh 'thiet ke chay o 100 MHz'.
create_clock -name vclk -period 10.0
set_input_delay  0.0 -clock vclk [all_inputs]
set_output_delay 0.0 -clock vclk [all_outputs]
t_clk_he_thong  ≥  t_ckq(thanh ghi truoc)  +  t_C02_max  +  t_setup  +  t_skew