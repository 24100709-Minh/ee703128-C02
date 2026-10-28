# C02 · Máy trạng thái (FSM)

---

## 1. Kết luận: C02 **không có FSM**

C02 là một **hàm thuần tuý** ba biến: `clamped_out = f(sample_in, min_val, max_val)`. Cùng
một bộ đầu vào **luôn** cho cùng một đầu ra, bất kể đã có gì xảy ra trước đó. Hàm thuần tuý
thì không thể có trạng thái, mà không có trạng thái thì không thể có máy trạng thái[cite: 24].

## 2. Bằng chứng — sáu nguồn độc lập

| # | Bằng chứng | Trạng thái | Nguồn |
|---|---|:-:|---|
| B-1 | RTL không có `always_ff`, không có `posedge`, không có biến trạng thái | ✅ | `c02_core.sv`[cite: 24] |
| B-2 | Giao diện không có `clk` | ✅ | `02_SPECIFICATION/interface.md`[cite: 24] |
| B-3 | Giao diện không có `rst` | ✅ | như trên[cite: 24] |
| B-4 | **Netlist: 0 cell tuần tự** | ✅ | Báo cáo tổng hợp[cite: 24] |
| B-5 | **Công suất nhóm Sequential = 0,0 %** | ✅ | Báo cáo công suất[cite: 24] |
| B-6 | Chuỗi `if/else if` **có nhánh `else` cuối** ⟹ không suy ra latch | ✅ | `c02_core.sv`[cite: 24] |

---

*Phiên bản: v1.0 · Ngày: 2026-10-25*