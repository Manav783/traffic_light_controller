//Do make the necessary changes in the main module before running this testbench

`timescale 1ns / 1ps

module testbench();
    reg clk, rst, ns,ew;
    wire [2:0] NS_str, NS_right, EW_str, EW_right;

    // Instantiate DUT
    traffic_light uut (
        .clk(clk),
        .rst(rst),
        .ns(ns),
        .ew(ew),
        .NS_str(NS_str),
        .NS_right(NS_right),
        .EW_str(EW_str),
        .EW_right(EW_right)
    );

    initial begin
        clk = 0; forever #5 clk = ~clk;
    end

    initial begin
        // Initialize inputs
        rst = 1;
        ns  = 0;
        ew  = 0;

        // Hold reset for a few cycles
        #10;
        rst = 0;

        // Let NS run without EW request
        #50;  // ~5 seconds simulation time

        // EW vehicle appears
        ew = 1;
        #50;
        ew = 0;

        // Later NS request
        #50;
        ns = 1;
        #20;
        ns = 0;

        // Both directions request
        #50;
        ns = 1;
        ew = 1;
        #50;
        ns = 0;
        ew = 0;

        // Run long enough to see full FSM cycle
        #100;

        $stop;
    end
endmodule
