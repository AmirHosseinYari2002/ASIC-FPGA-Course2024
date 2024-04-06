clear; clc; close all;

% Call the function with the desired number of harmonics
showFourier(4);

function showFourier(numHarmonics)
    % Read fixed-point data for cosine and sine components
    cosData = readFixedPointData('cos_result_' + string(numHarmonics) + '.txt');
    sinData = readFixedPointData('sin_result_' + string(numHarmonics) + '.txt');

    % Signal parameters
    frequency = 1e3;
    period = 1 / frequency;
    samplingPeriod = period / 1024;
    samplingFrequency = 1 / samplingPeriod;

    % Time vector
    t = linspace(0, period, 1024);

    % Generate reference complex sinusoidal signal
    referenceSignal = cos(2*pi*frequency*t) + 1i * sin(2*pi*frequency*t);

    % Convert fixed-point data to double and combine real and imaginary parts
    receivedSignal = double(cosData) + 1i * double(sinData);

    % Perform FFT on received signal
    fftSignal = fft(receivedSignal) * samplingPeriod;
    fftSignal = fftshift(fftSignal);
    fftSignal = abs(fftSignal);

    % Frequency vector
    N = 1024;
    f = (-N/2 : N/2-1) * (samplingFrequency/N);

    % Perform FFT on reference signal
    fftReference = fft(referenceSignal) * samplingPeriod;
    fftReference = fftshift(fftReference);
    fftReference = abs(fftReference);

    % Plotting
    figure;

    % Fourier transform plot
    subplot(3, 1, 1);
    plot(f, fftReference, 'm', f, fftSignal, 'c');
    xlim([-1e4, 1e4]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    title('Fourier Transform Comparison');
    legend('Reference', 'Received');
    grid on;

    % Cosine component plot
    subplot(3, 1, 2);
    plot(t, cos(2*pi*frequency*t), 'm', t, cosData, 'c');
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Cosine Component Comparison');
    legend('Reference', 'Received');
    grid on;

    % Sine component plot
    subplot(3, 1, 3);
    plot(t, sin(2*pi*frequency*t), 'm', t, sinData, 'c');
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Sine Component Comparison');
    legend('Reference', 'Received');
    grid on;

end

function fixedPointData = readFixedPointData(fileName)
    % Read fixed-point data from file
    fid = fopen(fileName,'rt');
    Fline = fgetl(fid);
    len = length(Fline);

    % Convert data to uint16 and reinterpret as fixed-point
    data = str2num(['[' (Fline(3:len-1)) ']']);
    rawData = uint16(data);
    fixedPointData = reinterpretcast(rawData, numerictype(1, 16, 14));
    
    fclose(fid);
end
