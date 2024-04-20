module ALU(
    input [31:0] operand1,
    input [31:0] operand2,
    input [1:0] op,
    output reg [31:0] result
);

    always @(*)
    begin
        case (op)
            2'b00:   // Addition
                result = operand1 + operand2;
            2'b01:   // sub
                result = operand1 - operand2;
            2'b10:   // NAND
                result = ~(operand1 & operand2);
            2'b11:   // NOR
                result = ~(operand1 | operand2);
        endcase
    end

endmodule
