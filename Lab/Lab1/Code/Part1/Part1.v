// Adder

module Part1(SW, LEDR, LEDG);
	input [8:0] SW;
	output [8:0] LEDR;
	output [4:0] LEDG;

	/* Your code goes here */
	wire [2:0] Cout;

	fulladder fa1 (.A(SW[4]), .B(SW[0]), .Cin(SW[8]), .Sum(LEDG[0]), .Cout(Cout[0]));
	fulladder fa2 (.A(SW[5]), .B(SW[1]), .Cin(Cout[0]), .Sum(LEDG[1]), .Cout(Cout[1]));
	fulladder fa3 (.A(SW[6]), .B(SW[2]), .Cin(Cout[1]), .Sum(LEDG[2]), .Cout(Cout[2]));
	fulladder fa4 (.A(SW[7]), .B(SW[3]), .Cin(Cout[2]), .Sum(LEDG[3]), .Cout(LEDG[4]));

	assign LEDR = SW;


endmodule