`timescale 1ns / 1ps
module ComplexMultiplier2(
    input Clk,
    input Reset,
    input [15:0] InputMultiplier1,
    input [15:0] InputMultiplier2,
    output reg [33:0] MultiplicationResult
    );
	wire [15:0] ac;
	wire [15:0] bd;
	wire [15:0] ad;
	wire [15:0] bc;
	wire [15:0] ac2;
	wire [15:0] bd2;
	wire [15:0] ad2;
	wire [15:0] bc2;
		
	wire [15:0] ImagPart;
	wire [15:0] RealPart;
	wire [7:0]a;
	wire [7:0]b;
	wire [7:0]c;
	wire [7:0]d;
	
	assign a = InputMultiplier1[15] ? ~InputMultiplier1[15:8] + 1 : InputMultiplier1[15:8];
	assign b = InputMultiplier1[7] ? ~InputMultiplier1[7:0] + 1 : InputMultiplier1[7:0];
	assign c = InputMultiplier2[15] ? ~InputMultiplier2[15:8] + 1 : InputMultiplier2[15:8];
	assign d = InputMultiplier2[7] ? ~InputMultiplier2[7:0] + 1 : InputMultiplier2[7:0];
	
	assign ac = a * c;
	assign bd = b * d;
	assign ad = a * d;
	assign bc = b * c;
	
	assign ac2 = InputMultiplier1[15] ^ InputMultiplier2[15] ? ~ac + 1 : ac;
	assign bd2 = InputMultiplier1[7] ^ InputMultiplier2[7] ? ~bd + 1 : bd;
	assign ad2 = InputMultiplier1[15] ^ InputMultiplier2[7] ? ~ad + 1 : ad;
	assign bc2 = InputMultiplier1[7] ^ InputMultiplier2[15] ? ~bc + 1 : bc;
	
	assign ImagPart = ad2 + bc2;
	assign RealPart = ac2 - bd2;
	always @(posedge Clk)
	begin
		if(Reset)
		begin
			MultiplicationResult <= 34'b0;
		end
		else
		begin
			MultiplicationResult <= {RealPart[15],RealPart,ImagPart[15],ImagPart};
		end
	end
endmodule
