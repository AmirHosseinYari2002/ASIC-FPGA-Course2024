module Q2(
    input Clk,
    input Reset,
    input [2:0] Control,
    output reg incorrectControl
);

    parameter memorySize = 1024;
    
    integer i;
    reg [15:0] memIn [0:memorySize - 1];
    reg [15:0] memOut [0:memorySize - 1];
    
    always @(posedge Clk) begin
        if (!Reset) begin
            // Reset memory and incorrectControl
            for (i = 0; i < memorySize; i = i + 1)
                memOut[i] <= 0;
            incorrectControl <= 0;
        end else begin
            // Down-sampling logic
            if (Control <= 4 && Control != 0) begin
                for (i = 0; i < memorySize; i = i + 1)
                    memOut[i] <= memIn[(i << (Control - 1)) % memorySize];
                incorrectControl <= 0;
            end else
                incorrectControl <= 1;
        end
    end
    
endmodule
