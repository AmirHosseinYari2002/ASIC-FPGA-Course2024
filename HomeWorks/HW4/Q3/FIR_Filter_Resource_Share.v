module FIR_Filter_Resource_Share(
    input Clk,                                     // Clock input
    input Reset,                                   // Reset input
    input signed[7:0] InputData,                   // Input data
    input[3:0] CoefficientIndex,                   // Index of coefficient to update
    input signed[7:0] NewCoefficientValue,         // New value for coefficient
    input CoefficientWriteEnable,                  // Enable for coefficient write
    output reg signed[24:0] FilteredOutput        // Filter output
    );
    parameter numberOfTaps = 10;                   // Number of filter taps
    
    integer tapIndex;                              // Loop index for taps
    integer coefficientIndex;                      // Loop index for coefficients
    reg signed[7:0] Coefficients[numberOfTaps - 1:0]; // Coefficient values
    reg signed[7:0] InputFrame[numberOfTaps - 1:0]; // Input data buffer
    reg signed[24:0] OutputResult;                 // Intermediate result
    reg signed[7:0] MultData;
    reg signed[7:0] MultCoef;
    reg [3:0] state;
    reg [24:0] accumsum;
    wire [24:0] MultOut;
    wire [24:0] accum;


    always @(posedge Clk) begin
        if(!Reset) begin                           // Reset condition
            for(tapIndex = 0; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin // Initialization
                InputFrame[tapIndex] <= 8'd0;      // Reset input buffer
                Coefficients[tapIndex] <= 8'd0;    // Reset coefficients
            end
            FilteredOutput <= 25'd0;               // Reset output
            state <= 0;
        end
        else begin
            if(CoefficientWriteEnable)             // If coefficient write enable is asserted
                Coefficients[CoefficientIndex] <= NewCoefficientValue; // Update coefficient
            else begin
            case (state)
                0 :begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputData;
                    MultCoef <= Coefficients[0];
                    state <= 1;
                    FilteredOutput <= accumsum;
                end 
                1: begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputFrame[1];
                    MultCoef <= Coefficients[1];
                    state <= 2;
                end
                2: begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputFrame[2];
                    MultCoef <= Coefficients[2];
                    state <= 3;
                end
                3: begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputFrame[3];
                    MultCoef <= Coefficients[3];
                    state <= 4;
                end
                4: begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputFrame[4];
                    MultCoef <= Coefficients[4];
                    state <= 5;
                end
                5: begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputFrame[5];
                    MultCoef <= Coefficients[5];
                    state <= 6;
                end
                6: begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputFrame[6];
                    MultCoef <= Coefficients[6];
                    state <= 7;
                end
                7: begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputFrame[7];
                    MultCoef <= Coefficients[7];
                    state <= 8;
                end
                8: begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputFrame[8];
                    MultCoef <= Coefficients[8];
                    state <= 9;
                end
                9: begin
                    InputFrame[0] <= InputData;             // New input
                    for(tapIndex = 1; tapIndex < numberOfTaps; tapIndex = tapIndex + 1) begin
                        InputFrame[tapIndex] <= InputFrame[tapIndex-1]; // Shift input buffer
                    end
                    MultData <= InputFrame[9];
                    MultCoef <= Coefficients[9];
                    state <= 10;
                end
                10: begin
                    state <= 0;
                end
                default: state <= 0;
            endcase
            end
        end
    end
    
    always @(posedge Clk) begin
        if(!Reset) begin  
            accumsum <= 0;
        end else begin
        accumsum <= accum + MultOut;
        end
    end

assign MultOut = (state==0)?25'd0 : MultCoef*MultData;
assign accum = (state==0)?25'd0 : accumsum;
    
endmodule
