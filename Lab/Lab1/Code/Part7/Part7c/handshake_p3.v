module handshake_p3(input clock, reset,
					input [3:0] ps2_data, input ps2_en,
					output reg [3:0] sound_code,	// Code for the music box
					input data_rq,		// Data request from music box
					output reg data_rd);		// Data ready for music box

    localparam IDLE = 2'b00,
                WAIT_FOR_DATA = 2'b01,
                DATA_READY = 2'b10;

    reg [3:0] data;
    reg [1:0] state = IDLE;

    always @(posedge clock) begin
        if (reset) begin
            data <= 4'b0000;
            state <= IDLE;
            sound_code <= 4'b0000;
            data_rd <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    state <= data_rq ? WAIT_FOR_DATA : IDLE;
						  sound_code <= 4'b0000;
						  data_rd <= 1'b0;
                end

                WAIT_FOR_DATA: begin
                    if (ps2_en) begin
                        data <= ps2_data;
                        state <= DATA_READY;
                    end else begin
                        state <= WAIT_FOR_DATA;
                    end
                end

                DATA_READY: begin
                    sound_code <= data;
                    data_rd <= 1'b1;
                    state <= data_rq ? DATA_READY : IDLE;
                end
            endcase
        end
    end

endmodule

