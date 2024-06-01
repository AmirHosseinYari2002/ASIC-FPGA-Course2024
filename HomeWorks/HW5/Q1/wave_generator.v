`timescale 1ns / 1ps

module waveform_generator_tb;

    // Parameter to select the waveform
    parameter integer WAVEFORM_TYPE = 4; // 0: Sawtooth, 1: Triangular, 2: Sine DDS, 3: Sine from file, 4: Sine from task

    reg clk;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Instantiate waveform generator based on selected type
    case (WAVEFORM_TYPE)
        0: sawtooth_tb saw_gen ();
        1: triangular_tb tri_gen ();
        2: sine_wave_dds_ipcore();
        3: sine_wave_file_tb sine_file_gen ();
        4: tb_sine_wave_generator sys_sine();
    endcase

endmodule