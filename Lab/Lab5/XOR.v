module XOR(
    input [1:0] operand1,
    input [1:0] operand2,
    output [1:0] result
);

assign result = operand1 ^ (~operand2);

endmodule