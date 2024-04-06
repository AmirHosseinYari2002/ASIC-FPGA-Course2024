module DFF(D,clk,rst,Q);
    input D; 
    input clk;
    input rst;
    output reg Q;

    always @(posedge clk or negedge rst) 
    begin
        if(!rst)
            Q <= 1'b0; 
        else 
            Q <= D; 
    end 
endmodule 