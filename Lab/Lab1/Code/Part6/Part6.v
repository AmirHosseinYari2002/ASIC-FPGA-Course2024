module Part6 (SW, KEY, LEDG, LEDR);
  input [2:0] SW;
  input [0:0] KEY;
  output [0:0] LEDG;
  output reg [3:0] LEDR;

  wire Clock, Resetn, w, wait_done;
  reg z;

  assign Clock = KEY[0];
  assign Resetn = SW[0];
  assign w = SW[1];
  assign wait_done = SW[2];
  parameter A = 4'b0000;
  parameter B = 4'b0001;
  parameter C = 4'b0010;
  parameter D = 4'b0011;
  parameter E = 4'b0100;
  parameter F = 4'b0101;
  parameter G = 4'b0110;
  parameter H = 4'b0111;
  parameter I = 4'b1000;
  parameter Wait = 4'b1001;

  reg [3:0] y; // State register

  always @(posedge Clock) begin
    if (~Resetn) begin
      y <= A; // Initial state A
    end
    else begin
      case (y)
        A: y <= (w) ? F : B; // State A transition
        B: y <= (w) ? F : C; // State B transition
        C: y <= (w) ? F : D; // State C transition
        D: y <= (w) ? F : E; // State D transition
		  E: y <= (wait_done) ? Wait : ((w) ? F : E); // State E transition
        F: y <= (w) ? G : B; // State F transition
        G: y <= (w) ? H : B; // State G transition
        H: y <= (w) ? I : B; // State H transition
		  I: y <= (wait_done) ? Wait : ((w) ? I : B); // State I transition
		  Wait: y <= (wait_done) ? Wait : A;
        default: y <= A; // Default to state A for any undefined state
      endcase
    end
  end

  always @(posedge Clock) begin
    if (~Resetn) begin
      LEDR <= A; // Initial state A
    end
    else begin
      LEDR <= y;
    end
  end

  always @(posedge Clock) begin
    if (~Resetn) begin
      z <= 1'b0; // Initial state A
    end
    else begin
      z <= (y == E || y== I || y == Wait) ? 1'b1 : 1'b0; // Output z logic for State Wait
    end
  end

  // Output assignments
  assign LEDG[0] = z;

endmodule
