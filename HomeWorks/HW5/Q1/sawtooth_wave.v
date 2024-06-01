`timescale 1ns / 1ps

module sawtooth_tb;

  reg [7:0] sawtooth_wave;  // 8-bit input signal
  reg clk;                 // Clock signal

  // Clock period (10 ns for a 100 MHz clock)
  parameter PERIOD = 10;


  /*dut_module uut (
    .input_signal(sawtooth_wave)
  );*/

  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    sawtooth_wave = 8'b0;
    #100;
    forever begin
      #PERIOD sawtooth_wave = sawtooth_wave + 1;
      if (sawtooth_wave == 8'd30) begin
        sawtooth_wave = 0;
      end
    end
  end


  initial begin
    #90000000;
    $stop;
  end

endmodule
