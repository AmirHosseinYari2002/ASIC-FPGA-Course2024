`timescale 1ns / 10ps

module ripple_carry_adder(
    input [3:0] A,
    input [3:0] B,
    input ci,
    output [3:0] S,
    output co
    );
wire c1;
wire c2;
wire c3;
full_adder adder1(
    .a(A[0]),
    .b(B[0]),
    .ci(ci),
    .s(S[0]),
    .co(c1)
    );
    
full_adder adder2(
    .a(A[1]),
    .b(B[1]),
    .ci(c1),
    .s(S[1]),
    .co(c2)
    );
        
full_adder adder3(
    .a(A[2]),
    .b(B[2]),
    .ci(c2),
    .s(S[2]),
    .co(c3)
    );
            
full_adder adder4(
    .a(A[3]),
    .b(B[3]),
    .ci(c3),
    .s(S[3]),
    .co(co)
    );

endmodule
