module uart_test_vector_tb;
    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx_done;
    wire tx_out;
    reg rx_in;
    wire rx_done;
    wire [7:0] rx_data;

    integer test_vector_file, verilog_output_file, status;
    integer i;
    reg [7:0] data;

    uart_tx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_done(tx_done),
        .tx_out(tx_out)
    );

    uart_rx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) rx_inst (
        .clk(clk),
        .reset(reset),
        .rx_in(tx_out),
        .rx_done(rx_done),
        .rx_data(rx_data)
    );

    // Clock generation
    always begin
        #10 clk = ~clk; // 50MHz clock
    end

    initial begin
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'b0;
        rx_in = 1;

        // Open files
        test_vector_file = $fopen("test_vector.txt", "r");
        verilog_output_file = $fopen("verilog_outputs.txt", "w");

        if (test_vector_file == 0) begin
            $display("Failed to open test vector file.");
            $finish;
        end

        if (verilog_output_file == 0) begin
            $display("Failed to open output file.");
            $finish;
        end

        #100;
        reset = 0;

        for (i = 0; i < 2048; i = i + 1) begin
            // Read data from test vector file
            status = $fscanf(test_vector_file, "%b\n", data);
            if (status != 1) begin
                $display("Failed to read data from test vector file.");
                $finish;
            end

            tx_data = data;

            // Start transmission
            tx_start = 1;
            #20;
            tx_start = 0;

            wait (tx_done);
            wait (rx_done);
            #10;

            // Write received data to output file
            $fwrite(verilog_output_file, "%b\n", rx_data);
        end

        $fclose(test_vector_file);
        $fclose(verilog_output_file);

        #100;
        $stop;
    end
endmodule
