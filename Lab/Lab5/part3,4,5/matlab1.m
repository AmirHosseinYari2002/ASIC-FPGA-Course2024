%%
clear
clc
Fs = 1024;
T = 1/Fs;
L = 1024;
t = (0:L-1)*T;
freq = 2;
%% saving data
clc
y_sin = sin(2*pi*freq*t);
y_cos = cos(2*pi*freq*t);

fixpoint_array_sin = zeros([1024,16]);
fixpoint_array_cos = zeros([1024,16]);
for i = 1:1024
    fixpoint_array_sin(i,:)= fixpoint(str2double(fi(y_sin(i),1,16,14).Value));
    fixpoint_array_cos(i,:)= fixpoint(str2double(fi(y_cos(i),1,16,14).Value));
end
writeFile('sin.bin',fixpoint_array_sin);
writeFile('cos.bin',fixpoint_array_cos);
%% checking data with fft
clc
sin_out = readFile('out.txt',L);

sin_data = zeros([1,L]);

for i=1:size(sin_out,1)
   sin_data(i) = fp2dec(sin_out(i,:));
end

plot(sin_data)
%% checking data with fft
clc
sin_out = readFile('sin_out.txt',L);
cos_out = readFile('cos_out.txt',L);

sin_data = zeros([1,L]);
cos_data = zeros([1,L]);

for i=1:size(sin_out,1)
   sin_data(i) = fp2dec(sin_out(i,:));
   cos_data(i) = fp2dec(cos_out(i,:));
end

% Create a sine wave with frequency 50 Hz
x = cos_data + 1i * sin_data;
% Compute FFT
Y = fft(x);

% Compute the two-sided spectrum P2
P2 = abs(Y/L);

% Compute the single-sided spectrum P1 based on P2
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Define the frequency domain f
f = Fs*(0:(L/2))/L;

% Plot single-sided amplitude spectrum
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of Sine Wave')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
%%
% using this function for converting decimal number to fixpoint
function out = fixpoint(n)
% Split the number into integer and fractional parts
num = abs(n);
sign = n<0;
integer_part = fix(num);
fractional_part = num - integer_part;

% Convert integer part to binary representation
integer_binary_str = dec2bin(integer_part);

% Convert fractional part to binary representation
fractional_binary_str = ''; % Initialize empty string
precision = 14; % Number of bits for fractional part

for i = 1:precision
    fractional_part = fractional_part * 2;
    bit = fix(fractional_part);
    fractional_binary_str = [fractional_binary_str, num2str(bit)];
    fractional_part = fractional_part - bit;
end

% Convert binary strings to arrays of integers
integer_binary_array = double(integer_binary_str) - 48;
fractional_binary_array = double(fractional_binary_str) - 48;
out = [sign,integer_binary_array, fractional_binary_array];
end
% using this function for writing data to file
function writeFile(fileName,data)
    fileID = fopen(fileName,'w');
    for i = 1:size(data,1)
        for j = 1:size(data,2)
            fprintf(fileID,'%d',data(i,j));
        end
        fprintf(fileID,'\n');
    end
    fclose(fileID);
end
% using this function fow reading data from file
function data = readFile(fileName,data_num)
    % Open the file for reading
    fid = fopen(fileName, 'r');

    % Check if file opened successfully
    if fid == -1
        error('Could not open the file.');
    end
    num_bit = 16;
    data = zeros([data_num,num_bit]);
    % Read each line of the file
    line = fgets(fid);
    j = 1;
    while ischar(line)
        for i = 1:num_bit
            data(j,i) = str2double(line(i));
        end
        % Read the next line
        line = fgets(fid);
        j = j + 1;
    end
    fclose(fid);
end
% using this function to converting fixpoint number to decimal
function out = fp2dec(input)
    if input(1) == 1
        sign = -1;
    else 
        sign = 1;
    end
    power = 1;
    out = 0;
    for i=2:size(input,2)
        out = out + input(i) * power;
        power = power / 2;
    end
    out = sign * out;
end

