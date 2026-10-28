# C02 · Sơ đồ khối bên trong (Block Diagram)

Tài liệu vẽ **hai** sơ đồ: một theo **RTL thật**, một theo **netlist thật**. Chúng khác nhau
ở một chỗ rất đáng học — công cụ đã **gộp hai nhánh** của RTL.

---

## 1. Sơ đồ theo RTL (`c02_core.sv`)

RTL viết dạng chuỗi `if / else if` bốn nhánh, tương đương một chuỗi ba bộ ghép kênh ưu tiên:
───────────────────────────────────────────────────────────────────────────┐
│                               c02_core                                    │
│                                                                           │
│  min_val ──┬───────────────┐                                              │
│  max_val ──┼──┬────────────┼──────┐                                       │
│            ▼  ▼            │      │                                       │
│      ┌──────────────┐      │      │                                       │
│      │ SO SÁNH 1    │      │      │                                       │
│      │ min > max    │ dòng 8                                              │
│      └──────┬───────┘      │      │                                       │
│             │              │      │                                       │
│  sample ────┼──┬───────────┼──┬───┼──────────────┐                        │
│             │  ▼           ▼  │   │              │                        │
│             │ ┌──────────────┐│   │              │                        │
│             │ │ SO SÁNH 2    ││   │              │                        │
│             │ │ sample < min ││ dòng 10          │                        │
│             │ └──────┬───────┘│   │              │                        │
│             │        │        ▼   ▼              │                        │
│             │        │  ┌──────────────┐         │                        │
│             │        │  │ SO SÁNH 3    │         │                        │
│             │        │  │ sample > max │ dòng 12 │                        │
│             │        │  └──────┬───────┘         │                        │
│             │        │         │                 │                        │
│             │        │         │    max_val ──┐  │ sample_in              │
│             │        │         ▼              ▼  ▼                        │
│             │        │       ┌──────────────────────┐                     │
│             │        │       │ MUX 3 (dòng 12–15)   │ 8 bit               │
│             │        │       └──────────┬───────────┘                     │
│             │        │  min_val ──┐     │                                 │
│             │        ▼            ▼     ▼                                 │
│             │      ┌──────────────────────┐                               │
│             │      │ MUX 2 (dòng 10–11)   │ 8 bit                         │
│             │      └──────────┬───────────┘                               │
│             │  min_val ──┐    │                                           │
│             ▼            ▼    ▼                                           │
│           ┌──────────────────────┐                                        │
│           │ MUX 1 (dòng 8–9)     │ 8 bit                                  │
│           └──────────┬───────────┘                                        │
└──────────────────────┼────────────────────────────────────────────────────┘
▼
clamped_out[7:0]
**Theo RTL: 3 bộ so sánh + 3 tầng mux 8 bit.**
Charter mục 10 nói *"hai bộ so sánh + hai tầng ghép kênh"* — nhìn RTL thì có vẻ **nhiều hơn**.
Netlist giải thích vì sao.

## 2. Sơ đồ theo NETLIST thật (`06_GDSII/synthesis/netlist.v`)
┌─ CHUỖI A: min > max ─────────────────────┐
min_val[0] ──▶ 076 isobuf ──▶ 077 ▶ 078 ▶ … ▶ 083 ──▶ 023   │
└──── 7 × maj3_1 ────┘          │     │
~max_val[1..7] (từ 061..072 clkinv) ─────────────────────────┘     │
│     │
┌─ CHUỖI B: sample < min ──────────────┼─────┤
sample_in, min_val ──▶ 086,087,088,089,090…101 ──▶ 041   │
(4 × maj3 + xor/xnor/aoi… hỗn hợp)         │     │
▼     ▼
┌──────────────────────┐
│ 102 nor2           │
│ 042 = ¬(A ∨ B)     │
└──────────┬───────────┘
│ fanout 7
┌─ CHUỖI C: sample > max ─┐           │
sample_in[0] ──▶ 104 nand2b ▶ 105 ▶ … ▶ 109   │           │
└─ 5 × maj3_1 ─┘         │           │
▶ 110 ▶ 111 ▶ 112 ─┴──▶ 052  │
│        │
┌─────────────────────────────────────────────────┘        │
│                                                          │
▼  TẦNG MUX 1: chọn giữa sample_in và max_val              │
┌────────────────────────────────────────────────┐              │
│ 113,115,117,119,121,123,125      │              │
│ 7 × mux2i_1  (bit 0…6)   S = 052             │              │
└──────────────────────┬─────────────────────────┘              │
│ 053…059                            │
▼  TẦNG MUX 2: chọn giữa min_val và tầng 1
┌──────────────────────────────────────────────────────────────┐
│ 114 mux2i · 116,118,120,122,124 mux2 · 126 mux2i│
│ 7 mux (bit 0…6)          S = 042                            │
└──────────────────────┬────────────────────────────────────────┘
▼
clamped_out[6:0]

BIT 7 ĐẶC BIỆT:  127 a31o_1( max_val[7], sample_in[7], 040, min_val[7] )
→ clamped_out[7]       ◄── MỘT cell thay cho HAI tầng mux
3. Bảng ánh xạ cấu trúc RTL → phần cứng sinh ra

| Dòng RTL | Mã | Phần cứng thật | Instance | Số cell |
|---:|---|---|---|---:|
| 8 | `if (min_val > max_val)` | Chuỗi mượn ripple 8 tầng | `_076_` + `_077_…_083_` | **8** |
| 10 | `else if (sample_in < min_val)` | Cấu trúc **hỗn hợp**: 4 tầng `maj3` + cây logic | `_084_…_101_` | **18** |
| 12 | `else if (sample_in > max_val)` | Chuỗi ripple **rút gọn** 5 tầng + 3 cổng gộp | `_103_…_112_` | **10** |
| 9, 11 | `clamped_out = min_val;` (hai lần) | **GỘP LÀM MỘT** → `_102_ nor2` sinh tín hiệu chọn chung | `_102_` | **1** |
| 13, 15 | chọn `max_val` hay `sample_in` | Tầng mux 1 | `_113_…_125_` (lẻ) | **7** |
| 9/11 vs 13/15 | chọn `min_val` hay kết quả tầng 1 | Tầng mux 2 | `_114_,_116_,_118_,_120_,_122_,_124_,_126_` | **7** |
| — | bit 7: hai tầng mux **gộp vào một cell** | | `_127_` `a31o_1` | **1** |
| — | cổng đảo toán hạng dùng chung | `_060_…_075_` | **16** |
| | | | **Tổng** | **94** ✅ khớp báo cáo tổng hợp |

## 4. Ba phát hiện khi đọc netlist

### 4.1 Công cụ **gộp hai nhánh RTL** thành một tín hiệu chọn

RTL có **bốn** nhánh, trong đó **hai** nhánh đầu cho ra cùng một giá trị:

```systemverilog
if (min_val > max_val)         clamped_out = min_val;   // nhánh 1
else if (sample_in < min_val)  clamped_out = min_val;   // nhánh 2  ← CÙNG GIÁ TRỊ
else if (sample_in > max_val)  clamped_out = max_val;   // nhánh 3
else                           clamped_out = sample_in; // nhánh 4
sky130_fd_sc_hd__nor2_1 _102_ ( .A(_023_), .B(_041_), .Y(_042_) );
//                                  ▲         ▲          ▲
//                           (min>max)  (sample<min)   _042_ = ¬(min>max ∨ sample<min)
//                                                     = "KHÔNG chọn min_val"