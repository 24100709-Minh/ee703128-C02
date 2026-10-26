# C02 · Bối cảnh ứng dụng

| Thông tin | Chi tiết |
|---|---|
| Mã đề | **C02** |
| Tên đề | Bộ kẹp giá trị bão hoà (saturating clamp) 8-bit |
| Nhóm đề | C · Ngưỡng, cảnh báo và giám sát |
| Độ khó | Trung bình (nhẹ) |
| Loại mạch | **Tổ hợp** |
| Quy mô ước lượng (Charter) | ~150–210 cell · 1×1 tile |
| Nguồn gốc | Project Charter — C02, mục 1 |

---

## 1. Mục tiêu và bối cảnh ứng dụng

Trích nguyên văn Charter mục 1:

> Phân tích khối số “Bộ kẹp giá trị bão hoà (saturating clamp) 8-bit” ở mức khối. Bối cảnh ứng dụng: Khối giới hạn biên độ tín hiệu trước khi đưa vào bộ khuếch đại, tránh đưa giá trị ngoài dải làm méo tầng sau.

## 2. Vị trí khối C02 trong hệ thống
┌──────────────┐      ┌──────────────────────────────┐      ┌──────────────┐
│  Nguồn tín   │─────▶│      ►►► KHỐI C02 ◄◄◄        │─────▶│  Tầng tiêu   │
│  hiệu / dữ   │      │  Bộ kẹp giá trị bão hoà (satu │      │  thụ kết quả │
│  liệu vào    │      │  Loại mạch: Tổ hợp           │      │              │
└──────────────┘      └──────────────────────────────┘      └──────────────┘
> Sơ đồ chi tiết có chú thích: `03_ARCHITECTURE/system_diagram.md`.

## 3. Phân loại analog / digital / mixed

| Khối | Phân loại | Ghi chú |
|---|---|---|
| Cảm biến / nguồn tín hiệu vật lý (nếu có) | Analog | Đại lượng liên tục |
| Chuyển đổi ADC/DAC (nếu có) | Mixed-signal | Ranh giới analog–số |
| **C02 — Bộ kẹp giá trị bão hoà (saturating clamp) 8-bit** | **Digital, tổ hợp** | Đầu ra chỉ phụ thuộc đầu vào hiện tại; không clock, không ô nhớ |
| Tầng xử lý phía sau | Digital | Tiêu thụ kết quả của C02 |

Bằng chứng cho dòng phân loại của C02: tổng hợp thật cho **0 flip-flop**
(`06_GDSII/synthesis/synth_stat.txt`).

---

**Truy vết:** yêu cầu sinh từ tài liệu này được đánh số `REQ-C02-0xx` trong
`01_REQUIREMENT/requirements.md`, và truy vết đến bằng chứng trong `07_TRACEABILITY/RTM.csv`.

*Phiên bản: v1.0 · Ngày: 2026-09-24*