module SimpleALU_TB;

    reg signed [3:0] operand1;
    reg signed [3:0] operand2;
    reg [1:0] control;
    wire signed [7:0] result;

    // Instantiate the ALU
    SimpleALU uut(.operand1(operand1), .operand2(operand2), .control(control), .result(result));

    // Test cases
    initial begin
        // Addition
        operand1 = 4;
        operand2 = -5;
        control = 2'b00;
        #10 $display("Addition: %0d + %0d = %0d", operand1, operand2, result);

        // Multiplication
        operand1 = -3;
        operand2 = 7;
        control = 2'b01;
        #10 $display("Multiplication: %0d * %0d = %0d", operand1, operand2, result);

        // Subtraction
        operand1 = 2;
        operand2 = 7;
        control = 2'b10;
        #10 $display("Subtraction: %0d - %0d = %0d", operand1, operand2, result);

        // Division
        operand1 = 6;
        operand2 = 3;
        control = 2'b11;
        #10 $display("Division: %0d / %0d = %0d", operand1, operand2, result);

        // Division 2
        operand1 = 5;
        operand2 = 3;
        control = 2'b11;
        #10 $display("Division: %0d / %0d = %0d", operand1, operand2, result);

        $stop;
    end

endmodule
