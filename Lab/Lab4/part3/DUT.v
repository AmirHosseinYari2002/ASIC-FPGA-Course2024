module DUT(
    input Clk,
    input Reset,
    input [1:0] Control,
    input [15:0] Input1,
    input [15:0] Input2,
    output reg [37:0] Output1
    );
	
	
	wire [31:0]input1_square;
	wire [31:0]input2_square;
	wire [32:0]x_in;
	wire [16:0] out_00;
	wire [15:0]input1;
	wire [15:0]input2;
	
	assign input1 = Input1[15]?(~Input1 + 1):Input1;
	assign input2 = Input2[15]?(~Input2 + 1):Input2;;
	assign input1_square = input1 * input1;
	assign input2_square = input2 * input2;
	assign x_in = input1_square + input2_square;
	
	CORDIC suare_root (
  .x_in(x_in), // input [32 : 0] x_in
  .x_out(out_00), // output [16 : 0] x_out
  .clk(Clk) // input clk
	);
	
	wire [33:0]MultiplicationResult;
	ComplexMultiplier complex_multiplier (
    .Clk(Clk), 
    .Reset(Reset), 
    .InputMultiplier1(Input1), 
    .InputMultiplier2(Input2), 
    .MultiplicationResult(MultiplicationResult)
    );
	 
	
	reg [15:0] a1;
	reg [15:0] b1;
	reg [15:0] a2;
	reg [15:0] b2;
	reg [15:0] a3;
	reg [15:0] b3;
	wire [32:0]p1;
	wire [33:0]p2;
	wire [34:0]p3;
	wire [47:0]pcout1;
	wire [47:0]pcout2;
	reg [7:0] counter;
	reg [1:0]state10;
	MultAdd1 MultAdd01 (
  .clk(Clk), // input clk
  .ce(1), // input ce
  .sclr(Reset), // input sclr
  .a(a1), // input [15 : 0] a
  .b(b1), // input [15 : 0] b
  .c(0), // input [1 : 0] c
  .subtract(0), // input subtract
  .p(p1), // output [32 : 0] p
  .pcout(pcout1) // output [47 : 0] pcout
	);
	
	MultAdd2 MultAdd02 (
  .clk(Clk), // input clk
  .ce(1), // input ce
  .sclr(Reset), // input sclr
  .a(a2), // input [15 : 0] a
  .b(b2), // input [15 : 0] b
  .c(p1), // input [47 : 0] c
  .pcin(pcout1), // input [47 : 0] pcin
  .subtract(0), // input subtract
  .p(p2), // output [33 : 0] p
  .pcout(pcout2) // output [47 : 0] pcout
	);
	
	MultAdd3 MultAdd03 (
  .clk(Clk), // input clk
  .ce(1), // input ce
  .sclr(Reset), // input sclr
  .a(a3), // input [15 : 0] a
  .b(b3), // input [15 : 0] b
  .c(p2), // input [47 : 0] c
  .pcin(pcout2), // input [47 : 0] pcin
  .subtract(0), // input subtract
  .p(p3), // output [34 : 0] p
  .pcout() // output [47 : 0] pcout
	);
	
	//state 11
	reg [15:0]Mem1[0:8];
	reg [15:0]Mem2[0:8];
	reg [4:0]state11;
	reg [15:0]Input1Mult1;
	reg [15:0]Input2Mult1;
	reg [15:0]Input1Mult2;
	reg [15:0]Input2Mult2;
	reg [15:0]Input1Mult3;
	reg [15:0]Input2Mult3;
	wire [33:0] MultiplicationResult1;
	wire [33:0] MultiplicationResult2;
	wire [33:0] MultiplicationResult3;
	ComplexMultiplier1 CM1 (
    .Clk(Clk), 
    .Reset(Reset), 
    .InputMultiplier1(Input1Mult1), 
    .InputMultiplier2(Input2Mult1), 
    .MultiplicationResult(MultiplicationResult1)
    );
	 
	 ComplexMultiplier2 CM2 (
    .Clk(Clk), 
    .Reset(Reset), 
    .InputMultiplier1(Input1Mult2), 
    .InputMultiplier2(Input2Mult2), 
    .MultiplicationResult(MultiplicationResult2)
    );
	 
	 ComplexMultiplier3 CM3 (
    .Clk(Clk), 
    .Reset(Reset), 
    .InputMultiplier1(Input1Mult3), 
    .InputMultiplier2(Input2Mult3), 
    .MultiplicationResult(MultiplicationResult3)
    );
	wire [18:0]out_state11Imag;
	wire [18:0]out_state11Real;
	assign out_state11Imag = {MultiplicationResult1[16],MultiplicationResult1[16],MultiplicationResult1[16:0]} + {MultiplicationResult2[16],MultiplicationResult2[16],MultiplicationResult2[16:0]} + {MultiplicationResult3[16],MultiplicationResult3[16],MultiplicationResult3[16:0]};
	assign out_state11Real = {MultiplicationResult1[33],MultiplicationResult1[33],MultiplicationResult1[33:17]} + {MultiplicationResult2[33],MultiplicationResult2[33],MultiplicationResult2[33:17]} + {MultiplicationResult3[33],MultiplicationResult3[33],MultiplicationResult3[33:17]};
	//
	reg control_enable;
	reg [1:0]old_control;
	always @(posedge Clk)
	begin
		if(Reset)
		begin
			state10 <= 2'b00;
			counter <= 8'b0;
			state11 <= 5'b0;
			control_enable <= 1;
		end
		else
		begin
			if(control_enable)
            begin
					old_control <= Control;
					control_enable <= 0;
            end
			case(old_control)
				2'b00: 
                begin
                    Output1 <= {21'b0,out_00};
                    control_enable <= 1;
                end
                2'b01: 
                begin
                    Output1 <= {4'b0,MultiplicationResult};
                    control_enable <= 1;
                end
                2'b10:
						begin
                    case(state10)
						2'b00:
						begin
							a1 <= Input1;
							b1 <= Input2;
							state10 <= 2'b01;
						end
						2'b01:
						begin
							a2 <= Input1;
							b2 <= Input2;
							state10 <= 2'b10;
						end
						2'b10:
						begin
							a3 <= Input1;
							b3 <= Input2;
							state10 <= 2'b11;
						end
						2'b11:
						begin
							counter <= counter + 1;
							if(counter < 6)
								state10 <= 2'b11;
							else
							begin
								state10 <= 2'b00;
								counter <= 8'b0;
								Output1 <= {3'b0,p3};
                        control_enable <= 1;
							end
						end
					endcase
				end
				2'b11:
				begin
					case(state11)
						5'b00000:
						begin
							Mem1[0] <= Input1;
							Mem2[0] <= Input2;
							state11 <= 5'b00001;
						end
						5'b00001:
						begin
							Mem1[1] <= Input1;
							Mem2[1] <= Input2;
							state11 <= 5'b00010;
						end
						5'b00010:
						begin
							Mem1[2] <= Input1;
							Mem2[2] <= Input2;
							state11 <= 5'b00011;
						end
						5'b00011:
						begin
							Mem1[3] <= Input1;
							Mem2[3] <= Input2;
							state11 <= 5'b00100;
						end
						5'b00100:
						begin
							
							Mem1[4] <= Input1;
							Mem2[4] <= Input2;
							state11 <= 5'b00101;
						end
						5'b00101:
						begin
							Mem1[5] <= Input1;
							Mem2[5] <= Input2;
							state11 <= 5'b00110;
						end
						5'b00110:
						begin
							Mem1[6] <= Input1;
							Mem2[6] <= Input2;
							state11 <= 5'b00111;
						end
						5'b00111:
						begin
							Mem1[7] <= Input1;
							Mem2[7] <= Input2;
							state11 <= 5'b01000;
							Input1Mult1 <= Mem1[0];
							Input2Mult1 <= Mem2[0];//1
							Input1Mult2 <= Mem1[1];
							Input2Mult2 <= Mem2[3];
							Input1Mult3 <= Mem1[2];
							Input2Mult3 <= Mem2[6];
						end
						5'b01000://1,1
						begin
							Mem1[8] <= Input1;
							Mem2[8] <= Input2;
							state11 <= 5'b01001;
							Input1Mult1 <= Mem1[0];
							Input2Mult1 <= Mem2[1];
							Input1Mult2 <= Mem1[1];
							Input2Mult2 <= Mem2[4];
							Input1Mult3 <= Mem1[2];//2
							Input2Mult3 <= Mem2[7];

						end
						5'b01001://1,2
						begin
							Output1 <= {out_state11Real,out_state11Imag};//1
							Input1Mult1 <= Mem1[0];
							Input2Mult1 <= Mem2[2];
							Input1Mult2 <= Mem1[1];
							Input2Mult2 <= Mem2[5];//3
							Input1Mult3 <= Mem1[2];
							Input2Mult3 <= Mem2[8];
							state11 <= 5'b01010;
						end
						5'b01010://1,3
						begin
							Output1 <= {out_state11Real,out_state11Imag};//2
							Input1Mult1 <= Mem1[3];
							Input2Mult1 <= Mem2[0];
							Input1Mult2 <= Mem1[4];
							Input2Mult2 <= Mem2[3];
							Input1Mult3 <= Mem1[5];//4
							Input2Mult3 <= Mem2[6];
							state11 <= 5'b01011;
						end
						5'b01011://2,1
						begin
							Output1 <= {out_state11Real,out_state11Imag};//3
							Input1Mult1 <= Mem1[3];
							Input2Mult1 <= Mem2[1];
							Input1Mult2 <= Mem1[4];
							Input2Mult2 <= Mem2[4];
							Input1Mult3 <= Mem1[5];
							Input2Mult3 <= Mem2[7];//5
							state11 <= 5'b01100;
						end
						5'b01100://2,2
						begin
							Output1 <= {out_state11Real,out_state11Imag};//4
							Input1Mult1 <= Mem1[3];
							Input2Mult1 <= Mem2[2];
							Input1Mult2 <= Mem1[4];
							Input2Mult2 <= Mem2[5];
							Input1Mult3 <= Mem1[5];//6
							Input2Mult3 <= Mem2[8];
							state11 <= 5'b01101;
						end
						5'b01101://2,3
						begin
							Output1 <= {out_state11Real,out_state11Imag};//5
							Input1Mult1 <= Mem1[6];
							Input2Mult1 <= Mem2[0];
							Input1Mult2 <= Mem1[7];
							Input2Mult2 <= Mem2[3];//7
							Input1Mult3 <= Mem1[8];
							Input2Mult3 <= Mem2[6];
							state11 <= 5'b01110;
						end
						5'b01110://3,1
						begin
							Output1 <= {out_state11Real,out_state11Imag};//6
							Input1Mult1 <= Mem1[6];
							Input2Mult1 <= Mem2[1];
							Input1Mult2 <= Mem1[7];//8
							Input2Mult2 <= Mem2[4];
							Input1Mult3 <= Mem1[8];
							Input2Mult3 <= Mem2[7];
							state11 <= 5'b01111;
						end
						5'b01111://3,2
						begin
							Output1 <= {out_state11Real,out_state11Imag};//7
							Input1Mult1 <= Mem1[6];
							Input2Mult1 <= Mem2[2];
							Input1Mult2 <= Mem1[7];//9
							Input2Mult2 <= Mem2[5];
							Input1Mult3 <= Mem1[8];
							Input2Mult3 <= Mem2[8];
							state11 <= 5'b10000;
						end
						5'b10000://3,3
						begin
							Output1 <= {out_state11Real,out_state11Imag};//8
							state11 <= 5'b10001;
						end
						5'b10001:
						begin
							state11 <= 5'b00000;
							Output1 <= {out_state11Real,out_state11Imag};//9
						  control_enable <= 1;
                  end
					endcase
				end
				default: Output1 <= 38'bx;
			endcase
		end
	end

endmodule
