# C02 · Kế hoạch kiểm chứng (Test Plan)

---

## 1. Chiến lược nhiều lớp độc lập

| Lớp | Nội dung | File | Công cụ | Trạng thái |
|---|---|---|---|---|
| L0 | Mô hình chuẩn viết bằng Python, độc lập với RTL | `golden_model/reference_model.py` | CPython 3 | ✅ PASS |
| L1 | Mô hình chuẩn viết bằng SystemVerilog | `golden_model/c02_reference.sv` | Icarus Verilog 12.0 (stable) | ✅ có |
| L2 | Mô phỏng RTL với testbench tự kiểm | `testbench/c02_core_tb.sv` | Icarus Verilog 12.0 (stable) | ✅ PASS |
| L3 | Kiểm cấu trúc — số flip-flop phù hợp phân loại | `../06_GDSII/synthesis/synth_stat.txt` | Yosys 0.33 | ✅ |
| L4 | Mô phỏng gate-level trên netlist | — | — | ⬜ chưa chạy |
| L5 | Mô phỏng post-layout có back-annotate SDF | — | — | ⬜ chưa chạy |

> Lý do dùng nhiều mô hình chuẩn độc lập: nếu mô hình chuẩn và RTL do cùng một người viết
> theo cùng một cách nghĩ, chúng có thể **cùng sai**. Một mô hình viết bằng ngôn ngữ khác
> (Python) làm giảm rủi ro đó — nguyên tắc *diverse redundancy*.

## 2. Ca kiểm thử bắt buộc theo Charter mục 8

- Dưới ngưỡng dưới · đúng biên · trong khoảng · đúng biên trên · trên ngưỡng trên
- Bổ sung ít nhất hai ca tự xây dựng, trong đó có ca biên.

## 3. Tiêu chí PASS/FAIL

| Lớp | Tiêu chí PASS |
|---|---|
| L0 | Mô hình Python chạy hết, không assertion nào sai |
| L2 | Testbench chạy hết, **không** assertion nào vi phạm, không `$fatal` |
| L3 | Số cell tuần tự **= 0** — đúng phân loại **Tổ hợp** |

---

*Phiên bản: v1.0 · Ngày: 2026-10-25 · Truy vết: REQ-C02-010…013.*