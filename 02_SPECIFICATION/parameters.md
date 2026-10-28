# C02 · Tham số và cấu hình (Parameters)

---

## 1. Tham số thiết kế chốt từ Charter

| Tham số | Giá trị | Có được đổi không | Nguồn |
|---|---|---|---|
| Loại mạch | **Tổ hợp** | ❌ | Charter metadata |
| Nhóm đề | C · Ngưỡng, cảnh báo và giám sát | ❌ | Charter metadata |
| Độ khó | Trung bình (nhẹ) | — | Charter metadata |
| Quy mô ước lượng | ~150–210 cell · 1×1 tile | — | Charter metadata |
| Top module | `c02_core` | ❌ | RTL |
| Số flip-flop mong đợi | **0** | ❌ | Charter mục 10 |

## 2. Môi trường công cụ đã dùng để sinh bằng chứng

| Hạng mục | Giá trị |
|---|---|
| Hệ điều hành | Ubuntu 22.04 / K130 Environment |
| Mô phỏng | **Icarus Verilog 12.0 (stable)** (cờ `-g2012`) |
| Tổng hợp | **Yosys 0.33** |
| STA + công suất | **OpenSTA / LibreLane** |
| Thư viện standard cell | `sky130_fd_sc_hd` |
| File Liberty | `sky130_fd_sc_hd__tt_025C_1v80.lib` |
| Góc PVT | **typical · 25 °C · 1,80 V** |
| Flow P&R | **LibreLane / OpenLane** |
| PDK đích cho P&R | **sky130A** |

> ⚠️ Mọi con số cell, diện tích, timing, công suất trong hồ sơ này gắn chặt với **đúng** tổ
> hợp trên. Đổi bất kỳ thành phần nào thì số liệu đổi theo. Charter mục 6 yêu cầu nêu
> **điều kiện tạo ra bằng chứng** — bảng này chính là điều kiện đó.

## 3. Số liệu đo được

| Chỉ số | Giá trị | Nguồn |
|---|---:|---|
| Số cell sau tổng hợp | 94 | `06_GDSII/synthesis/synth_stat.txt` |
| Flip-flop | 0 | như trên |
| Diện tích lõi vi mạch | 435.68 µm² | `06_GDSII/physical_report.md` |
| Độ trễ đường tới hạn | 3.20 ns | `06_GDSII/sta/timing_report_max.txt` |
| Tần số tối đa ước tính ($f_{max}$) | 312.5 MHz | Tính từ $1/T_{pd\_max}$ |
| Tổng công suất (ước lượng) | ~12.5 µW | `06_GDSII/power/power_report.txt` |
| Tỷ lệ công suất tổ hợp | 100.0 % | như trên |
| Tỷ lệ công suất tuần tự | 0.0 % | như trên |

---

*Phiên bản: v1.0 · Ngày: 2026-10-25*