`timescale 1ns / 1ps

module sine_wave_dds_tb();

  reg clk;             // Clock signal
  reg [7:0] phase_acc; // Phase accumulator
  wire [7:0] sine_wave; // Output sine wave

  // Clock period (10 ns for a 100 MHz clock)
  parameter PERIOD = 10;
  parameter PHASE_INC = 8'd5;

  reg [7:0] sine_lut [0:255];
  integer i;

 initial begin
    // Initialize sine lookup table with scaled values
    for (i = 0; i < 256; i = i + 1) begin
      sine_lut[i] = 127 * $sin(2 * 3.141592653589793 * i / 256);
    end
  end

  // Clock generation
  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  // Phase accumulator and sine wave generation
  always @(posedge clk) begin
    phase_acc <= phase_acc + PHASE_INC;
  end

  assign sine_wave = sine_lut[phase_acc];

  initial begin
    phase_acc = 0;
    #90000000;
    $stop;
  end

endmodule
