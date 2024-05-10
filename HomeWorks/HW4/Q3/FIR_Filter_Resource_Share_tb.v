`timescale 1ns / 1ps

module FIR_Filter_Resource_Share_tb;

    reg Clk;                                     // Clock signal
    reg Reset;                                   // Reset signal
    reg signed[7:0] InputData;                   // Input data
    reg[3:0] CoefficientIndex;                   // Index of coefficient to update
    reg signed[7:0] NewCoefficientValue;         // New value for coefficient
    reg CoefficientWriteEnable;                  // Enable for coefficient write
    wire signed[24:0] FilterOutput;              // Filter output
    
    integer i;                                   // Loop index
    integer errors = 0;                          // Error count
    
    initial Clk = 1;                             // Initialize clock
    
    always @(Clk)
        Clk <= #5 ~Clk;                         // Toggle clock every 5 time units
    
    initial begin
        $display("Starting testbench simulation...");
        Reset = 0;                               // Reset registers
        @(posedge Clk);
        Reset = #1 1;
        InputData = 0;
        $display("Reset signal asserted.");
        
        CoefficientWriteEnable = 1;              // Enable coefficient write
        for(i = 0; i < 10; i = i + 1) begin // Initialize coefficients
            CoefficientIndex = i;
            NewCoefficientValue = i + 1;
            $display("Setting coefficient[%d] to %d", CoefficientIndex, NewCoefficientValue);
            @(posedge Clk) #1;
        end
        CoefficientWriteEnable = 0;              // Disable coefficient write
        $display("Coefficient initialization completed.");
        
        InputData = #2 1;                        // Input a value of 1 after some time
        $display("Inputting value 1 to the filter.");
        @(posedge Clk) #2;
        
        for(i = 0; i < 21; i = i + 1) begin
            if (i > 9) begin
               $display("Output[%d] is: %d", i, FilterOutput); 
            end
            @(posedge Clk) #2;
        end
        $display("Testbench simulation completed.");
        $display("Number of errors = %d", errors); // Output number of errors
        $stop;                                    // Stop simulation
    end
    
    FIR_Filter_Resource_Share uut(           // Instantiate the FIR filter
        .Clk(Clk),
        .Reset(Reset),
        .InputData(InputData),
        .CoefficientIndex(CoefficientIndex),
        .NewCoefficientValue(NewCoefficientValue),
        .CoefficientWriteEnable(CoefficientWriteEnable),
        .FilteredOutput(FilterOutput)
    );

endmodule
