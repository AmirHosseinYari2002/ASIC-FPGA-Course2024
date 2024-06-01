module uart_rx(
    input wire clk,
    input wire reset,
    input wire rx_in,
    output reg rx_done,
    output reg [7:0] rx_data
);
    parameter CLK_FREQ = 50000000; 
    parameter BAUD_RATE = 115200;  
    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [15:0] clk_count = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] rx_shift_reg = 0;
    reg rx_busy = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_count <= 0;
            bit_index <= 0;
            rx_shift_reg <= 0;
            rx_busy <= 0;
            rx_done <= 0;
        end else if (!rx_busy && !rx_in) begin
            rx_busy <= 1;
            clk_count <= 0;
            bit_index <= 0;
        end else if (rx_busy) begin
            if (clk_count < BIT_PERIOD - 1) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
                bit_index <= bit_index + 1;
                if (bit_index < 10) begin
                    rx_shift_reg[bit_index] <= rx_in;
                end else begin
                    rx_busy <= 0;
                    rx_done <= 1;
                    rx_data <= rx_shift_reg[8:1];
                end
            end
        end else begin
            rx_done <= 0;
        end
    end
endmodule
