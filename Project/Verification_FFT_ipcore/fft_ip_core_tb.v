`timescale 1ns / 1ps

module fft_ip_core_tb;

    // Clock signal
    reg aclk;
    
    // FFT IP core interface signals
    reg s_axis_config_tvalid;
    reg s_axis_data_tvalid;
    reg s_axis_data_tlast;
    reg m_axis_data_tready;
    reg [7:0] s_axis_config_tdata;
    reg [15:0] s_axis_data_tdata;
    wire s_axis_config_tready;
    wire s_axis_data_tready;
    wire m_axis_data_tvalid;
    wire m_axis_data_tlast;
    wire [15:0] m_axis_data_tdata;
    wire event_frame_started;
    wire event_tlast_unexpected;
    wire event_tlast_missing;
    wire event_status_channel_halt;
    wire event_data_in_channel_halt;
    wire event_data_out_channel_halt;
    
    // File handles for input and output
    integer wave_file, fft_file, i;
    
    // Memory to store input data
    reg [15:0] wave_data [1023:0];
    reg [15:0] input_data;

    // Instantiate the FFT IP core
    xfft_0 fft_ip_core (
        .aclk(aclk),
        .s_axis_config_tdata(s_axis_config_tdata),
        .s_axis_config_tvalid(s_axis_config_tvalid),
        .s_axis_config_tready(s_axis_config_tready),
        .s_axis_data_tdata(s_axis_data_tdata),
        .s_axis_data_tvalid(s_axis_data_tvalid),
        .s_axis_data_tready(s_axis_data_tready),
        .s_axis_data_tlast(s_axis_data_tlast),
        .m_axis_data_tdata(m_axis_data_tdata),
        .m_axis_data_tvalid(m_axis_data_tvalid),
        .m_axis_data_tready(m_axis_data_tready),
        .m_axis_data_tlast(m_axis_data_tlast),
        .event_frame_started(event_frame_started),
        .event_tlast_unexpected(event_tlast_unexpected),
        .event_tlast_missing(event_tlast_missing),
        .event_status_channel_halt(event_status_channel_halt),
        .event_data_in_channel_halt(event_data_in_channel_halt),
        .event_data_out_channel_halt(event_data_out_channel_halt)
    );

    // Clock generation (100MHz clock)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

    // Testbench initial block
    initial begin
        // Open input data file
        wave_file = $fopen("sawtooth_wave_data.txt", "r");
        if (wave_file == 0) begin
            $display("Error: Could not open file.");
            $finish;
        end
        
        // Open output data file
        fft_file = $fopen("sawtooth_fft_data.txt", "w");
        if (fft_file == 0) begin
            $display("Error: Could not open file.");
            $finish;
        end
        
        // Initialize signals
        s_axis_config_tvalid = 0;
        s_axis_data_tvalid = 0;
        s_axis_data_tlast = 0;
        m_axis_data_tready = 1;
        s_axis_config_tdata = 0;
        s_axis_data_tdata = 0;
        
        #200
        
        // Apply initial configuration values
        s_axis_data_tdata = 16'h0001;
        s_axis_config_tvalid = 1;
        s_axis_data_tvalid = 1;
        m_axis_data_tready = 1;
        s_axis_config_tdata = 1;
        
        // Read input data into memory
        for (i = 0; i < 1024; i = i + 1) begin
            $fscanf(wave_file, "%b\n", input_data);
            wave_data[i] = input_data;
        end

        // Apply configuration
        @(negedge aclk);
        s_axis_config_tvalid = 1;
        while (s_axis_config_tready == 0) begin
            s_axis_config_tvalid = 1;
        end
        @(posedge aclk);
        s_axis_config_tvalid = 0;

        // Apply input data
        for (i = 0; i < 1024; i = i + 1) begin
            s_axis_data_tlast = (i == 1022) ? 1 : 0;
            @(negedge aclk);
            s_axis_data_tdata = wave_data[i];
            s_axis_data_tvalid = 1;
            @(posedge aclk);
        end
        
        // Deassert data valid and tlast signals
        s_axis_data_tvalid = 0;
        s_axis_data_tlast = 0;
        
        // Wait for output data to be valid
        while (m_axis_data_tvalid == 0) begin
            @(posedge aclk);
        end
        
        // Capture output data
        while (m_axis_data_tvalid == 1) begin
            @(posedge aclk);
            $display("%h", m_axis_data_tdata);
            $fwrite(fft_file, "%b\n", m_axis_data_tdata);
        end

        // Close the files
        $fclose(wave_file);
        $fclose(fft_file);

        // End simulation
        $finish;
    end

endmodule
