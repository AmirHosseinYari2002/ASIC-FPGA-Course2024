module FIR_Filter_One_Coef(
    input Clk,                                   // Clock input
    input Reset,                                 // Reset signal
    input signed[7:0] InputData,                // Input data
    input[3:0] CoefficientIndex,                // Index of coefficient to update
    input signed[7:0] NewCoefficientValue,      // New value for coefficient
    input CoefficientWriteEnable,                // Enable for coefficient write
    output reg signed[18:0] FilterOutput        // Filter output
    );
    
    parameter numberOfTaps = 10;                // Number of filter taps

    integer tapIndex;                            // Loop index for taps
    integer coefficientIndex;                    // Loop index for coefficients
    reg signed[1:0] Coefficients[numberOfTaps - 1:0]; // Coefficient values
    reg signed[7:0] InputFrame[numberOfTaps - 1:0]; // Input data buffer
    reg signed[18:0] OutputResult;               // Intermediate result
    
    always @(posedge Clk) begin
        if(!Reset) begin                         // Reset condition
            for(tapIndex = 0; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin // Initialization
                InputFrame[tapIndex] <= 8'd0;    // Reset input buffer
                Coefficients[tapIndex] <= 2'd0;  // Reset coefficients
            end
            FilterOutput <= 25'd0;               // Reset output
        end
        else begin
            if(CoefficientWriteEnable)           // If coefficient write enable is asserted
                Coefficients[CoefficientIndex] <= NewCoefficientValue[1:0]; // Update coefficient
            InputFrame[0] <= InputData;          // New input
            for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
            end
            FilterOutput <= OutputResult;        // Update output
        end
    end
    
    always @(*) begin
        OutputResult = 0;                        // Reset intermediate result
        for(coefficientIndex = 0; coefficientIndex < numberOfTaps; coefficientIndex = coefficientIndex + 1) begin
            if(Coefficients[coefficientIndex][0])
                OutputResult = OutputResult + (Coefficients[coefficientIndex][1] ? -InputFrame[coefficientIndex] : InputFrame[coefficientIndex]);
        end
    end
endmodule
