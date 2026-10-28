# C02 · Tầng 04 — Hiện thực (Implementation)

---

## 1. Nội dung thư mục
04_IMPLEMENTATION/
├── rtl/               c02_core.sv
├── constraints/       design.sdc
├── scripts/           01_run_sim.sh · 02_run_synth.sh · 03_run_sta.tcl
│                      04_run_librelane.sh · config.json · config_librelane.json
└── README.md
**Top module:** `c02_core`

## 2. Thứ tự chạy

```bash
python3 05_VERIFICATION/golden_model/reference_model.py     # ✅ PASS
bash 04_IMPLEMENTATION/scripts/01_run_sim.sh                # ✅ PASS
bash 04_IMPLEMENTATION/scripts/02_run_synth.sh              # ✅ PASS
sta -no_splash -exit 04_IMPLEMENTATION/scripts/03_run_sta.tcl   # ✅ PASS
bash 04_IMPLEMENTATION/scripts/04_run_librelane.sh          # ✅ PASS (GDSII clean)