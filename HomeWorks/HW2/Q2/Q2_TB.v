`timescale 1ns / 1ps

module Q2_TB;

    integer i;
    integer file;
    reg Clk = 1;
    reg Reset;
    reg[2:0] Control;
    wire incorrectControl;
    
    reg [999:0] fileName;
    
    always @(Clk)
        Clk <= #5 ~Clk;
    
    initial begin
        $readmemb("cos.mem", uut.memIn);
        for(i = 1; i <= 4; i = i + 1) begin
            Reset = 0;
            @(posedge Clk);
            Reset = #2 1;

            Control = i;
            @(posedge Clk);
            #2;
            $sformat(fileName, "cos_result_%0d.txt", i);
            file = $fopen(fileName, "w");
            $fwrite(file, uut.memOut);
            $fclose(file);
        end
        
        $readmemb("sin.mem", uut.memIn);
        for(i = 1; i <= 4; i = i + 1) begin
            Reset = 0;
            @(posedge Clk);
            Reset = #2 1;
        
            Control = i;
            @(posedge Clk);
            #2;
            $sformat(fileName, "sin_result_%0d.txt", i);
            file = $fopen(fileName, "w");
            $fwrite(file, uut.memOut);
            $fclose(file);
        end
        
        $stop;
    end
    
    Q2 uut(
        .Clk(Clk),
        .Reset(Reset),
        .Control(Control),
        .incorrectControl(incorrectControl)
    );

endmodule
