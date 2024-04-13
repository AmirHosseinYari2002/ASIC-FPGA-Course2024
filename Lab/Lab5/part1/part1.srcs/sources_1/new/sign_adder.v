`timescale 1ns / 1ps

module sign_adder(
    input wire [1:0] A,
    input wire [1:0] B,
    output wire [2:0] sum
);

assign sum = ~((~{A[1],A}) + (~{B[1],B}));

endmodule
