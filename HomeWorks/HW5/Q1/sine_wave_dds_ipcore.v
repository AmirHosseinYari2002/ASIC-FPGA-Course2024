`timescale 1ns / 1ps

module sine_wave_dds_ipcore;

    reg clk;
    wire [7:0] m_axis_data;
    wire m_axis_data_tvalid;
    wire [31:0] m_axis_phase;
    wire m_axis_phase_tvalid;

    // Instantiate the DDS module
    dds_compiler_0 uut (
        .aclk(clk),
        .m_axis_data_tdata(m_axis_data),
        .m_axis_data_tvalid(m_axis_data_tvalid),
        .m_axis_phase_tdata(m_axis_phase),
        .m_axis_phase_tvalid(m_axis_phase_tvalid)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        #10000;
        $stop;
    end
    
// Monitor the output data
always @(posedge clk) begin
    if (m_axis_data_tvalid) begin
        $display("Data: %h, Phase: %h", m_axis_data, m_axis_phase);
    end
end

endmodule
