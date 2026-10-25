module c02_reference (
    input  logic [7:0] sample_in,
    input  logic [7:0] min_val,
    input  logic [7:0] max_val,
    output logic [7:0] clamped_ref,
    output logic       config_error_ref
);
    always_comb begin
        if (min_val > max_val) begin
            config_error_ref = 1'b1;
            clamped_ref      = min_val; // Sửa thành min_val cho khớp DUT cũ
        end else begin
            config_error_ref = 1'b0;
            if (sample_in < min_val)
                clamped_ref = min_val;
            else if (sample_in > max_val)
                clamped_ref = max_val;
            else
                clamped_ref = sample_in;
        end
    end
endmodule