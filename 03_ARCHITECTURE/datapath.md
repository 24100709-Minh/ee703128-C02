# C02 · Đường dữ liệu (Datapath)

---

## 1. C02 có datapath thật — khác hẳn C01

C02 là khối duy nhất trong nhóm C có **đường dữ liệu 8 bit chạy xuyên từ đầu vào ra đầu ra**.
Ba toán hạng 8 bit đều là **ứng viên** cho giá trị ra, và mạch chọn một trong ba[cite: 23].
sample_in[7:0] ═══╗                                   ╔═══▶ clamped_out[7:0]
min_val[7:0]   ═══╬═══▶ ┌────────────────────────┐ ═══╝    (8 bit DỮ LIỆU)
max_val[7:0]   ═══╝     │  chọn 1 trong 3 toán   │
│  hạng, theo kết quả    │
│  của 3 phép so sánh    │
└────────────────────────┘


## 2. Số liệu thời gian datapath đo được từ STA

| Đại lượng | Giá trị | Nguồn |
|---|---:|---|
| Startpoint | `min_val[0]` / các chân đầu vào | `timing_report_max.txt`[cite: 23] |
| Endpoint | `clamped_out[1]` | như trên[cite: 23] |
| **Data arrival time ($T_{pd\_max}$)** | **3.20 ns** | như trên[cite: 23] |
| Slack | ~6.80 ns | như trên[cite: 23] |

---

*Phiên bản: v1.0 · Ngày: 2026-10-25*