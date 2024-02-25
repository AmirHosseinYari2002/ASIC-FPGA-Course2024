`timescale 1ns / 1ps

module Timer_tb;

  reg clk;
  reg rst_n;
  reg [5:0] min;
  reg [5:0] sec;
  wire done;

  // Instantiate the Timer module
  Timer timer_inst (
    .clk(clk),
    .rst_n(rst_n),
    .min(min),
    .sec(sec),
    .done(done)
  );

  // Clock generation
  always #10 clk = ~clk;

  // Counter for seconds
  reg [23:0] sec_counter;
  
  // Initial values
  initial begin
    clk = 0;
    rst_n = 1;
    min = 6'd1; // Initial value for minutes
    sec = 6'd30; // Initial value for seconds
    sec_counter = 0;

    // Apply reset
    #10 rst_n = 0;
    #10 rst_n = 1;

    // Monitor 'done' signal and finish simulation when it becomes 1
    wait(done == 1);
    $stop;
  end

  // Display signals every 1 second
  always @(posedge clk) begin
    sec_counter <= sec_counter + 1;

    if (sec_counter == 50000000) begin
      $display("Time: %02d:%02d", timer_inst.counter_min, timer_inst.counter_sec);
      sec_counter <= 0;
    end
  end

endmodule
