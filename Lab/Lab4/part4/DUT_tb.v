`timescale 1ns / 1ps

module DUT_tb;

	// Inputs
	reg Clk;
	reg Reset;
	reg [1:0] Control;
	reg [15:0] Input1;
	reg [15:0] Input2;
	reg [15:0] state00_inputs[0:9];
	reg [15:0] state01_inputs[0:7];
	reg [15:0] state10_inputs[0:17];
	reg [15:0] state11_inputs[0:17];
	
	reg [16:0] state00_outputs[0:4];
	reg [33:0] state01_outputs[0:3];
	reg [34:0] state10_outputs[0:2];
	reg [37:0] state11_outputs[0:8]; 
	// Outputs
	wire [37:0] Output1;
	wire [34:0]out1;
	reg [5:0]error;
	// Instantiate the Unit Under Test (UUT)
	DUT uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.Control(Control), 
		.Input1(Input1), 
		.Input2(Input2), 
		.Output1(Output1)
	);
	assign out1 = Output1[34:0];
	always #100 Clk = ~Clk;
	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 1;
		error = 0;
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab3/data/state00_inputs.txt",state00_inputs);
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab3/data/state00_outputs.txt",state00_outputs);
		
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab3/data/state01_inputs.txt",state01_inputs);
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab3/data/state01_outputs.txt",state01_outputs);
		
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab3/data/state10_inputs.txt",state10_inputs);
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab3/data/state10_outputs.txt",state10_outputs);
		
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab3/data/state11_inputs.txt",state11_inputs);
		$readmemb("C:/Documents and Settings/Administrator/Desktop/Xillinx projects/Lab4/Lab3/data/state11_outputs.txt",state11_outputs);
		
		#200
		Reset = 0;
		Control = 2'b00;
		Input1 = state00_inputs[0];
		Input2 = state00_inputs[1];
		#600
		if({21'b0,state00_outputs[0]} != Output1)
			error = error + 1;
		Control = 2'b00;
		Input1 = state00_inputs[2];
		Input2 = state00_inputs[3];
		#600
		if({21'b0,state00_outputs[1]} != Output1)
			error = error + 1;
		Control = 2'b00;
		Input1 = state00_inputs[4];
		Input2 = state00_inputs[5];
		#600
		if({21'b0,state00_outputs[2]} != Output1)
			error = error + 1;
		Control = 2'b00;
		Input1 = state00_inputs[6];
		Input2 = state00_inputs[7];
		#600
		if({21'b0,state00_outputs[3]} != Output1)
			error = error + 1;
		Control = 2'b00;
		Input1 = state00_inputs[8];
		Input2 = state00_inputs[9];
		#600
		if({21'b0,state00_outputs[4]} != Output1)
			error = error + 1;
		Control = 2'b01;
		Input1 = state01_inputs[0];
		Input2 = state01_inputs[1];
		#600
		if({4'b0,state01_outputs[0]} != Output1)
			error = error + 1;
		Control = 2'b01;
		Input1 = state01_inputs[2];
		Input2 = state01_inputs[3];
		#600
		if({4'b0,state01_outputs[1]} != Output1)
			error = error + 1;
		Control = 2'b01;
		Input1 = state01_inputs[4];
		Input2 = state01_inputs[5];
		#600
		if({4'b0,state01_outputs[2]} != Output1)
			error = error + 1;
		Control = 2'b01;
		Input1 = state01_inputs[6];
		Input2 = state01_inputs[7];
		#600
		if({4'b0,state01_outputs[3]} != Output1)
			error = error + 1;
		Control = 2'b10;
		Input1 = state10_inputs[0];
		Input2 = state10_inputs[3];
		#400
		Input1 = state10_inputs[1];
		Input2 = state10_inputs[4];
		#200
		Input1 = state10_inputs[2];
		Input2 = state10_inputs[5];
		#1600
		if({3'b0,state10_outputs[0]} != Output1)
			error = error + 1;
		Control = 2'b10;
		Input1 = state10_inputs[6];
		Input2 = state10_inputs[9];
		#200
		Input1 = state10_inputs[7];
		Input2 = state10_inputs[10];
		#200
		Input1 = state10_inputs[8];
		Input2 = state10_inputs[11];
		#1600
		if({3'b0,state10_outputs[1]} != Output1)
			error = error + 1;
				Control = 2'b10;
		Input1 = state10_inputs[12];
		Input2 = state10_inputs[15];
		#200
		Input1 = state10_inputs[13];
		Input2 = state10_inputs[16];
		#200
		Input1 = state10_inputs[14];
		Input2 = state10_inputs[17];
		#1600
		if({3'b0,state10_outputs[2]} != Output1)
			error = error + 1;
		Control = 2'b11;
		Input1 = state11_inputs[0];
		Input2 = state11_inputs[9];
		#400
		Input1 = state11_inputs[1];
		Input2 = state11_inputs[10];
		#200
		Input1 = state11_inputs[2];
		Input2 = state11_inputs[11];
		#200
		Input1 = state11_inputs[3];
		Input2 = state11_inputs[12];
		#200
		Input1 = state11_inputs[4];
		Input2 = state11_inputs[13];
		#200
		Input1 = state11_inputs[5];
		Input2 = state11_inputs[14];
		#200
		Input1 = state11_inputs[6];
		Input2 = state11_inputs[15];
		#200
		Input1 = state11_inputs[7];
		Input2 = state11_inputs[16];
		#200
		Input1 = state11_inputs[8];
		Input2 = state11_inputs[17];
		#(2*200)
		if(state11_outputs[0] != Output1)
			error = error + 1;
		#200
		if(state11_outputs[1] != Output1)
			error = error + 1;
		Control = 2'b00;
		#200
		if(state11_outputs[2] != Output1)
			error = error + 1;
		#200
		if(state11_outputs[3] != Output1)
			error = error + 1;
		#200
		if(state11_outputs[4] != Output1)
			error = error + 1;
		#200
		if(state11_outputs[5] != Output1)
			error = error + 1;
		#200
		if(state11_outputs[6] != Output1)
			error = error + 1;
		#200
		if(state11_outputs[7] != Output1)
			error = error + 1;
		#200
		if(state11_outputs[8] != Output1)
			error = error + 1;
		if(error == 0)
			$display("The outputs of module are true.");
		else
			$display("%d tests have wrong answer.",error);
		// Wait 100 ns for global reset to finish
		// Add stimulus here

	end
      
endmodule

