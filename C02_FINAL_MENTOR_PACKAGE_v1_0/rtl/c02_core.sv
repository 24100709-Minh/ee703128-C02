// =====================================================================
// Module: c02_core
// Description: 8-bit Saturating Data Clamping Module
// =====================================================================
module c02_core (
    input  wire [7:0] data_in,
    input  wire [7:0] limit_low,
    input  wire [7:0] limit_high,
    output reg  [7:0] data_out
);

    always @(*) begin
        if (data_in < limit_low)
            data_out = limit_low;
        else if (data_in > limit_high)
            data_out = limit_high;
        else
            data_out = data_in;
    end

endmodule