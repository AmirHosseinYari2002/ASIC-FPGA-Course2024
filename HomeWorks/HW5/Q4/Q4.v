module PacketChecker(
    input wire clk,         // Clock signal
    input wire rst,         // Reset signal
    input wire [31:0] data_in,  // 32-bit input data
    output reg [7:0] ram_address,  // 8-bit RAM address output
    output reg [15:0] ram_data,    // 16-bit RAM data output
    output reg ram_en,         // RAM enable signal
    output reg error           // Error signal
);

reg [3:0] header;
reg [7:0] address;
reg [15:0] data;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ram_address <= 8'b0;
        ram_data <= 16'b0;
        ram_en <= 0;
        error <= 0;
    end else begin
        ram_en <= 0;
        error <= 0;
        header = data_in[3:0];
        address = data_in[11:4];
        data = data_in[27:12];

        if (header == 4'hE) begin
            ram_address <= address;
            ram_data <= data;
            ram_en <= 1;
        end else begin
            error <= 1;
        end
    end
end

endmodule
