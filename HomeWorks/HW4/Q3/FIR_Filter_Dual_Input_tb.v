`timescale 1ns / 1ps

module FIR_Filter_Dual_Input_tb;

// Parameters
parameter CLK_PERIOD = 10; // Clock period in ns

// Signals
reg clk = 0;
reg reset = 1;
reg signed [7:0] first_input_data;
reg signed [7:0] second_input_data;
reg [3:0] coefficient_number;
reg signed [7:0] coefficient_value;
reg coefficient_write_enable;
wire signed [19:0] first_output_result;
wire signed [19:0] second_output_result;

// Instantiate the module
FIR_Filter_Dual_Input DUT (
    .clk(clk),
    .reset(reset),
    .first_input_data(first_input_data),
    .second_input_data(second_input_data),
    .coefficient_number(coefficient_number),
    .coefficient_value(coefficient_value),
    .coefficient_write_enable(coefficient_write_enable),
    .first_output_result(first_output_result),
    .second_output_result(second_output_result)
);

// Clock generation
always #(CLK_PERIOD/2) clk = ~clk;

// Test input generation
initial begin
    // Reset
    #20 reset = 0;
    #100 reset = 1;

    // Write coefficients
    coefficient_number = 0;
    coefficient_value = 8'd1;
    coefficient_write_enable = 1;
    #50;
    coefficient_number = 1;
    coefficient_value = 8'd2;
    #50;
    coefficient_number = 2;
    coefficient_value = 8'd3;
    #50;
    coefficient_number = 3;
    coefficient_value = 8'd4;
    #50;
    coefficient_number = 4;
    coefficient_value = 8'd5;
    #50;
    coefficient_number = 5;
    coefficient_value = 8'd6;
    #50;
    coefficient_number = 6;
    coefficient_value = 8'd7;
    #50;
    coefficient_number = 7;
    coefficient_value = 8'd8;
    #50;
    coefficient_number = 8;
    coefficient_value = 8'd9;
    #50;
    coefficient_number = 9;
    coefficient_value = 8'd10;
    #50;
    coefficient_write_enable = 0;

    // Input data
    first_input_data = 8'd1;
    second_input_data = 8'd2;
    #50 first_input_data = 8'd3;
    #50 second_input_data = 8'd4;
    #50 first_input_data = 8'd5;
    #50 second_input_data = 8'd6;

    // Stop simulation
    #50 $stop;
end

// Monitor outputs
integer display_counter = 0;
integer wait_cycles = 64; // Number of cycles to wait before displaying output

always @(posedge clk) begin
    if (display_counter >= wait_cycles) begin
        $display("First Output: %d, Second Output: %d", first_output_result, second_output_result);
    end else begin
        display_counter <= display_counter + 1;
    end
end

endmodule
