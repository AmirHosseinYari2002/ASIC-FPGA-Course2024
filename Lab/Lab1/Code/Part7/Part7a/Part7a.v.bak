module Part7a(	input CLOCK_50, inout PS2_CLK, PS2_DAT, input [0:0] KEY, output [3:0] LEDR);

wire [3:0] ps2data;
wire ts;

////////////////////////////////////////////////////////////////////
// Dear 241 students, this is the first time you will be using
// other modules in your own design.  This looks intimidating at
// first, but you will learn a lot in the process!
//
// Please follow the lab handout and follow the comments to understand
// what to do.
//
// Good luck! =)
////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////
// PART7a
//
// Module for displaying keycodes on the LEDs, put your code
// into handshake_p1.v
///////////////////////////////////////////////////////////////////
handshake_p1 h(.clock(CLOCK_50), .reset(~KEY[0]), .ps2_data(ps2data),
		    .ts(ts),
			.leds(LEDR));
PS2_Controller PS2(	.clk(CLOCK_50), .reset(~KEY[0]), .PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT),
					.ps2data(ps2data), .tx_start(ts));

endmodule
