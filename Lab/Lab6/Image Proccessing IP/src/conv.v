`timescale 1ns / 1ps

module conv (
    input                    i_clk,
    input [71:0]             i_pixel_data,
    input                    i_pixel_data_valid,
    output reg [7:0]         o_convolved_data,
    output reg               o_convolved_data_valid
);

// Gx kernel
// 1 0 -1
// 2 0 -2
// 1 0 -1

// Gy kernel
//  1  2  1
//  0  0  0
// -1 -2 -1

wire signed [10:0] Gx;
wire signed [10:0] Gy;

assign Gx = i_pixel_data[7:0] - i_pixel_data[23:16]
          +(i_pixel_data[31:24] << 1) - (i_pixel_data[47:40] << 1)
          + i_pixel_data[55:48] - i_pixel_data[71:64];

assign Gy =  i_pixel_data[7:0] + (i_pixel_data[15:8] << 1) + i_pixel_data[23:16]
          - i_pixel_data[55:48] - (i_pixel_data[63:56] << 1) - i_pixel_data[71:63];

wire signed [10:0] abs_Gx = Gx[10] ? -Gx : Gx;
wire signed [10:0] abs_Gy = Gy[10] ? -Gy : Gy;
wire signed [21:0] gradient_magnitude = abs_Gx * abs_Gx + abs_Gy * abs_Gy;

always @(posedge i_clk) begin
    if (i_pixel_data_valid) begin
        o_convolved_data <= (gradient_magnitude < 'd16000) ? 8'd0 : 8'hFF;
        o_convolved_data_valid <= 1;
    end else begin
        o_convolved_data_valid <= 0;
    end
end

endmodule
