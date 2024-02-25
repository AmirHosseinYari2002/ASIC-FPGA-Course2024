module ShiftRegister (
  input wire clk,          // Clock input
  input wire rst,          // Reset input
  input wire shift_left,   // Shift left control signal
  input wire shift_right,  // Shift right control signal
  input wire load,         // Load control signal
  input wire latch,        // Latch control signal
  input wire [7:0] data_in, // Input data
  output reg [7:0] data_out // Output data
);

  always @ (latch, data_in) begin
    if (latch) begin
        // Latch the input data if latch is active
        data_out <= data_in;
    end
  end
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset the shift register
      data_out <= 8'b0;
    end else begin
      // Shift left if shift_left is active
      if (shift_left) begin
        data_out <= data_out << 1;
      end
      // Shift right if shift_right is active
      else if (shift_right) begin
        data_out <= data_out >> 1;
      end
      // Load the input data if load is active
      else if (load) begin
        data_out <= data_in;
      end
    end
  end
endmodule
