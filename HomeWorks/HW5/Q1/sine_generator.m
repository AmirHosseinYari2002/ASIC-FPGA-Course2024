% Parameters
Fs = 1000;
f = 50; 
num_samples = 50000;

% Time vector
t = (0:num_samples-1) * (1/Fs);

% Generate the sinusoidal signal
sinusoidal_signal = sin(2*pi*f*t);

% Scale the signal to fit within the range of an 8-bit signed integer
scaled_signal = sinusoidal_signal * 127;
scaled_signal = int8(scaled_signal); 

% Write the signal to a file
fileID = fopen('sinusoidal_signal.txt', 'w');
fprintf(fileID, '%d\n', scaled_signal);
fclose(fileID);
