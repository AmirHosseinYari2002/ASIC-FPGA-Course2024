`timescale 1ns / 1ps

module Q4_Moore_TB;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Signals
    reg clk;
    reg reset;
    reg valid;
    reg bit_in;
    wire bit_out;

    // Instantiate the DUT
    sequence_detector dut (
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .bit_in(bit_in),
        .bit_out(bit_out)
    );

    // Clock generation
    always #((CLK_PERIOD / 2)) clk <= ~clk;

    // Initial reset
    initial begin
        clk = 0;
        reset = 1;
        valid = 0;
        bit_in = 0;
        # (CLK_PERIOD * 1) reset = 0;
    end

    // Stimulus
    initial begin
        // Wait for initial reset to complete
        # (CLK_PERIOD * 1);

        // Input sequence "10110110110"
        # (CLK_PERIOD * 2) valid = 1;
        # CLK_PERIOD bit_in = 1;
        # CLK_PERIOD bit_in = 0;
        # CLK_PERIOD bit_in = 1;
        # CLK_PERIOD bit_in = 1;
        # CLK_PERIOD bit_in = 0;
        # CLK_PERIOD bit_in = 1;
        # CLK_PERIOD bit_in = 1;
        # CLK_PERIOD bit_in = 0;
        # CLK_PERIOD bit_in = 1;
        # CLK_PERIOD bit_in = 1;
        # CLK_PERIOD bit_in = 0;

        // Wait for sequence detection
        # (CLK_PERIOD * 5);

        // End simulation
        $stop;
    end

    // Display inputs and output
    always @(posedge clk) begin
        $display("Time = %t, bit_in = %b, bit_out = %b, sequence = %b", $time, bit_in, bit_out, dut.shift_reg);
    end

endmodule
