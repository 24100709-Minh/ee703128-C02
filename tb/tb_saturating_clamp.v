`timescale 1ns / 1ps

module tb_saturating_clamp;

    // Khai báo tín hiệu kết nối
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;
    wire [7:0] uo_out;
    wire       uio_out0;

    // Gọi module RTL cần kiểm thử (DUT - Device Under Test)
    saturating_clamp u_dut (
        .ui_in(ui_in),
        .uio_in(uio_in),
        .uo_out(uo_out),
        .uio_out0(uio_out0)
    );

    initial begin
        // Xuất file sóng dạng .vcd để mở bằng GTKWave
        $dumpfile("sim/tb_saturating_clamp.vcd");
        $dumpvars(0, tb_saturating_clamp);

        // Thiết lập ngưỡng trên mặc định là 0xD0 (208)
        uio_in = 8'hD0;

        $display("=== BAT DAU KIEM THU BO KEP SATURATING CLAMP ===");

        // TC1: ui_in = 0x05 (< 0x10) -> kẹp về 0x10, cờ = 1
        ui_in = 8'h05; #10;
        $display("[TC1] Input=0x%02h | Upper=0x%02h | Output=0x%02h (Exp: 0x10) | Flag=%b (Exp: 1)", ui_in, uio_in, uo_out, uio_out0);

        // TC2: ui_in = 0x10 (đúng biên dưới) -> giữ 0x10, cờ = 0
        ui_in = 8'h10; #10;
        $display("[TC2] Input=0x%02h | Upper=0x%02h | Output=0x%02h (Exp: 0x10) | Flag=%b (Exp: 0)", ui_in, uio_in, uo_out, uio_out0);

        // TC3: ui_in = 0x60 (trong dải an toàn) -> giữ 0x60, cờ = 0
        ui_in = 8'h60; #10;
        $display("[TC3] Input=0x%02h | Upper=0x%02h | Output=0x%02h (Exp: 0x60) | Flag=%b (Exp: 0)", ui_in, uio_in, uo_out, uio_out0);

        // TC4: ui_in = 0xD0 (đúng biên trên) -> giữ 0xD0, cờ = 0
        ui_in = 8'hD0; #10;
        $display("[TC4] Input=0x%02h | Upper=0x%02h | Output=0x%02h (Exp: 0xD0) | Flag=%b (Exp: 0)", ui_in, uio_in, uo_out, uio_out0);

        // TC5: ui_in = 0xF0 (> 0xD0) -> kẹp về 0xD0, cờ = 1
        ui_in = 8'hF0; #10;
        $display("[TC5] Input=0x%02h | Upper=0x%02h | Output=0x%02h (Exp: 0xD0) | Flag=%b (Exp: 1)", ui_in, uio_in, uo_out, uio_out0);

        // TC6: Cực tiểu 0x00 -> kẹp về 0x10, cờ = 1
        ui_in = 8'h00; #10;
        $display("[TC6] Input=0x%02h | Upper=0x%02h | Output=0x%02h (Exp: 0x10) | Flag=%b (Exp: 1)", ui_in, uio_in, uo_out, uio_out0);

        // TC7: Cực đại 0xFF -> kẹp về 0xD0, cờ = 1
        ui_in = 8'hFF; #10;
        $display("[TC7] Input=0x%02h | Upper=0x%02h | Output=0x%02h (Exp: 0xD0) | Flag=%b (Exp: 1)", ui_in, uio_in, uo_out, uio_out0);

        $display("=== HOAN THANH MO PHONG ===");
        $finish;
    end

endmodule