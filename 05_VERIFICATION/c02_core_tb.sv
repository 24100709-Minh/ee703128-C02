module c02_core_tb;
    logic [7:0] sample_in, min_val, max_val;
    logic [7:0] clamped_out;
    logic [7:0] clamped_ref;
    logic config_error_ref;

    c02_core dut(.*);

    c02_reference ref_i(
        .sample_in(sample_in),
        .min_val(min_val),
        .max_val(max_val),
        .clamped_ref(clamped_ref),
        .config_error_ref(config_error_ref)
    );

    task automatic check(
        input logic [7:0] x,
        input logic [7:0] lo,
        input logic [7:0] hi
    );
        begin
            sample_in=x;
            min_val=lo;
            max_val=hi;
            #1;

            assert(clamped_out === clamped_ref)
                else $fatal(1, "Mismatch x=%0d lo=%0d hi=%0d got=%0d exp=%0d",
                           x,lo,hi,clamped_out,clamped_ref);
        end
    endtask

    initial begin
        // Charter boundary categories.
        check(49,50,100);
        check(50,50,100);
        check(75,50,100);
        check(100,50,100);
        check(101,50,100);
        check(75,100,50);

        // Extra cases.
        check(0,0,0);
        check(255,255,255);
        check(0,0,255);
        check(255,0,255);
        check(128,128,128);
        check(127,128,200);
        check(201,128,200);

        // Broad deterministic sweep.
        for (int lo=0; lo<256; lo+=17)
            for (int hi=lo; hi<256; hi+=19)
                for (int x=0; x<256; x++)
                    check(x[7:0],lo[7:0],hi[7:0]);

        $display("C02 core verification PASS");
        $finish;
    end
endmodule