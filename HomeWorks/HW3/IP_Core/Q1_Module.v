`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:04:27 04/05/2024 
// Design Name: 
// Module Name:    Q1_Module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Q1_Module (
    input [31:0] a,
    input [31:0] b,
    input clk,
    input [5:0] operation,
    output reg [31:0] result,
    output reg underflow,
    output reg overflow,
    output reg invalid_op
);

wire [31:0] add_sub_result; // Intermediate result for addition/subtraction
wire add_sub_underflow;
wire add_sub_overflow;
wire add_sub_invalid_op;

wire [31:0]  multiply_result; // Intermediate result for multiply
wire  multiply_underflow;
wire  multiply_overflow;
wire  multiply_invalid_op;


// Instantiate IP cores
floating_point add_subtract (
    .a(a),
    .b(b),
    .operation(operation),
    .clk(clk),
    .result(add_sub_result),
    .underflow(add_sub_underflow),
    .overflow(add_sub_overflow),
    .invalid_op(add_sub_invalid_op)
);

multiplier multiply (
    .a(a),
    .b(b),
    .clk(clk),
    .result(multiply_result),
    .underflow(multiply_underflow),
    .overflow(multiply_overflow),
    .invalid_op(multiply_invalid_op)
);

// Control logic for selecting operation
always @* begin
    case(operation)
        6'b000000: begin // Addition
            result <= add_sub_result;
				overflow <= add_sub_overflow;
				underflow <= add_sub_underflow;
				invalid_op <= add_sub_invalid_op;
        end
        6'b000001: begin // Subtraction
            result <= add_sub_result;
				overflow <= add_sub_overflow;
				underflow <= add_sub_underflow;
				invalid_op <= add_sub_invalid_op;
        end
        6'b000010: begin // Multiplication
				result <= multiply_result;
				underflow <= multiply_underflow;
				overflow <= multiply_overflow;
				invalid_op <= multiply_invalid_op;
        end
        default: begin
            result <= 32'b0; // Default result for invalid operation
            invalid_op <= 1;
        end
    endcase
end

endmodule
