module ALU(
    input clk,
    input [31:0] a_operand,
    input [31:0] b_operand,
    input [3:0] Operation,
    output reg [31:0] ALU_Output,
    output reg Exception,
    output reg Overflow,
    output reg Underflow
);

reg [31:0] Add_Sub_Output_reg, Mul_Output_reg;
reg Add_Sub_Exception_reg, Mul_Exception_reg, Mul_Overflow_reg, Mul_Underflow_reg;
reg AddBar_Sub_reg;

wire [31:0] Add_Sub_A, Add_Sub_B, Mul_A, Mul_B;
wire Add_Sub_Exception, Mul_Exception, Mul_Overflow, Mul_Underflow;
wire [31:0] Add_Sub_Output, Mul_Output;
wire AddBar_Sub;

assign {Add_Sub_A, Add_Sub_B, AddBar_Sub} = (Operation == 4'd10) ? {a_operand, b_operand, 1'b0} :
                                             (Operation == 4'd3)  ? {a_operand, b_operand, 1'b1} :
                                             64'dz;

assign {Mul_A, Mul_B} = (Operation == 4'd1) ? {a_operand, b_operand} : 64'dz;

Addition_Subtraction AuI(.clk(clk), .a_operand(Add_Sub_A), .b_operand(Add_Sub_B), .AddBar_Sub(AddBar_Sub), .Exception(Add_Sub_Exception), .result(Add_Sub_Output));
Multiplication MuI(.clk(clk), .a_operand(Mul_A), .b_operand(Mul_B), .Exception(Mul_Exception), .Overflow(Mul_Overflow), .Underflow(Mul_Underflow), .result(Mul_Output));

always @(posedge clk) begin
    if (Operation == 4'd10) begin
        Add_Sub_Output_reg <= Add_Sub_Output;
        Add_Sub_Exception_reg <= Add_Sub_Exception;
    end
    else if (Operation == 4'd1) begin
        Mul_Output_reg <= Mul_Output;
        Mul_Exception_reg <= Mul_Exception;
        Mul_Overflow_reg <= Mul_Overflow;
        Mul_Underflow_reg <= Mul_Underflow;
    end
end

always @* begin
    if (Operation == 4'd10) begin
        ALU_Output <= Add_Sub_Output_reg;
        Exception <= Add_Sub_Exception_reg;
        Overflow <= 1'b0;
        Underflow <= 1'b0;
    end
    else if (Operation == 4'd1) begin
        ALU_Output <= Mul_Output_reg;
        Exception <= Mul_Exception_reg;
        Overflow <= Mul_Overflow_reg;
        Underflow <= Mul_Underflow_reg;
    end
    else if (Operation == 4'd3) begin
        ALU_Output <= Add_Sub_Output_reg;
        Exception <= Add_Sub_Exception_reg;
        Overflow <= 1'b0;
        Underflow <= 1'b0;
    end
    else begin
        ALU_Output <= 32'dz;
        Exception <= 1'b0;
        Overflow <= 1'b0;
        Underflow <= 1'b0;
    end
end

endmodule
