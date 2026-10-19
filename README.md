# Đề tài C02: Bộ kẹp giá trị bão hoà 8-bit (Saturating Clamp)

## 📌 Giới thiệu
Repository chứa mã nguồn RTL, Testbench và cấu hình CI/CD (RTL-to-GDSII) cho đề tài **C02 - Bộ kẹp giá trị bão hoà 8-bit**.

## 📁 Cấu trúc thư mục
* `rtl/`: Mã nguồn thiết kế Verilog (`saturating_clamp.v`).
* `tb/`: Mã kiểm thử Testbench (`tb_saturating_clamp.v`).
* `docs/`: Bản đặc tả kỹ thuật thiết kế (`SPECIFICATION.md`).
* `sim/`: Kết quả mô phỏng dạng sóng (`.vcd`).
* `.github/workflows/`: Cấu hình GitHub Actions tự động hóa RTL-to-GDSII.
