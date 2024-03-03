module fulladder(Cout,Sum,Cin,A,B);
    input A,B,Cin;
    output Cout,Sum;

    assign Cout = (A&B)|(A&Cin)|(B&Cin);
    assign Sum = A^B^Cin;

endmodule
