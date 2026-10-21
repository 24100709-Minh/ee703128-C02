module c02_core (
    input  logic [7:0] sample_in,
    input  logic [7:0] min_val,
    input  logic [7:0] max_val,
    output logic [7:0] clamped_out
);
    always_comb begin
        if (min_val > max_val)
            clamped_out = min_val;  // Xử lý cấu hình không hợp lệ
        else if (sample_in < min_val)
            clamped_out = min_val;  // Kẹp dưới
        else if (sample_in > max_val)
            clamped_out = max_val;  // Kẹp trên
        else
            clamped_out = sample_in; // Giữ nguyên giá trị trong dải an toàn
    end
endmodule