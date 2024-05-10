module FIR_Filter_Symmetric_Pipeline(
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
        end
        else begin
            if(CoefficientWriteEnable)           // If coefficient write enable is asserted
                Coefficients[CoefficientIndex] <= NewCoefficientValue; // Update coefficient
            InputFrame[0] <= InputData;          // New input
            for(tapIndex = 1; tapIndex < 9; tapIndex = tapIndex + 1) begin
                InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
            end
        end
    end
    
    reg signed[15:0] partialSums[2:0];

    always @(posedge Clk) begin
        // Stage 1: Center tap operation
        partialSums[0] <= Coefficients[4] * InputFrame[4];
        
        // Stage 2: Symmetric taps operation (1st half)
        partialSums[1] <= Coefficients[0] * (InputFrame[0] + InputFrame[8]) +
                        Coefficients[1] * (InputFrame[1] + InputFrame[7]);
                        
        // Stage 3: Symmetric taps operation (2nd half)
        partialSums[2] <= Coefficients[2] * (InputFrame[2] + InputFrame[6]) +
                        Coefficients[3] * (InputFrame[3] + InputFrame[5]);
                        
        // Stage 4: Reduction for final sum
        FilterOutput <= partialSums[0] + partialSums[1] + partialSums[2];
    end
    
endmodule
