`timescale 1ns / 1ps

module Q3_TB;

    integer error_count = 0;
    integer test_index;

    reg signed[17:0] random_A_real [99:0];
    reg signed[17:0] random_A_imag [99:0];
    reg signed[17:0] random_B_real [99:0];
    reg signed[17:0] random_B_imag [99:0];
    reg signed[47:0] expected_output;

    reg clk = 1;
    reg reset;
    reg signed[17:0] A_real;
    reg signed[17:0] A_imag;
    reg signed[17:0] B_real;
    reg signed[17:0] B_imag;
    wire signed[47:0] Out_real;
    wire signed[47:0] Out_imag;

    // Clock generation
    always @(clk)
        clk <= #5 ~clk;
    
    initial begin
        $display("Starting Complex Multiplier Testbench");
        $display("--------------------------------------------------------------");

        reset = 0;
        @(posedge clk);
        reset = #2 1;

        for (test_index = 0; test_index < 100; test_index = test_index + 1) begin
            A_real = $random % (1<<17);
            A_imag = $random % (1<<17);
            B_real = $random % (1<<17);
            B_imag = $random % (1<<17);

            random_A_real[test_index] = A_real;
            random_A_imag[test_index] = A_imag;
            random_B_real[test_index] = B_real;
            random_B_imag[test_index] = B_imag;

            $display("Test %d:", test_index);
            $display("   A = (%d + %dj)", A_real, A_imag);
            $display("   B = (%d + %dj)", B_real, B_imag);

            @(posedge clk);
            #2;

            if (test_index >= 3) begin
                expected_output = random_A_real[test_index-3] * random_B_real[test_index-3] - 
                                   random_B_imag[test_index-3] * random_A_imag[test_index-3];
                if (Out_real !== expected_output) begin
                    error_count = error_count + 1;
                    $display("FAILED: Out_real = %d, Expected = %d", Out_real, expected_output);
                end

                expected_output = random_A_real[test_index-3] * random_B_imag[test_index-3] + 
                                   random_A_imag[test_index-3] * random_B_real[test_index-3];
                if (Out_imag !== expected_output) begin
                    error_count = error_count + 1;
                    $display("FAILED: Out_imag = %d, Expected = %d", Out_imag, expected_output);
                end
            end

            $display("--------------------------------------------------------------");
        end

        if (error_count != 0)
            $display("Testbench completed with %d errors.", error_count);
        else
            $display("All Tests Passed!");

        $stop;
    end

    Q3 uut(
        .Clk(clk),
        .Reset(reset),
        .A_real(A_real),
        .A_imag(A_imag),
        .B_real(B_real),
        .B_imag(B_imag),
        .Out_real(Out_real),
        .Out_imag(Out_imag)
    );

endmodule
