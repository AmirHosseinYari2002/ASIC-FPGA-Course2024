module Part3(SW, LEDR, LEDG, KEY, HEX7, HEX6, HEX5, HEX4, HEX1, HEX0);
	input [8:0] SW;
	input [1:0] KEY;
	output [6:0] HEX7, HEX6, HEX5, HEX4, HEX1, HEX0;
	output [7:0] LEDR;
	output [8:0] LEDG;

wire c;
reg [7:0]A;
reg [7:0]B;
wire [7:0]C;
reg [7:0]S;
ripple_carry_adder adder1(
    .A(A[3:0]),
    .B(B[3:0]),
    .ci(SW[8]),
    .S(C[3:0]),
    .co(c)
    );
ripple_carry_adder adder2(
    .A(A[7:4]),
    .B(B[7:4]),
    .ci(c),
    .S(C[7:4]),
    .co(LEDG[8])   
    );
always @(posedge KEY[1] or negedge KEY[0])
begin
    if(!KEY[0])begin
        A <= 8'b00000000;
        B <= 8'b00000000;
		  S <= 8'b00000000;
    end
    else begin
        S <= C;
        B <= C;
        A <= (SW[7:0]^{8{SW[8]}}) + SW[8];
    end
end


	sevenSegment hex7 (.A(A[3:0]), .out(HEX7));
	sevenSegment hex6 (.A(A[7:4]), .out(HEX6));
	sevenSegment hex5 (.A(B[3:0]), .out(HEX5));
	sevenSegment hex4 (.A(B[7:4]), .out(HEX4));
	sevenSegment hex1 (.A(S[3:0]), .out(HEX1));
	sevenSegment hex0 (.A(S[7:4]), .out(HEX0));

	assign LEDR = S;
	
endmodule
