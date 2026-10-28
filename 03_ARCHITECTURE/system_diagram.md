# C02 · Sơ đồ hệ thống (System Diagram)

---

## 1. Bối cảnh ứng dụng (Charter mục 1)

> *"Khối giới hạn biên độ tín hiệu trước khi đưa vào bộ khuếch đại, tránh đưa giá trị ngoài
> dải làm méo tầng sau."*[cite: 25]

C02 là một **van an toàn biên độ** đặt trên đường dữ liệu. Khác C01 (quan sát và báo cáo),
C02 **can thiệp trực tiếp** vào dòng dữ liệu[cite: 25].

## 2. Vòng đời RTL → GDSII — trạng thái THẬT của C02
┌─────────────────┐
│ 1. Đặc tả       │ ✅ 01_REQUIREMENT/, 02_SPECIFICATION/
└────────┬────────┘
▼
┌─────────────────┐
│ 2. RTL          │ ✅ c02_core.sv
└────────┬────────┘
▼
┌─────────────────┐
│ 3. Mô hình chuẩn│ ✅ PASS — reference_model.py
└────────┬────────┘
▼
┌─────────────────┐
│ 4. Mô phỏng RTL │ ✅ PASS — simulation.log
└────────┬────────┘
▼
┌─────────────────┐
│ 5. Tổng hợp     │ ✅ PASS — 94 cell, 0 FF, 435.68 µm²
└────────┬────────┘
▼
┌─────────────────┐
│ 6. STA          │ ✅ PASS — 3.20 ns, fmax ~312.5 MHz
└────────┬────────┘
▼
┌─────────────────┐
│ 7. P&R / GDSII  │ ✅ PASS — DRC clean, LVS match, c02_top.gds
└─────────────────┘


---

*Phiên bản: v1.0 · Ngày: 2026-10-25*