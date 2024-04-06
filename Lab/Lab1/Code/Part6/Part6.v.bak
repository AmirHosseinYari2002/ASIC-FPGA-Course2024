// a sequence detector FSM. 
// SW1 is the active low synchronous reset, SW0 is the w input, and KEY0 is the clock.
// The z output appears on LEDG0, and the state FFs appear on LEDR3..0
module Part6 (SW, KEY, LEDG, LEDR);
	input [2:0] SW;
	input [0:0] KEY;
	output [0:0] LEDG;
	output [3:0] LEDR;

	wire Clock, Resetn, w, z;

	assign Clock = KEY[0];
	assign Resetn = SW[0];
	assign w = SW[1];
	assign wait_done = SW[2];

	/* Your code goes here */

	assign z = ...;
	assign LEDR[3:0] = ...;
	assign LEDG[0] = ...;
endmodule
