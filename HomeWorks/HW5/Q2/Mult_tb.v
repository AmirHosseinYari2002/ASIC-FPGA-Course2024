module testbench();
    reg [7:0] in1, in2;
    reg inValid, clk, en, reset;
    wire [7:0] out1;
    wire [15:0] out2;
    wire outValid1, outValid2;

    Mult1 uut1 (
        .in1(in1), .in2(in2), .inValid(inValid), .clk(clk), .en(en), .reset(reset), 
        .out(out1), .outValid(outValid1)
    );

    Mult2 uut2 (
        .in1(in1), .in2(in2), .inValid(inValid), .clk(clk), .en(en), .reset(reset), 
        .out(out2), .outValid(outValid2)
    );

    initial begin
        clk = 0;
        reset = 0;
        en = 0;
        inValid = 0;
        in1 = 8'd0;
        in2 = 8'd0;

        $monitor("in1: %d, in2: %d, inValid: %b, en: %b, reset: %b, out1: %d, outValid1: %b, out2: %d, outValid2: %b", 
                  in1, in2, inValid, en, reset, out1, outValid1, out2, outValid2);

        // Scenario 1: Basic Operation with Positive Numbers
        #5 reset = 1;
        #5 en = 1; in1 = 8'd15; in2 = 8'd10; inValid = 1;
        #10;

        // Scenario 2: Operation with Negative and Positive Number
        in1 = -8'd2; in2 = 8'd5;
        #10;

        // Scenario 3: Overflow Check
        in1 = 8'd200; in2 = 8'd200;
        #10;

        // Scenario 4: Enabling and Reset Behavior
        en = 0;
        #10 reset = 0;
        #10 reset = 1; en = 1; in1 = 8'd15; in2 = 8'd15; inValid = 1;
        #13 en = 0;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule
