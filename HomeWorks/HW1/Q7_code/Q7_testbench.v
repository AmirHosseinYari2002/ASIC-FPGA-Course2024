module ShiftRegister_tb;
  reg clk, rst, shift_left, shift_right, load, latch;
  reg [7:0] data_in;
  wire [7:0] data_out;

  // Instantiate the shift register
  ShiftRegister dut (
    .clk(clk),
    .rst(rst),
    .shift_left(shift_left),
    .shift_right(shift_right),
    .load(load),
    .latch(latch),
    .data_in(data_in),
    .data_out(data_out)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test scenario
  initial begin
    clk = 0;
    rst = 1;
    shift_left = 0;
    shift_right = 0;
    load = 0;
    latch = 0;
    data_in = 8'b10101010;

    // Release reset
    #10 rst = 0;

    // Load data
    #10 load = 1;
    #10 load = 0;
    $display("After loading: data_out = %b", dut.data_out);

    // Shift left
    #10 shift_left = 1;
    #10 shift_left = 0;
    $display("After shifting left: data_out = %b", dut.data_out);

    // Shift right
    #10 shift_right = 1;
    #10 shift_right = 0;
    $display("After shifting right: data_out = %b", dut.data_out);

    // Latch data
    #10 latch = 1;
    #10 latch = 0;
    $display("After latching: data_out = %b", dut.data_out);

    // End simulation
    #10 $stop;
  end
endmodule
