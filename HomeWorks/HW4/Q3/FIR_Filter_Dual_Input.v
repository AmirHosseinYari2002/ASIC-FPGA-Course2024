`timescale 1ns / 1ps

module FIR_Filter_Dual_Input(
    input clk,
    input reset,
    input signed [7:0] first_input_data,
    input signed [7:0] second_input_data,
    input [3:0] coefficient_number,
    input signed [7:0] coefficient_value,
    input coefficient_write_enable,
    output reg signed [19:0] first_output_result,
    output reg signed [19:0] second_output_result
);

// Memory for coefficients and input data
reg [7:0] coefficient_memory [0:9];
reg [7:0] input_data_memory [0:10];

// Internal state
reg [2:0] state;

integer index;

always @(posedge clk, negedge reset) begin
    if (!reset) begin
        state <= 3'b000; // Reset state
    end
    else begin
        case (state)
            3'b000: begin
                // Write coefficients and initialize input data memory
                if (coefficient_write_enable) begin
                    coefficient_memory[coefficient_number] = coefficient_value;
                    input_data_memory[coefficient_number] = 0;
                end else begin
                    input_data_memory[10] = 0; // Initialize last input data memory
                    state <= 3'b001; // next state
                end
            end
            3'b001: begin
                // Compute first FIR output
                first_output_result = coefficient_memory[0] * input_data_memory[0] +
                                       coefficient_memory[1] * input_data_memory[1] +
                                       coefficient_memory[2] * input_data_memory[2] +
                                       coefficient_memory[3] * input_data_memory[3] +
                                       coefficient_memory[4] * input_data_memory[4] +
                                       coefficient_memory[5] * input_data_memory[5] +
                                       coefficient_memory[6] * input_data_memory[6] +
                                       coefficient_memory[7] * input_data_memory[7] +
                                       coefficient_memory[8] * input_data_memory[8] +
                                       coefficient_memory[9] * input_data_memory[9];
                // Compute second FIR output
                second_output_result = coefficient_memory[0] * input_data_memory[1] +
                                        coefficient_memory[1] * input_data_memory[2] +
                                        coefficient_memory[2] * input_data_memory[3] +
                                        coefficient_memory[3] * input_data_memory[4] +
                                        coefficient_memory[4] * input_data_memory[5] +
                                        coefficient_memory[5] * input_data_memory[6] +
                                        coefficient_memory[6] * input_data_memory[7] +
                                        coefficient_memory[7] * input_data_memory[8] +
                                        coefficient_memory[8] * input_data_memory[9] +
                                        coefficient_memory[9] * input_data_memory[10];
                // Shift input data
                for (index = 10; index > 0; index = index - 1) begin
                    input_data_memory[index] = input_data_memory[index - 1];
                end
                // Update input data memory with new inputs
                input_data_memory[0] = second_input_data;
                input_data_memory[1] = first_input_data;
            end
        endcase
    end
end

endmodule
