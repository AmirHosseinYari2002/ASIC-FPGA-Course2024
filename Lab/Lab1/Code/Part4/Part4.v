// BCD Counter

module Part4(CLOCK_50, KEY, HEX2, HEX1, HEX0);
	input CLOCK_50;
	input [0:0] KEY;
	output [6:0] HEX2, HEX1, HEX0;
	
	/* Your code goes here */
	wire cmp1, cmp2, cmp3;

	reg [25:0] clk_counter;
	reg [4:0] A, B, C;

	always @(posedge CLOCK_50) begin
		if (!KEY[0]) begin
			A <= 4'b0;
			B <= 4'b0;
			C <= 4'b0;
			clk_counter <= 26'b0;
		end
		else begin
			if (clk_counter == 'd50_000_000)
				clk_counter <= 26'b0;
			else
				clk_counter <= clk_counter + 'b1;
			if (A == 'd10)
				A <= 4'b0;
			else if (cmp1)
				A <= A + 'b1;
			if (B == 'd10)
				B <= 4'b0;
			else if (cmp2)
				B <= B + 'b1;
			if (C == 'd10)
				C <= 4'b0;
			else if (cmp3)
				C <= C + 'b1;
		end
	end

	assign cmp1 = clk_counter == 'd50_000_000 ? 1'b1 : 1'b0;
	assign cmp2 = A == 'd10 ? 1'b1 : 1'b0;
	assign cmp3 = B == 'd10 ? 1'b1 : 1'b0;

	sevenSegment hex2 (.In(A), .out(HEX2));
	sevenSegment hex1 (.In(B), .out(HEX1));
	sevenSegment hex0 (.In(C), .out(HEX0));

endmodule
