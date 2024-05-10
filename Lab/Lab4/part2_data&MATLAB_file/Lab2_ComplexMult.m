%%
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
fileID_input = fopen('inputs.txt', 'w');
for i = 1:size(state01_input,1)
    for j = 1:size(state01_input,2)
        fprintf(fileID_input , '%s', state01_input(i,j));
    end
    fprintf(fileID_input , '\n');
end
fclose(fileID_input);
fileID_output = fopen('outputs.txt', 'w');
for i = 1:size(results_bin,1)
    for j = 1:size(results_bin,2)
        fprintf(fileID_output , '%s', results_bin(i,j));
    end
    fprintf(fileID_output , '\n');
end
fclose(fileID_output);


