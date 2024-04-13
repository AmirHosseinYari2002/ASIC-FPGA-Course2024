`timescale 1ns / 1ps

module ALU_tb;

reg clk;
reg [31:0] a_operand, b_operand;
reg [3:0] Operation;
wire [31:0] ALU_Output;
wire Exception, Overflow, Underflow;

ALU ALU_inst(
    .clk(clk),
    .a_operand(a_operand),
    .b_operand(b_operand),
    .Operation(Operation),
    .ALU_Output(ALU_Output),
    .Exception(Exception),
    .Overflow(Overflow),
    .Underflow(Underflow)
);

initial begin
        $dumpfile("withIPPower.vcd");
        $dumpvars(1, ALU_tb.ALU_inst);
 end
 
initial begin
    clk = 0;
    #5;
    forever #10 clk = ~clk;
end

initial begin

	 // Test case: Addition
    a_operand = 32'b01000001001000000000000000000000;
    b_operand = 32'b01000000101000000000000000000000;
    Operation = 4'b0011; // Addition
    #200;
	 $display("\nTest Case: Addition");
    $display("a_operand = %b, b_operand = %b, Operation = %d", a_operand, b_operand, Operation);
    $display("ALU Output = %b, Exception = %b, Overflow = %b, Underflow = %b", ALU_Output, Exception, Overflow, Underflow);
	 
	 // Test case: Subtraction
    a_operand = 32'b01000001001000000000000000000000;
    b_operand = 32'b01000000101000000000000000000000;
    Operation = 4'b1010; // Subtraction
    #200;
	 $display("\nTest Case: Subtraction");
    $display("a_operand = %b, b_operand = %b, Operation = %d", a_operand, b_operand, Operation);
    $display("ALU Output = %b, Exception = %b, Overflow = %b, Underflow = %b", ALU_Output, Exception, Overflow, Underflow);

    // Test case: Multiplication
    a_operand = 32'b01000001001000000000000000000000;
    b_operand = 32'b01000000101000000000000000000000;
    Operation = 4'b0001; // Multiplication
    #200;
	 $display("\nTest Case: Multiplication");
    $display("a_operand = %b, b_operand = %b, Operation = %d", a_operand, b_operand, Operation);
    $display("ALU Output = %b, Exception = %b, Overflow = %b, Underflow = %b", ALU_Output, Exception, Overflow, Underflow);
	 

    $stop;
end

endmodule
