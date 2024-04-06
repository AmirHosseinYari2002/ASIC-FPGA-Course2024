clear; clc; close all;

% Define parameters
word_length = 16;   % Word length for fixed-point representation
frac_bits = 14;     % Number of fractional bits for fixed-point representation
sampling_freq = 1000; % Sampling frequency in Hz
num_samples = 1024; % Number of samples

% Calculate period
sampling_period = 1 / sampling_freq;

% Generate time vector
time_vector = linspace(0, sampling_period, num_samples);

% Generate sinusoidal waves
cos_wave = cos(2 * pi * sampling_freq * time_vector);
sin_wave = sin(2 * pi * sampling_freq * time_vector);

% Generate and write signals to files
generate_and_write_signal(cos_wave, 1, word_length, frac_bits, "cos.mem");
generate_and_write_signal(sin_wave, 1, word_length, frac_bits, "sin.mem");

% Function to generate and write signals to file
function generate_and_write_signal(signal, signed, word_length, frac_bits, file_name)
    % Length of the signal
    signal_length = length(signal);

    % Convert signal to fixed-point representation
    signal_fixed = fi(signal, signed, word_length, frac_bits);
    signal_fixed = signal_fixed(:); % Ensure column vector

    % Convert fixed-point signal to binary and add newline characters
    binary_data = signal_fixed.bin;
    binary_data(:, word_length + 1) = newline;

    % Reshape binary data and concatenate into a single string
    binary_data = reshape(binary_data', 1, signal_length * (word_length + 1));

    % Write binary data to file
    file_handle = fopen(file_name, 'wt');
    fwrite(file_handle, binary_data);
    fclose(file_handle);
end
