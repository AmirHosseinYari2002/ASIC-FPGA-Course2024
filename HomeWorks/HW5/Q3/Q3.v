module ControlSignalDecoder (
    input clk,        // Clock input
    input rst,        // Reset input
    input ctrl_1,     // Control signal 1 input
    input ctrl_2,     // Control signal 2 input
    input ctrl_3,     // Control signal 3 input
    output reg [1:0] out_signal1,  // Output signals 1
    output reg [1:0] out_signal2,  // Output signals 2
    output reg [1:0] out_signal3,  // Output signals 3
    output reg [11:0] out_timing1,    // Output timing 1
    output reg [11:0] out_timing2,    // Output timing 2
    output reg [11:0] out_timing3    // Output timing 3
);

reg [1:0] first_signal;    
reg [1:0] second_signal;   
reg [1:0] third_signal;    
reg [11:0] timing_1;         
reg [11:0] timing_2;         
reg [11:0] timing_3;         

// Sequential logic for detecting control signals and their timing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        first_signal <= 2'b0;
        second_signal <= 2'b0;
        third_signal <= 2'b0;
        timing_1 <= 8'b0;
        timing_2 <= 8'b0;
        timing_3 <= 8'b0;
    end else begin
        if (first_signal == 2'b0) begin
            if (ctrl_1)
                first_signal <= 2'b01;
            else if (ctrl_2)
                first_signal <= 2'b10;
            else if (ctrl_3)
                first_signal <= 2'b11;
        end else if (second_signal == 2'b0) begin
            if (ctrl_1 && first_signal != 2'b01)
                second_signal <= 2'b01;
            else if (ctrl_2 && first_signal != 2'b10)
                second_signal <= 2'b10;
            else if (ctrl_3 && first_signal != 2'b11)
                second_signal <= 2'b11;
        end else if (third_signal == 2'b0) begin
            if (ctrl_1 && first_signal != 2'b01 && second_signal != 2'b01)
                third_signal <= 2'b01;
            else if (ctrl_2 && first_signal != 2'b10 && second_signal != 2'b10)
                third_signal <= 2'b10;
            else if (ctrl_3 && first_signal != 2'b11 && second_signal != 2'b11)
                third_signal <= 2'b11;
        end
        // Update timing
        if (first_signal == 2'b0)
            timing_1 <= timing_1 + 1;
        if (second_signal == 2'b0)
            timing_2 <= timing_2 + 1;
        if (third_signal == 2'b0)
            timing_3 <= timing_3 + 1;
    end
end

// Output assignment
always @(*) begin
    out_signal1 = first_signal;
    out_signal2 = second_signal;
    out_signal3 = third_signal;
    out_timing1 = timing_1;
    out_timing2 = timing_2;
    out_timing3 = timing_3;
end

endmodule
