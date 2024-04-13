module Addition_Subtraction (
    input wire clk,
    input wire [31:0] a_operand,
    input wire [31:0] b_operand,
    input wire AddBar_Sub,
    output reg Exception,
    output reg [31:0] result
);

reg [31:0] operand_a_reg, operand_b_reg;
reg [7:0] exponent_diff_reg;
reg perform_reg;
reg [23:0] significand_b_add_sub_reg;
reg [7:0] exponent_b_add_sub_reg;
reg [24:0] significand_add_reg;
reg [30:0] add_sum_reg;
reg [24:0] significand_sub_complement_reg;
reg [24:0] significand_sub_reg;
reg [30:0] sub_diff_reg;
reg [24:0] subtraction_diff_reg;
reg [7:0] exponent_sub_reg;
reg output_sign_reg;
reg operation_sub_addBar_reg;
reg [23:0] significand_a_reg, significand_b_reg;

always @(posedge clk) begin
    operand_a_reg <= a_operand;
    operand_b_reg <= b_operand;
    exponent_diff_reg <= operand_a_reg[30:23] - operand_b_reg[30:23];
    perform_reg <= (operand_a_reg[30:23] == (operand_b_reg[30:23] + exponent_diff_reg));
    significand_b_add_sub_reg <= operand_b_reg[22:0] << exponent_diff_reg;
    exponent_b_add_sub_reg <= operand_b_reg[30:23] + exponent_diff_reg;
    significand_a_reg <= (|operand_a_reg[30:23]) ? {1'b1,operand_a_reg[22:0]} : {1'b0,operand_a_reg[22:0]};
    significand_b_reg <= (|operand_b_reg[30:23]) ? {1'b1,operand_b_reg[22:0]} : {1'b0,operand_b_reg[22:0]};
    output_sign_reg <= AddBar_Sub ? (perform_reg ? operand_a_reg[31] ^ operand_b_reg[31] : ~(operand_a_reg[31] ^ operand_b_reg[31])) : operand_a_reg[31];
    operation_sub_addBar_reg <= AddBar_Sub ? operand_a_reg[31] ^ operand_b_reg[31] : ~(operand_a_reg[31] ^ operand_b_reg[31]);
end

always @(posedge clk) begin
    if (Exception) begin
        result <= 32'b0;
    end else begin
        if (!operation_sub_addBar_reg) begin // Subtraction
            if (perform_reg) begin
                significand_sub_complement_reg <= ~(significand_b_add_sub_reg) + 25'd1;
                significand_sub_reg <= significand_a_reg + significand_sub_complement_reg;
                subtraction_diff_reg <= significand_sub_reg[24:0];
                exponent_sub_reg <= operand_a_reg[30:23];
            end
            result <= {output_sign_reg, {exponent_sub_reg, subtraction_diff_reg[22:0]}};
        end else begin // Addition
            if (perform_reg) begin
                significand_add_reg <= significand_a_reg + significand_b_add_sub_reg;
                add_sum_reg <= significand_add_reg[24] ? significand_add_reg[23:1] : significand_add_reg[22:0];
                add_sum_reg[30:23] <= significand_add_reg[24] ? (1'b1 + operand_a_reg[30:23]) : operand_a_reg[30:23];
            end
            result <= {output_sign_reg, add_sum_reg};
        end
    end
end

always @(posedge clk) begin
    Exception <= (&operand_a_reg[30:23]) | (&operand_b_reg[30:23]);
end

endmodule
