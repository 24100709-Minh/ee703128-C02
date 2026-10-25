module c02_core (
    input  logic [7:0] sample_in,
    input  logic [7:0] min_val,
    input  logic [7:0] max_val,
    output logic [7:0] clamped_out
);

    always_comb begin
        if (min_val > max_val) begin
            clamped_out = sample_in;
        end else if (sample_in < min_val) begin
            clamped_out = min_val;
        end else if (sample_in > max_val) begin
            clamped_out = max_val;
        end else begin
            clamped_out = sample_in;
        end
    end

endmodule