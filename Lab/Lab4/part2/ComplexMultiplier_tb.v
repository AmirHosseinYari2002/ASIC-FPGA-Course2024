`timescale 1ns / 1ps
module ComplexMultiplier_tb;
	// Inputs
	reg Clk;
	reg Reset;
	reg [15:0] InputMultiplier1;
	reg [15:0] InputMultiplier2;
	reg [15:0] inputs[0:7];
	reg [33:0] outputs[0:3];
	reg [4:0]error;
	// Outputs
	wire [33:0] MultiplicationResult;

	// Instantiate the Unit Under Test (UUT)
	ComplexMultiplier uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.InputMultiplier1(InputMultiplier1), 
		.InputMultiplier2(InputMultiplier2), 
		.MultiplicationResult(MultiplicationResult)
	);
	
	always #10 Clk = ~Clk;
	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 0;
		error = 0;
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab2/Data/inputs.txt",inputs);
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab2/Data/outputs.txt",outputs);
		#20
		Reset = 1;
		InputMultiplier1 = inputs[0];
		InputMultiplier2 = inputs[1];
		#20
		if(MultiplicationResult != outputs[0])
			error = error + 1;
		#20
		InputMultiplier1 = inputs[2];
		InputMultiplier2 = inputs[3];
		#20
		if(MultiplicationResult != outputs[1])
			error = error + 1;
		InputMultiplier1 = inputs[4];
		InputMultiplier2 = inputs[5];
		#20
		if(MultiplicationResult != outputs[2])
			error = error + 1;
		InputMultiplier1 = inputs[6];
		InputMultiplier2 = inputs[7];
		#20
		if(MultiplicationResult != outputs[3])
			error = error + 1;
		if(error == 0)
			$display("results are true.");
		else
			$display("the number of error is %d",error);
	end
      
endmodule

