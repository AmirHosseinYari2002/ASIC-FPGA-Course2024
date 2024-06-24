clear; clc; close all;

% Parameters
N = 1024;  % Number of points
t = 0:N-1;  % Time vector
fs = 1;    % Sampling frequency
f0 = 0.01;  % Frequency of waves
freq = linspace(-fs/2, fs/2 - fs/N, N);  % Frequency

% List of waveforms and corresponding filenames
waveforms = {'sine', 'triangular', 'rectangular', 'sawtooth'};
fft_filenames = {'sine_fft_data.txt', 'triangular_fft_data.txt', 'rectangular_fft_data.txt', 'sawtooth_fft_data.txt'};

% Loop through all waveforms
for waveform_selection = 0:3
    % Initialize real and imaginary data based on selected waveform
    switch waveform_selection
        case 0
            % Sine wave
            imag_data = sin(2*pi*f0*t);
            real_data = cos(2*pi*f0*t);
        case 1
            % Triangular wave
            imag_data = zeros(1, N);
            real_data = sawtooth(2*pi*f0*t, 0.5);  % Triangular wave
        case 2
            % Rectangular wave
            imag_data = zeros(1, N);
            real_data = square(2*pi*f0*t);  % Rectangular wave
        case 3
            % Sawtooth wave
            imag_data = zeros(1, N);
            real_data = sawtooth(2*pi*f0*t);  % Sawtooth wave
        otherwise
            error('Invalid selection');
    end

    % Combine real and imaginary parts to form complex data
    complex_data = real_data + 1i * imag_data;

    % Read FFT output data from file
    if exist(fft_filenames{waveform_selection+1}, 'file')
        fileID = fopen(fft_filenames{waveform_selection+1}, 'r');
        fft_data_bin = textscan(fileID, '%s');
        fclose(fileID);

        fft_data_bin = fft_data_bin{1};
        verilog_fft_data = zeros(N, 1);

        % Convert binary strings to signed integers
        for k = 1:N
            bin_str = fft_data_bin{k};

            % Convert real part (first 8 bits)
            real_bin_str = bin_str(1:8);
            if real_bin_str(1) == '1'  % If MSB is 1, it's a negative number
                real_part = bin2dec(real_bin_str) - 256; % Convert to signed integer
            else
                real_part = bin2dec(real_bin_str);
            end

            % Convert imaginary part (last 8 bits)
            imag_bin_str = bin_str(9:16);
            if imag_bin_str(1) == '1'  % If MSB is 1, it's a negative number
                imag_part = bin2dec(imag_bin_str) - 256; % Convert to signed integer
            else
                imag_part = bin2dec(imag_bin_str);
            end

            verilog_fft_data(k) = real_part + 1i * imag_part;
        end

        % Plot both MATLAB and Verilog FFT results
        figure;

        subplot(3, 1, 1);
        plot(t, complex_data, 'm' ,'LineWidth', 2);
        title([waveforms{waveform_selection+1}, ' Waveform']);
        xlabel('Time');
        ylabel('Amplitude');

        subplot(3, 1, 2);
        plot(freq, abs(fftshift(fft(complex_data))), 'c', 'LineWidth', 2);
        title('MATLAB FFT');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        subplot(3, 1, 3);
        plot(freq, abs(fftshift(verilog_fft_data)), 'g', 'LineWidth', 2);
        title('Verilog FFT');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');

        sgtitle(['Comparison of ', waveforms{waveform_selection+1}, ' Waveform FFT Results']);
    end
end
