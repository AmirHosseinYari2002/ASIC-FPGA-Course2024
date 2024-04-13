`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:38:30 04/05/2024 
// Design Name: 
// Module Name:    Q1_Module_TB 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Q1_Module_TB();

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Signals
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg [5:0] operation;
    wire [31:0] result;
    wire underflow;
    wire overflow;
    wire invalid_op;

    // Instantiate the DUT
    Q1_Module uut (
        .a(a),
        .b(b),
        .clk(clk),
        .operation(operation),
        .result(result),
        .underflow(underflow),
        .overflow(overflow),
        .invalid_op(invalid_op)
    );

    initial begin
        $dumpfile("withIPPower.vcd");
        $dumpvars(1, Q1_Module_TB.uut);
    end

    // Clock generation
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        a = 32'b01000001001000000000000000000000;
        b = 32'b01000000101000000000000000000000;
        operation = 6'b000000; // Addition

        // Apply inputs and wait for stabilization
        #200;
 
        // Check results
        $display("Addition Test:");
        $display("a = %b, b = %b, operation = %b", a, b, operation);
        #100;
        $display("Result = %b, Underflow = %b, Overflow = %b, Invalid Operation = %b", result, underflow, overflow, invalid_op);

        // Repeat the process for subtraction and multiplication
        operation = 6'b000001; // Subtraction
        #200;
        $display("\nSubtraction Test:");
        $display("a = %b, b = %b, operation = %b", a, b, operation);
        #100;
        $display("Result = %b, Underflow = %b, Overflow = %b, Invalid Operation = %b", result, underflow, overflow, invalid_op);

        operation = 6'b000010; // Multiplication
        #200;
        $display("\nMultiplication Test:");
        $display("a = %b, b = %b, operation = %b", a, b, operation);
        #100;
        $display("Result = %b, Underflow = %b, Overflow = %b, Invalid Operation = %b", result, underflow, overflow, invalid_op);

        // End simulation
        $stop;
    end

endmodule
