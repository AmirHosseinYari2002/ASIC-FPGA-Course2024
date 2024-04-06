module handshake_p1(input clock, reset,
					input [3:0] ps2_data, input ts,
					output reg [3:0] leds);

reg [3:0] data_register;

// Register to capture the 4-bit data from the PS/2 Controller
always @(posedge clock) begin
    if (reset) begin
        // Reset the register on the falling edge of the reset signal
        data_register <= 4'b0000;
    end else if (ts) begin
        // Capture the 4-bit data on the positive edge of tx_start signal
        data_register <= ps2_data;
    end
end

// Display the captured data on the LEDs
always @* begin
    leds = data_register;
end

endmodule
