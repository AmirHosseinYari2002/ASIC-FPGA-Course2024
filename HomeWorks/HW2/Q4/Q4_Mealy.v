module Q4_Mealy(
    input clk,
    input reset,
    input valid,
    input bit_in,
    output reg bit_out
    );

parameter S1 = 2'b01;
parameter S2 = 2'b10;

reg [1:0] state;
reg [7:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state = S1;
        shift_reg = 8'b0;
        bit_out = 1'b0;
    end else begin
        case(state)
            S1: begin
                shift_reg = {shift_reg[6:0], bit_in};
                if (shift_reg[7:0] == 8'b10110110) begin
                    bit_out = 1'b1;
                    state = S2;
                end else begin
                    bit_out = 1'b0;
                    state = S1;
                end
            end
            S2: begin
                shift_reg = {shift_reg[6:0], bit_in};
                if (shift_reg[7:0] == 8'b10110110) begin
                    bit_out = 1'b1;
                    state = S2;
                end else begin
                    bit_out = 1'b0;
                    state = S1;
                end
            end
            default: state = S1;
        endcase
    end
end

endmodule
