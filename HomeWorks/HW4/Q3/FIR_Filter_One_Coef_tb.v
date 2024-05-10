`timescale 1ns / 1ps

`define NUMBER_OF_TAPS 10

module FIR_Filter_One_Coef_tb;

    reg Clk;
    reg Reset;
    reg signed[7:0] InputData;
    reg[3:0] CoefficientIndex;
    reg signed[7:0] NewCoefficientValue;
    reg CoefficientWriteEnable;
    wire signed[18:0] FilterOutput;

    integer i;
    integer errors = 0;
    reg signed[7:0] randomCoefs[`NUMBER_OF_TAPS-1:0];

    initial Clk = 1;

    always @(Clk)
        Clk <= #5 ~Clk;

    initial begin
        $display("Starting testbench simulation...");

        // Initialize random coefficients
        for(i = 0; i < `NUMBER_OF_TAPS; i = i + 1)
            randomCoefs[i] = $random % 2;

        Reset = 0;                               // Reset registers
        @(posedge Clk);
        Reset = #1 1;
        InputData = 0;

        CoefficientWriteEnable = 1;              // Enable coefficient write
        for(i = 0; i < `NUMBER_OF_TAPS; i = i + 1) begin // Initialize coefficients
            CoefficientIndex = i;
            NewCoefficientValue = randomCoefs[i];
            $display("Setting coefficient[%d] to %d", CoefficientIndex, NewCoefficientValue);
            @(posedge Clk) #1;
        end
        CoefficientWriteEnable = 0;              // Disable coefficient write

        @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);
        
        InputData = #2 1;                        // Input a value of 1 after some time
        @(posedge Clk) #2;
        InputData = 0;
        @(posedge Clk) #2;

        for(i = 0; i < `NUMBER_OF_TAPS; i = i + 1) begin
            if(FilterOutput !== randomCoefs[i]) begin
                $display("Error: Output[%d] is %d instead of %d", i, FilterOutput, randomCoefs[i]);
                errors = errors + 1;             // Count errors
            end
            else begin
                $display("Output[%d] is correct: %d", i, FilterOutput);
            end
            @(posedge Clk) #2;
        end
        $display("Testbench simulation completed.");
        $display("Number of errors = %d", errors); // Output number of errors
        $stop;                                    // Stop simulation
    end
    
    FIR_Filter_One_Coef uut(           // Instantiate the simple FIR filter
        .Clk(Clk),
        .Reset(Reset),
        .InputData(InputData),
        .CoefficientIndex(CoefficientIndex),
        .NewCoefficientValue(NewCoefficientValue),
        .CoefficientWriteEnable(CoefficientWriteEnable),
        .FilterOutput(FilterOutput)
    );
    defparam uut.numberOfTaps = `NUMBER_OF_TAPS;

endmodule
