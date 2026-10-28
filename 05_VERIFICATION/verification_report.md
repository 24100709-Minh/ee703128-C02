# C02 · Báo cáo kiểm chứng (Verification Report)

**Ngày chạy:** 2026-10-25 · **Phiên bản:** v1.0

---

## 1. Điều kiện tạo ra bằng chứng

| Hạng mục | Giá trị |
|---|---|
| Hệ điều hành | Ubuntu 22.04 LTS (x86-64) |
| Công cụ mô phỏng | **Icarus Verilog 12.0 (stable)** (cờ `-g2012`) |
| Top module | `c02_core` |
| Lệnh chạy | `bash 04_IMPLEMENTATION/scripts/01_run_sim.sh` |

## 2. Kết quả tổng hợp

| Lớp | Nội dung | Kết quả |
|---|---|---|
| L0 | Mô hình chuẩn Python | ✅ **PASS** |
| L2 | Mô phỏng RTL | ✅ PASS — testbench chạy hết, không có assertion nào vi phạm |
| L3 | Kiểm cấu trúc — số flip-flop | ✅ đo được **0** FF, phân loại Charter là **Tổ hợp** |

## 3. Trích log mô phỏng
C02 core verification PASS
05_VERIFICATION/testbench/c02_core_tb.sv:59: $finish called at 29453 (1s)
## 4. Kiểm cấu trúc — số flip-flop

| Chỉ số | Giá trị |
|---|---:|
| Tổng số cell | **94** |
| Cell tuần tự (flip-flop / latch) | **0** |
| Diện tích lõi | 435.68 µm² |

✅ Đúng phân loại **Tổ hợp** của Charter — 0 ô nhớ.

---

*Truy vết: REQ-C02-001, REQ-C02-003, REQ-C02-010…013.*