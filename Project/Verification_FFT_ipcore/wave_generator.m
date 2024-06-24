clear; clc; close all;

N = 1024;  % Number of points
t = 0:N-1;  % Time vector
fs = 1;    % Sampling frequency
f0 = 0.01;  % Frequency of waves

% List of waveforms and corresponding output filenames
waveforms = {'sine', 'triangular', 'rectangular', 'sawtooth'};
output_filenames = {'sine_wave_data.txt', 'triangular_wave_data.txt', 'rectangular_wave_data.txt', 'sawtooth_wave_data.txt'};

for waveform_selection = 0:3
    % Initialize real and imaginary data based on selected waveform
    switch waveform_selection
        case 0
            % sine wave
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

    % Convert complex data to 8-bit fixed-point format
    real_data_fixed = int8(127 * real(complex_data));
    imag_data_fixed = int8(127 * imag(complex_data));

    % Prepare data in the required format (16-bit binary)
    data_out = int16(zeros(N, 1));
    for k = 1:N
        % Concatenate 8-bit signed real and imag data to form 16-bit signed data
        data_out(k) = bitshift(int16(imag_data_fixed(k)), 8) + int16(real_data_fixed(k));
    end

    % Write each 16-bit number as a binary string
    fileID = fopen(output_filenames{waveform_selection+1}, 'w');
    for k = 1:N
        bin_str = dec2bin(typecast(data_out(k), 'int16'), 16); % Convert to 16-bit binary string
        fprintf(fileID, '%s\n', bin_str);  % Write the binary string to the file
    end
    fclose(fileID);
end
