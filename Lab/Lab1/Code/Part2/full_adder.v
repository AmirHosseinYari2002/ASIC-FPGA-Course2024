`timescale 1ns / 10ps

module full_adder(
    input a,
    input b,
    input ci,
    output s,
    output co
    );
assign {co,s}=a+b+ci;    
endmodule