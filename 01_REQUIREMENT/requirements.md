# C02 · Bảng yêu cầu (Requirements)

Mọi yêu cầu đều **suy trực tiếp từ Project Charter — C02**. Cột *Nguồn* chỉ rõ mục nào
của Charter sinh ra yêu cầu đó. Không có yêu cầu nào do người soạn tự thêm.

Mức: **M** = bắt buộc · **S** = nên có · **O** = tuỳ chọn.

---

## 1. Yêu cầu chức năng và cấu trúc

| ID | Mức | Nội dung yêu cầu | Nguồn |
|---|---|---|---|
| REQ-C02-001 | M | Khối thực hiện đúng chức năng mô tả trong Charter mục 1: *Bộ kẹp giá trị bão hoà (saturating clamp) 8-bit*. | mục 1 |
| REQ-C02-002 | M | Giao diện đúng ánh xạ chân Charter mục 4 (xem `02_SPECIFICATION/interface.md`). | mục 4 |
| REQ-C02-003 | M | Loại mạch phải đúng phân loại Charter: **Tổ hợp** — nghĩa là **0 ô nhớ**. | mục 10 |
| REQ-C02-004 | M | Quy mô nằm trong khoảng hợp lý cho ô 1×1 tile (Charter ước lượng ~150–210 cell · 1×1 tile). | metadata |

## 2. Yêu cầu kiểm chứng

| ID | Mức | Nội dung yêu cầu | Nguồn |
|---|---|---|---|
| REQ-C02-010 | M | Chạy đủ các ca kiểm thử bắt buộc của Charter mục 8 (xem §4). | mục 8 |
| REQ-C02-011 | M | Bổ sung **ít nhất hai ca tự xây dựng**, trong đó có **ca biên**. | mục 8 |
| REQ-C02-012 | M | Mỗi khẳng định phải đi kèm **bằng chứng** và **điều kiện tạo ra bằng chứng**. | mục 6 |
| REQ-C02-013 | S | Thu một **artifact số có chú thích** và nêu điều kiện tạo ra nó. | mục 3, 5 |

## 3. Yêu cầu phân tích riêng (đặc thù của C02)

> Charter mục 9 — bắt buộc trả lời bằng số liệu của chính mình:
>
> Phân tích ảnh hưởng của khối logic xử lý ngoại lệ cấu hình (min_val > max_val) đến tổng số lượng standard cell và độ trễ lan truyền (critical path delay) của mạch kẹp bão hòa saturating_clamp 8-bit so với phương án thiết kế lược bỏ mạch bảo vệ ngoại lệ.

| ID | Mức | Nội dung |
|---|---|---|
| REQ-C02-020 | M | Trả lời câu phân tích riêng ở trên bằng dữ liệu do chính mình sinh ra. |
| REQ-C02-021 | M | Trả lời các câu hỏi kỹ thuật Charter mục 2 (xem §5) bằng bằng chứng. |

## 4. Ca kiểm thử bắt buộc (Charter mục 8)

- Dưới ngưỡng dưới · đúng biên · trong khoảng · đúng biên trên · trên ngưỡng trên
- Bổ sung ít nhất hai ca tự xây dựng, trong đó có ca biên.

Danh sách thực thi và kết quả: `05_VERIFICATION/test_matrix.csv`.

## 5. Câu hỏi kỹ thuật của Charter (mục 2)

1. **Kẹp bão hoà khác phép cắt bằng phép AND mặt nạ ở chỗ nào?**
2. **Cờ 'đang bị kẹp' nói cho tầng trên biết điều gì mà giá trị đầu ra không nói được?**
3. **Đường tới hạn đi qua bộ so sánh nào?**

Câu trả lời kèm bằng chứng: `05_VERIFICATION/verification_report.md` và `06_GDSII/physical_report.md`.

## 6. Yêu cầu bàn giao (Charter mục 5)

- Hồ sơ phân tích đủ tám thành phần, có số phiên bản và ngày sửa.
- Bảng giao diện: tên tín hiệu, chiều, độ rộng, mức tích cực, giả định.
- Một artifact số có chú thích và nêu điều kiện tạo ra nó.
- Kết luận nêu rõ đã chứng minh được gì và chưa chứng minh được gì.

## 7. Mốc thực hiện (Charter mục 7)

- M1 · T7. Chốt đề và viết charter: ứng dụng, mục tiêu, 2–3 câu hỏi kỹ thuật.
- M2 · T8–9. Bảng hành vi suy từ đặc tả; đọc RTL và waveform; lập danh sách ca kiểm thử.
- M3 · T11–12. Sơ đồ khối hỗ trợ; thu artifact số, chú thích và đối chiếu bảng hành vi.
- M4 · T13–14. Hoàn thiện bảng giao diện, RTM-lite, sơ đồ vòng đời; rà từng khẳng định.
- M5 · T15. Nộp hồ sơ và trình bày; trả lời câu phân tích riêng bằng số của chính mình.

## 8. Rủi ro chính (Charter mục 10)

> Chỗ hay tắc: Xuất giá trị kẹp đúng nhưng quên cờ — rồi không giải thích được vì sao cần cờ.
> Dấu hiệu làm đúng: 0 ô nhớ. Hai bộ so sánh + hai tầng ghép kênh.

---

*Phiên bản: v1.0 · Ngày: 2026-09-24 · Nguồn chuẩn: `Project_Charter_80_De.docx`, mục C02.*