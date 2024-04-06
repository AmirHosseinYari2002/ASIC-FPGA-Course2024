module Q3_19(
    input  Clk,          // Clock signal
    input Reset,         // Reset signal
    input signed[18:0] A_real,  // Real part of input A
    input signed[18:0] A_imag,  // Imaginary part of input A
    input signed[18:0] B_real,  // Real part of input B
    input signed[18:0] B_imag,  // Imaginary part of input B
    output signed[47:0] Out_real, // Real part of the output
    output signed[47:0] Out_imag  // Imaginary part of the output
    );

    integer index;

    // Registers for each stage
    reg signed[17:0] first_stage_regs[8:0];  // Registers for the first stage
    reg signed[18:0] second_stage_regs[5:0]; // Registers for the second stage
    reg signed[47:0] third_stage_regs[2:0];  // Registers for the third stage
    reg signed[47:0] fourth_stage_regs[1:0]; // Registers for the fourth stage

    // Output connections
    assign Out_real = fourth_stage_regs[0];  // Connect output real to the fourth stage's real
    assign Out_imag = fourth_stage_regs[1];  // Connect output imaginary to the fourth stage's imaginary

    always @(posedge Clk) begin
        if(!Reset) begin
            // Reset all stage registers to zero
            for(index = 0; index < 9; index = index + 1)
                first_stage_regs[index] <= 19'd0;
            for(index = 0; index < 6; index = index + 1)
                second_stage_regs[index] <= 20'd0;
            for(index = 0; index < 3; index = index + 1)
                third_stage_regs[index] <= 48'd0;
            for(index = 0; index < 2; index = index + 1)
                fourth_stage_regs[index] <= 48'd0;
        end else begin
            // Input assignment
            first_stage_regs[0] <= A_real;
            first_stage_regs[1] <= A_imag;
            first_stage_regs[2] <= B_imag;
            first_stage_regs[3] <= B_real;
            first_stage_regs[4] <= B_imag;
            first_stage_regs[5] <= A_real;
            first_stage_regs[6] <= B_real;
            first_stage_regs[7] <= B_imag;
            first_stage_regs[8] <= A_imag;
            // Calculation
            second_stage_regs[0] <= first_stage_regs[0] - first_stage_regs[1];
            second_stage_regs[1] <= first_stage_regs[2];
            second_stage_regs[2] <= first_stage_regs[3] - first_stage_regs[4];
            second_stage_regs[3] <= first_stage_regs[5];
            second_stage_regs[4] <= first_stage_regs[6] + first_stage_regs[7];
            second_stage_regs[5] <= first_stage_regs[8];
            // Multiplication
            third_stage_regs[0] <= second_stage_regs[0] * second_stage_regs[1];
            third_stage_regs[1] <= second_stage_regs[2] * second_stage_regs[3];
            third_stage_regs[2] <= second_stage_regs[4] * second_stage_regs[5];
            // Addition
            fourth_stage_regs[0] <= third_stage_regs[0] + third_stage_regs[1];
            fourth_stage_regs[1] <= third_stage_regs[0] + third_stage_regs[2];
        end
    end

endmodule
