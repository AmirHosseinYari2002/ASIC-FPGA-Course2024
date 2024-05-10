module FIR_Filter_Symmetric(
    input Clk,                                   // Clock input
    input Reset,                                 // Reset signal
    input signed[7:0] InputData,                // Input data
    input[3:0] CoefficientIndex,                // Index of coefficient to update
    input signed[7:0] NewCoefficientValue,      // New value for coefficient
    input CoefficientWriteEnable,                // Enable for coefficient write
    output reg signed[24:0] FilterOutput        // Filter output
    );
    
    integer tapIndex;                            // Loop index for taps
    integer coefficientIndex;                    // Loop index for coefficients
    reg signed[7:0] Coefficients[4:0];           // Coefficient values
    reg signed[7:0] InputFrame[8:0];            // Input data buffer
    reg signed[24:0] OutputResult;               // Intermediate result
    
    always @(posedge Clk) begin
        if(!Reset) begin                         // Reset condition
            for(tapIndex = 0; tapIndex < 9; tapIndex = tapIndex + 1) // Initialization
                InputFrame[tapIndex] <= 8'd0;    // Reset input buffer
            for(coefficientIndex = 0; coefficientIndex < 5; coefficientIndex = coefficientIndex + 1)
                Coefficients[coefficientIndex] <= 8'd0; // Reset coefficients
            FilterOutput <= 25'd0;               // Reset output
        end
        else begin
            if(CoefficientWriteEnable)           // If coefficient write enable is asserted
                Coefficients[CoefficientIndex] <= NewCoefficientValue; // Update coefficient
            InputFrame[0] <= InputData;          // New input
            for(tapIndex = 1; tapIndex < 9; tapIndex = tapIndex + 1) begin
                InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
            end
            FilterOutput <= OutputResult;        // Update output
        end
    end
    
    always @(*) begin
        OutputResult = Coefficients[4] * InputFrame[4]; // Center tap operation
        for(coefficientIndex = 0; coefficientIndex < 4; coefficientIndex = coefficientIndex + 1) begin
            OutputResult = OutputResult + Coefficients[coefficientIndex] * (InputFrame[coefficientIndex] + InputFrame[8 - coefficientIndex]); // Symmetric taps operation
        end
    end
endmodule
