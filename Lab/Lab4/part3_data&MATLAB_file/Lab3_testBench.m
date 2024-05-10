%% state 00 (0)
clear
clc
random_numbers = randi([-16000, 16000], 1, 10);
state00_input = dec2bin(random_numbers,16);
squares = random_numbers.^2;
output = zeros([1,5]);
output_bin = [];
for j = 1:2:10
    output((j+1)/2) = round(sqrt(squares(j) + squares(j + 1)));
    output_bin = [output_bin ; dec2bin(output((j+1)/2),17)];
end
fileID_input = fopen('state00_inputs.txt', 'w');
for i = 1:size(state00_input,1)
    for j = 1:size(state00_input,2)
        fprintf(fileID_input , '%s', state00_input(i,j));
    end
    fprintf(fileID_input , '\n');
end
fclose(fileID_input);

fileID_output = fopen('state00_outputs.txt', 'w');
for i = 1:size(output_bin,1)
    for j = 1:size(output_bin,2)
        fprintf(fileID_output , '%s', output_bin(i,j));
    end
    fprintf(fileID_output , '\n');
end
fclose(fileID_output);
%% state 01 (1)
clc
clear
random_numbers = randi([-60, 60], 1, 16);
state01_input = [];
for j = 1:2:16
    state01_input = [state01_input;[dec2bin(random_numbers(j),8),dec2bin(random_numbers(j + 1),8)]];
end
results = [];
for j = 1:4:16
    results = [results ; (random_numbers(j) + random_numbers(j + 1) * 1i)*(random_numbers(j + 2) + random_numbers(j + 3) * 1i)]; 
end
results_bin = [];
for i = 1:16/4
   results_bin = [results_bin ; [dec2bin(real(results(i)),17),dec2bin(imag(results(i)),17)]];
end

fileID_input = fopen('state01_inputs.txt', 'w');
for i = 1:size(state01_input,1)
    for j = 1:size(state01_input,2)
        fprintf(fileID_input , '%s', state01_input(i,j));
    end
    fprintf(fileID_input , '\n');
end
fclose(fileID_input);

fileID_output = fopen('state01_outputs.txt', 'w');
for i = 1:size(results_bin,1)
    for j = 1:size(results_bin,2)
        fprintf(fileID_output , '%s', results_bin(i,j));
    end
    fprintf(fileID_output , '\n');
end
fclose(fileID_output);

%% state 10 (2)
clear
clc
random_numbers = randi([-16000, 16000], 1, 18);
state10_input = dec2bin(random_numbers,16);
output = zeros([1,3]);
output_bin = [];
for j = 1:6:18
    a1 = [random_numbers(j),random_numbers(j + 1),random_numbers(j + 2)];
    a2 = [random_numbers(j + 3);random_numbers(j + 4);random_numbers(j + 5)];
    output((j+5)/6) = a1 * a2;
    output_bin = [output_bin ; dec2bin(output((j+5)/6),35)];
end
fileID_input = fopen('state10_inputs.txt', 'w');
for i = 1:size(state10_input,1)
    for j = 1:size(state10_input,2)
        fprintf(fileID_input , '%s', state10_input(i,j));
    end
    fprintf(fileID_input , '\n');
end
fclose(fileID_input);

fileID_output = fopen('state10_outputs.txt', 'w');
for i = 1:size(output_bin,1)
    for j = 1:size(output_bin,2)
        fprintf(fileID_output , '%s', output_bin(i,j));
    end
    fprintf(fileID_output , '\n');
end
fclose(fileID_output);
%% state 11 (3)
clear
clc
random_numbers = randi([-50, 50], 1, 36);
state11_input = [];
for j = 1:2:36
    state11_input = [state11_input;[dec2bin(random_numbers(j),8),dec2bin(random_numbers(j + 1),8)]];
end
A = zeros(3);
B = zeros(3);
j = 1;
for i = 1:2:size(random_numbers,2)
    if j < 10
        A(j) = random_numbers(i) + random_numbers(i + 1) * 1i;
    else
        B(j-9) = random_numbers(i) + random_numbers(i + 1) * 1i;
    end
    j = j + 1;
end
A = A.';
B = B.';
C = A * B;
C = C.';
results_bin = [];
for i = 1:9
    results_bin = [results_bin;dec2bin(real(C(i)),19),dec2bin(imag(C(i)),19)];
end
fileID_input = fopen('state11_inputs.txt', 'w');
for i = 1:size(state11_input,1)
    for j = 1:size(state11_input,2)
        fprintf(fileID_input , '%s', state11_input(i,j));
    end
    fprintf(fileID_input , '\n');
end
fclose(fileID_input);

fileID_output = fopen('state11_outputs.txt', 'w');
for i = 1:size(results_bin,1)
    for j = 1:size(results_bin,2)
        fprintf(fileID_output , '%s', results_bin(i,j));
    end
    fprintf(fileID_output , '\n');
end
fclose(fileID_output);
