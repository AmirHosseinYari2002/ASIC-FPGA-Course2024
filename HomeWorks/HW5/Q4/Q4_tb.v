module PacketChecker_tb;

    reg clk;
    reg rst;
    reg [31:0] data_in;
    wire [7:0] ram_address;
    wire [15:0] ram_data;
    wire ram_en;
    wire error;

    PacketChecker uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .ram_address(ram_address),
        .ram_data(ram_data),
        .ram_en(ram_en),
        .error(error)
    );

    // File handlers
    integer address_file, data_file, error_file;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period clock
    end


    initial begin
        // Open files for writing
        address_file = $fopen("address.txt", "w");
        data_file = $fopen("data.txt", "w");
        error_file = $fopen("error.txt", "w");

        rst = 1;
        data_in = 32'b0;
        #20; 
        rst = 0;
        #20;

        // Test case 1: Valid header 0xE
        data_in = 32'h123_4567E;
        #20;
        if (ram_en) begin
            $fwrite(address_file, "%h\n", ram_address);
            $fwrite(data_file, "%h\n", ram_data);
        end
        $fwrite(error_file, "%b\n", error);

        // Test case 2: Invalid header
        data_in = 32'h123_4567F;
        #20;
        if (ram_en) begin
            $fwrite(address_file, "%h\n", ram_address);
            $fwrite(data_file, "%h\n", ram_data);
        end
        $fwrite(error_file, "%b\n", error);

        // Test case 3: Another valid header
        data_in = 32'hABC_DEF0E;
        #20;
        if (ram_en) begin
            $fwrite(address_file, "%h\n", ram_address);
            $fwrite(data_file, "%h\n", ram_data);
        end
        $fwrite(error_file, "%b\n", error);

        // Test case 4: Another invalid header
        data_in = 32'h123_4567A;
        #20;
        if (ram_en) begin
            $fwrite(address_file, "%h\n", ram_address);
            $fwrite(data_file, "%h\n", ram_data);
        end
        $fwrite(error_file, "%b\n", error);

        // Close files
        $fclose(address_file);
        $fclose(data_file);
        $fclose(error_file);

        // Finish simulation
        $stop;
    end
endmodule
