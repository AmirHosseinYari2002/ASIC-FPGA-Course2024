module sine_wave_generator #
(
    parameter integer LUT_SIZE = 256,
    parameter real    PI = 3.14159265358979323846
)
(
    input logic clk,
    input logic rst_n,
    output logic [15:0] sine_wave
);

    // Lookup Table to store sine values
    logic [15:0] sine_lut[LUT_SIZE-1:0];
    initial begin
        for (int i = 0; i < LUT_SIZE; i++) begin
            sine_lut[i] = $rtoi(32767 * $sin(2 * PI * i / LUT_SIZE));
        end
    end

    // Counter for LUT index
    logic [$clog2(LUT_SIZE)-1:0] lut_index;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lut_index <= 0;
        else
            lut_index <= lut_index + 1;
    end

    // Output the sine value from LUT
    assign sine_wave = sine_lut[lut_index];

endmodule
