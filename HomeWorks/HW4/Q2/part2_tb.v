`timescale 1ns / 1ps

module part2_tb;

   // Parameters
   parameter CLK_PERIOD = 10;

   // Signals
   reg clk;
   reg reset;
   reg [31:0] operand1, operand2;
   wire [63:0] result;

   // Instantiate the module under test
   part2 dut (
      .clk(clk),
      .reset(reset),
      .operand1(operand1),
      .operand2(operand2),
      .result(result)
   );

   // Clock generation
   always #((CLK_PERIOD)/2) clk = ~clk;

   // Reset generation
   initial begin
      clk = 0;
      reset = 1;
      #10; // Wait
      reset = 0;
   end

   // Stimulus
   initial begin
      // Test case 1
      operand1 = 10;
      operand2 = 5;
      #50; // Wait
      $display("a=%d, b=%d, result=%d", operand1, operand2, result);
      // Test case 2
      operand1 = 20;
      operand2 = 3;
      #50; // Wait
      $display("a=%d, b=%d, result=%d", operand1, operand2, result);
      // Test case 3
      operand1 = 1;
      operand2 = 4;
      #50; // Wait
      $display("a=%d, b=%d, result=%d", operand1, operand2, result);
      $stop; // Stop simulation
   end

endmodule
