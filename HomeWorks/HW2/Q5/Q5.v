module DataVerifier (
    input wire clk,
    input wire [14:0] data_in,
    output reg [10:0] data_out,
    output reg valid,
    output reg error
);

reg [3:0] parity_bits;
reg [10:0] data_temp;
reg valid_temp;

// Calculate parity bits
always @* begin
    parity_bits[0] = data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
    parity_bits[1] = data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[14];
    parity_bits[2] = data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14];
    parity_bits[3] = data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14];
end

// Check parity
always @* begin
    if (parity_bits == 4'b0000) begin
        // Parity is correct
        data_temp = {data_in[2], data_in[6:4], data_in[14:8]};
        valid_temp = 1;
        error = 0;
    end
    else begin
        // Parity is incorrect
        valid_temp = 0;
        error = 1;
    end
end

// Output data and valid signal with one clock delay
always @(posedge clk) begin
    if (valid_temp) begin
        data_out <= data_temp;
        valid <= 1;
    end
    else begin
        data_out <= 11'b0;
        valid <= 0;
    end
end

endmodule
