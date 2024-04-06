`timescale 1ns / 1ps

module DataVerifier_TB;

reg clk;
reg [14:0] data_in;
wire [10:0] data_out;
wire valid;
wire error;

DataVerifier dut (
    .clk(clk),
    .data_in(data_in),
    .data_out(data_out),
    .valid(valid),
    .error(error)
);

integer file;
integer data_value;
integer counter; 

// Clock generation
always #5 clk = ~clk;

initial begin
    // Initialize clock
    clk = 0;

    // Open input file
    file = $fopen("E:\\University\\Semester 8\\FPGA\\HomeWorks\\HW2\\Q5\\data_15_bit.txt", "r");
    if (file == 0) begin
        $display("Error opening file");
        $stop;
    end else begin
        $display("File opened successfully");
    end

    // Read and display file line by line
    while (!$feof(file)) begin
        // Read data from file
        $fscanf(file, "%b", data_value);
        data_in = {data_value[0], data_value[1], data_value[2], data_value[3], data_value[4], data_value[5], data_value[6], data_value[7], data_value[8], data_value[9], data_value[10], data_value[11], data_value[12], data_value[13], data_value[14]};

        #15;

        // Print data_out and valid
        $display("data_in: %b, data_out: %b, valid: %b", dut.data_in, data_out, valid);

        #10;
    end

    // Close input file
    $fclose(file);
    $stop;
end

endmodule
