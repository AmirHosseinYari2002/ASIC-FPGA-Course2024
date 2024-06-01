`timescale 1ns / 1ps

module triangular_tb;

  reg [7:0] tri_wave;  // 8-bit input signal
  reg clk;             // Clock signal
  reg up;              // Direction flag

  // Clock period (10 ns for a 100 MHz clock)
  parameter PERIOD = 10;

  /*dut_module uut (
    .input_signal(tri_wave)
  );*/

  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    tri_wave = 8'b0;
    up = 1'b1;
    forever begin
      #PERIOD
      if (up) begin
        tri_wave = tri_wave + 1;
        if (tri_wave == 8'd15) begin
          up = 1'b0;
        end
      end else begin
        tri_wave = tri_wave - 1;
        if (tri_wave == 8'd0) begin
          up = 1'b1;
        end
      end
    end
  end

  initial begin
    #90000000;
    $stop;
  end

endmodule
