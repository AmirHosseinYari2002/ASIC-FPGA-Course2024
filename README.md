<h1 align='center'> ASIC/FPGA Chip Design </h1>

<h2 align='center'> Sharif University of Technology </h2>

<h3 align='center'> Electrical Engineering Department </h3>

This repository contains the assignments, labratories and project that I completed for the ASIC/FPGA chip design course that I took in spring 2024.



## FPGA Signal Processing Project

The goal is to implement simple signal processing on a Zynq FPGA, specifically generating, scrambling, descrambling, and displaying the spectrum of various digital signals on an HDMI monitor.

#### Phase 1: Signal Generation and Transmission
- Generate four types of signals: sinusoidal, triangular, square, and sawtooth using the Processing System (PS) on the Zynq.
- Each signal consists of 1024 samples.
- Transfer the signals from PS to the Programmable Logic (PL) using DMA with an 8-bit port configured on HP.
- Continuously stream the signals to the FPGA via AXI Stream and perform FFT.
- Display the signal and its spectrum on an HDMI monitor, with the signal on the lower half and the spectrum on the upper half of the screen.

#### Phase 2: Scrambling and Descrambling
- Add an ASM-based Scrambler and Descrambler to the system.
- Implement a sender in PS and a receiver in PL.
- Use a frame header to indicate the start of a frame and transmit it at a fixed rate.
- Scramble the signal before transmission and descramble it upon reception.
- Use DVB-S2 Scrambling for the signal, ensuring proper synchronization and recovery on the receiver side.

#### Phase 3: MATLAB Signal Transmission
- Generate a signal in MATLAB and send it to the Zynq FPGA via UART.
- Process and display the signal similarly to the previous phases.

