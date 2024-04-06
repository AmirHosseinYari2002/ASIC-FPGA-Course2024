clear; clc; close all;

% Generate random 11-bit data
data_11bit = randi([0 1], 100, 11); % Generate 100 sets of 11-bit data

% Initialize arrays to store 15-bit data with parity bits
data_15bit = zeros(100, 15);

for i = 1:100
    % Calculate parity bits (Hamming code)
    parity_bits = zeros(1, 4);
    parity_bits(1) = mod(sum(data_11bit(i, [1 2 4 5 7 9 11])), 2);
    parity_bits(2) = mod(sum(data_11bit(i, [1 3 4 6 7 10 11])), 2);
    parity_bits(3) = mod(sum(data_11bit(i, [2 3 4 8 9 10 11])), 2);
    parity_bits(4) = mod(sum(data_11bit(i, [5 6 7 8 9 10 11])), 2);

    % Insert parity bits at correct positions (1, 2, 4, and 8)
    data_15bit(i, 1) = parity_bits(1);
    data_15bit(i, 2) = parity_bits(2);
    data_15bit(i, 4) = parity_bits(3);
    data_15bit(i, 8) = parity_bits(4);

    % Fill the rest of the bits
    data_15bit(i, [3 5:7 9:15]) = data_11bit(i, :);

end

% Step 4: % Store 11-bit data in a file
fid = fopen('data_11_bit.txt', 'w');
for i = 1:100
    fprintf(fid, '%d', data_11bit(i,:));
    fprintf(fid, '\n');
end
fclose(fid);

% Store 15-bit data in a file without spaces
fid = fopen('data_15_bit.txt', 'w');
for i = 1:100
    fprintf(fid, '%d', data_15bit(i,:));
    fprintf(fid, '\n');
end
fclose(fid);
