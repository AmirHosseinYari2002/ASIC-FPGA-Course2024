module Mult2(in1, in2, inValid, en, clk, reset, out, outValid);
    input [7 : 0] in1, in2;
    input inValid, clk, en, reset;
    output reg [15 : 0] out;
    output reg outValid;

    always @(posedge clk)begin
        if(en == 1) begin
            out  <= in1 * in2;
        end
    end

    assign outValid = inValid & en;
endmodule