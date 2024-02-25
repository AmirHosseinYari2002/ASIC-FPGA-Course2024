module SimpleALU(
    input signed [3:0] operand1,
    input signed [3:0] operand2,
    input [1:0] control,
    output reg signed [7:0] result
);

    reg signed [3:0] temp_operand1;  // Temporary variable for division

    always @*
    begin
        case (control)
            2'b00:   // Addition
                result = operand1 + operand2;
            2'b01:   // Multiplication
                result = operand1 * operand2;
            2'b10:   // Subtraction
                result = operand1 - operand2;
            2'b11: begin   // Division
                    result = 8'sb0;
                    // Division using repeated subtraction
                    temp_operand1 = operand1;
                    if (operand2 != 0) begin
                        while ((temp_operand1 >= operand2) || (temp_operand1 <= -operand2)) begin
                            temp_operand1 = temp_operand1 - operand2;
                            result = result + 1;
                        end
                    end
                end

        endcase
    end

endmodule
