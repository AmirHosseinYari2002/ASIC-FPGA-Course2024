module Timer(
    input wire clk,      // 50 MHz clock input
    input wire rst_n,    // Active-low synchronous reset
    input wire [5:0] min, // 6-bit input for minutes (0-59)
    input wire [5:0] sec, // 6-bit input for seconds (0-59)
    output reg done      // Output signal indicating timer completion
);

reg [5:0] counter_min; // Counter for minutes
reg [5:0] counter_sec; // Counter for seconds
reg [24:0] clock_counter; // Counter for clock cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset on active-low reset signal
        counter_min <= min;
        counter_sec <= sec;
        clock_counter <= 0;
        done <= 1'b0;
    end else begin
        // Increment clock counter on each clock cycle
        clock_counter <= clock_counter + 1;

        // Check if one second has elapsed
        if (clock_counter == 50000000) begin
            // Reset clock counter
            clock_counter <= 0;

            // Count down
            if ((6'b0 == counter_min) && (6'b0 == counter_sec)) begin
                // If target time is reached, set done signal
                done <= 1'b1;
            end else if (counter_sec == 6'b0) begin
                // Decrement minute counter when seconds reach 0
                counter_min <= counter_min - 1;
                counter_sec <= 59;
            end else begin
                // Decrement second counter
                counter_sec <= counter_sec - 1;
            end
        end
    end
end

endmodule
