`timescale 1ns / 1ps

module sine_wave_file_tb;

  reg clk;               
  reg [7:0] file_data;   
  reg file_eof;          
  reg [31:0] file_count; 
  reg [7:0] sine_wave;   
  
  // Clock period (10 ns for a 100 MHz clock)
  parameter PERIOD = 10;

  // File declaration
  reg [31:0] file_handle;

  initial begin
    file_handle = $fopen("sinusoidal_signal.txt", "r");
    if (file_handle == 0) begin
      $display("Error: Unable to open file.");
      $stop;
    end
    file_count = 0;
  end

  // Clock generation
  initial begin
    clk = 0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  always @(posedge clk) begin
    if (!$feof(file_handle)) begin
      $fscanf(file_handle, "%d", file_data);
      file_eof = 0;
    end else begin
      file_eof = 1;
    end
    file_count = file_count + 1;
  end

  always @(*) begin
    sine_wave = file_data;
  end

  always @(posedge clk) begin
    if (file_eof) begin
      $display("End of file reached. Total samples read: %d", file_count);
      $fclose(file_handle);
      $stop;
    end else begin
      $display("Sample %d: %h", file_count, sine_wave);
    end
  end

endmodule