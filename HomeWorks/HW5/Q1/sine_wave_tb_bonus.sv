module tb_sine_wave_generator;

    logic clk;
    logic rst_n;
    logic [15:0] sine_wave;
    integer file;

    // Instantiate the sine wave generator
    sine_wave_generator #(
        .LUT_SIZE(256)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .sine_wave(sine_wave)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        #20 rst_n = 1;
    end

    initial begin
        file = $fopen("sine_wave_output.txt", "w");
        if (file == 0) begin
            $display("Failed to open file for writing");
            $finish;
        end
    end

    // Write the sine wave output to the file
    always_ff @(posedge clk) begin
        if (rst_n) begin
            $fdisplay(file, "%0d", sine_wave);
        end
    end

    initial begin
        #5000;
        $fclose(file);
        $stop;
    end

endmodule
