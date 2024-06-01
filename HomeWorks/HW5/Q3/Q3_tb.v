`timescale 1ns / 1ps

module ControlSignalDecoder_tb;

    // Parameters
    parameter CLK_PERIOD = 4; // 250 MHz clock period (4 ns)

    // Inputs
    reg clk;
    reg rst;
    reg ctrl_1;
    reg ctrl_2;
    reg ctrl_3;

    // Outputs
    wire [1:0] out_signal1;
    wire [1:0] out_signal2;
    wire [1:0] out_signal3;
    wire [11:0] out_timing1;
    wire [11:0] out_timing2;
    wire [11:0] out_timing3;

    // Instantiate the module
    ControlSignalDecoder dut (
        .clk(clk),
        .rst(rst),
        .ctrl_1(ctrl_1),
        .ctrl_2(ctrl_2),
        .ctrl_3(ctrl_3),
        .out_signal1(out_signal1),
        .out_signal2(out_signal2),
        .out_signal3(out_signal3),
        .out_timing1(out_timing1),
        .out_timing2(out_timing2),
        .out_timing3(out_timing3)
    );

    // Clock generation
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Initial values
    initial begin
        clk = 0;
        rst = 1;
        ctrl_1 = 0;
        ctrl_2 = 0;
        ctrl_3 = 0;
        #1000; // Bring module out of reset at 1000 nanoseconds
        rst = 0;
        #1448; // Wait for 2448 ns
        ctrl_2 = 1; // Activate second input
        #2552; // Wait for 5000 ns
        ctrl_1 = 1; // Activate first input
        #3741; // Wait for 8741 ns
        ctrl_3 = 1; // Activate third input
        #10; // Wait for a bit more for outputs to stabilize
        $stop; // Stop simulation
    end

    // Display outputs
    always @(*) begin
        $display("out_signal1 = %b, out_signal2 = %b, out_signal3 = %b, out_timing1 = %d, out_timing2 = %d, out_timing3 = %d", 
                 out_signal1, out_signal2, out_signal3, out_timing1, out_timing2, out_timing3);
    end

endmodule
