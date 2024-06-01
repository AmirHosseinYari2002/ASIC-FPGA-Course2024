module uart_tb;
    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx_done;
    wire tx_out;
    reg rx_in;
    wire rx_done;
    wire [7:0] rx_data;

    uart_tx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(115200)
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
        .BAUD_RATE(115200)
    ) rx_inst (
        .clk(clk),
        .reset(reset),
        .rx_in(tx_out),
        .rx_done(rx_done),
        .rx_data(rx_data)
    );

    // Clock generation
    always begin
        #10 clk = ~clk;
    end

    initial begin
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'b0;
        rx_in = 1;

        #20;
        reset = 0;

        // Transmit a byte
        #20;
        tx_data = 8'b10101010;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait (tx_done);
        wait (rx_done);

        if (rx_data == 8'b10101010) begin
            $display("Test Passed: Received data = %b", rx_data);
        end else begin
            $display("Test Failed: Received data = %b", rx_data);
        end

        #100;
        $stop;
    end
endmodule
