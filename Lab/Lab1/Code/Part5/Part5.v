module Part5 (SW, KEY, LEDG, LEDR);
  input [1:0] SW;
  input [0:0] KEY;
  output [0:0] LEDG;
  output [8:0] LEDR;

  wire Clock, Resetn, w, z;
  wire [8:0] next_y;

  assign Clock = KEY[0];
  assign Resetn = ~SW[0]; // Active low reset
  assign w = SW[1];

  // Define one-hot encoded states using individual flip-flops
  reg [8:0] y8, y7, y6, y5, y4, y3, y2, y1, y0; // State flip-flops

  // Next-state logic using simple assign statements
  always @(posedge Clock or negedge Resetn) begin
    if (~Resetn) begin
      y8 <= 1'b0;
      y7 <= 1'b0;
      y6 <= 1'b0;
      y5 <= 1'b0;
      y4 <= 1'b0;
      y3 <= 1'b0;
      y2 <= 1'b0;
      y1 <= 1'b0;
      y0 <= 1'b1; // Initial state A
    end
    else begin
      y8 <= next_y[8];
      y7 <= next_y[7];
      y6 <= next_y[6];
      y5 <= next_y[5];
      y4 <= next_y[4];
      y3 <= next_y[3];
      y2 <= next_y[2];
      y1 <= next_y[1];
      y0 <= next_y[0];
    end
  end

  assign next_y = (y0 & w) ? 9'b000100000 :
                (y0 & ~w) ? 9'b000000010 :
                (y1 & w) ? 9'b000100000 :
                (y1 & ~w) ? 9'b000000100 :
                (y2 & w) ? 9'b000100000 :
                (y2 & ~w) ? 9'b000001000 :
                (y3 & w) ? 9'b000100000 :
                (y3 & ~w) ? 9'b000010000 :
                (y4 & w) ? 9'b000100000 :
                (y4 & ~w) ? 9'b000010000 :
                (y5 & w) ? 9'b001000000 :
                (y5 & ~w) ? 9'b000000010 :
                (y6 & w) ? 9'b010000000 :
                (y6 & ~w) ? 9'b000000010 :
                (y7 & w) ? 9'b100000000 :
                (y7 & ~w) ? 9'b000000010 :
                (y8 & w) ? 9'b100000000 :
                (y8 & ~w) ? 9'b000000010 :
                            9'b000000001; // Default to state A for any undefined state


  // Output assignments
  assign z = y8 | y4; // z is 1 when in state I or E
  assign LEDR[8:0] = {y8, y7, y6, y5, y4, y3, y2, y1, y0};
  assign LEDG[0] = z;

endmodule
