module uart_tx(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    output reg tx_done,
    output reg tx_out
);
    parameter CLK_FREQ = 50000000;
    parameter BAUD_RATE = 115200;
    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [15:0] clk_count = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] tx_shift_reg = 0;
    reg tx_busy = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_count <= 0;
            bit_index <= 0;
            tx_shift_reg <= 0;
            tx_out <= 1;
            tx_busy <= 0;
            tx_done <= 0;
        end else if (tx_start && !tx_busy) begin
            tx_shift_reg <= {1'b1, tx_data, 1'b0};
            tx_busy <= 1;
            tx_done <= 0;
            bit_index <= 0;
            clk_count <= 0;
            tx_out <= 0;
        end else if (tx_busy) begin
            if (clk_count < BIT_PERIOD - 1) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
                bit_index <= bit_index + 1;
                if (bit_index < 10) begin
                    tx_out <= tx_shift_reg[bit_index];
                end else begin
                    tx_busy <= 0;
                    tx_done <= 1;
                    tx_out <= 1;
                end
            end
        end
    end
endmodule
