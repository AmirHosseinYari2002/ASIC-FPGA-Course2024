
module Mult1(in1, in2, inValid, en, clk, reset, out, outValid);
    input [7 : 0] in1, in2;
    input inValid, clk, en, reset;
    output reg [7 : 0] out;
    output reg          outValid;

    always @(posedge clk)begin
        if(reset == 0)begin
            outValid            <= 0;
        end
        else if(en == 1)begin
            out                 <= $signed(in1) * $signed(in2);
            outValid            <= inValid;
        end
        else
            outValid            <= 0;
    end
endmodule