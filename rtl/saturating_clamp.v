module saturating_clamp (
    input  wire [7:0] ui_in,       // Mẫu dữ liệu đầu vào (8-bit)
    input  wire [7:0] uio_in,      // Ngưỡng trên (8-bit)
    output wire [7:0] uo_out,      // Mẫu dữ liệu đã kẹp (8-bit)
    output wire       uio_out0     // Cờ báo bị kẹp (1-bit)
);

    // Ngưỡng dưới cố định (16 thập phân = 8'h10)
    wire [7:0] TH_LOWER = 8'h10;
    
    // Ngưỡng trên lấy từ uio_in
    wire [7:0] TH_UPPER = uio_in;

    // Tín hiệu so sánh điều kiện biên
    wire under_flow = (ui_in < TH_LOWER);
    wire over_flow  = (ui_in > TH_UPPER);

    // Mux chọn giá trị ngõ ra
    assign uo_out = under_flow ? TH_LOWER :
                    over_flow  ? TH_UPPER : ui_in;

    // Cờ kẹp: bằng 1 nếu nhỏ hơn ngưỡng dưới HOẶC lớn hơn ngưỡng trên
    assign uio_out0 = under_flow | over_flow;

endmodule