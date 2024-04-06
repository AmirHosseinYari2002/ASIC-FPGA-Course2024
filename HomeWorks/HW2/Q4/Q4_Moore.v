module Q4_Moore(
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
        state <= S1;
        shift_reg <= 8'b0;
    end else begin
        case(state)
            S1: begin
                if (valid) begin
                    shift_reg <= {shift_reg[6:0], bit_in};
                    if (shift_reg[7:0] == 8'b10110110) begin
                        state <= S2;
                    end else begin
                        state <= S1;
                    end
                end
            end
            S2: begin
                if (valid) begin
                    shift_reg <= {shift_reg[6:0], bit_in};
                    if (shift_reg[7:0] == 8'b10110110) begin
                        state <= S2;
                    end else begin
                        state <= S1;
                    end
                end
            end
            default: state <= S1;
        endcase
    end
end

always @(*) begin
    case(state)
        S1: bit_out = 1'b0;
        S2: bit_out = 1'b1;
        default: bit_out = 1'b0;
    endcase
end

endmodule
