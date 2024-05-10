module part1(
    input wire clk,
    input wire reset,
    input wire [31:0] operand1,
    input wire [31:0] operand2,
    output reg [63:0] result
);

reg [63:0] stage1_result;
reg [63:0] stage2_result;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        stage1_result <= 0;
        stage2_result <= 0;
        result <= 0;
    end
    else begin
        // Pipeline Stage 1: Multiply operands
        stage1_result <= operand1 * operand2;
        
        // Pipeline Stage 2: Multiply the result by 7
        stage2_result <= stage1_result * 7;
        
        // Output the result after latency
        result <= stage2_result;
    end
end

endmodule
