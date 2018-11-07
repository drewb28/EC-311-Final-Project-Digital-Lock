`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:19:19 04/25/2018 
// Design Name: 
// Module Name:    Final_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Final_test;

	// Inputs
	reg rst1;
	reg rst2;
	reg clk;
	reg ent1;
	reg change1;
	reg clr1;
	reg [3:0] sw;
//	reg [3:0] p1;
//	reg [3:0] p2;
//	reg [3:0] p3;
//	reg [3:0] p4;
	
	
	// Outputs
	wire [6:0] ssd;
	wire [7:0] led;
	wire [3:0] AN;
//	wire [3:0] cp1;
//	wire [3:0] cp2;
//	wire [3:0] cp3;
//	wire [3:0] cp4;
	

	// Instantiate the Unit Under Test (UUT)
	Final_Project uut (
		.rst1(rst1), 
		.rst2(rst2), 
		.clk(clk), 
		.ent(ent), 
		.change(change), 
		.clr1(clr1), 
		.ssd(ssd), 
		.led(led), 
		.AN(AN), 
		.sw(sw),
//	.p1(p1),
//	.p2(p2),
//	.p3(p3),
//	.p4(p4)
//		.cp1(cp1),
//		.cp2(cp2),
//		.cp3(cp3),
//		.cp4(cp4)
		
	);

	initial begin
		// Initialize Inputs
		rst1 = 0;
		rst2 = 0;
		clk = 0;
		ent = 0;
		change = 0;
		clr1 = 0;
		sw = 0;
//		p1 = 4'd1;
//		p2 = 4'd0;
//		p3 = 4'd1;
//		p4 = 4'd0;
		


		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	always #2 clk = ~clk;
	
	#10
	ent = 1;
	sw = 4'd0;
	ent = 0;
	#20
	ent = 1;
	sw = 4'd0;
	ent = 0;
	#30
	ent = 1;
	sw = 4'd0;
	ent = 0;
	#40
	ent = 1;
	sw = 4'd0;
	ent = 0;
	#50
	ent = 1;
	ent = 0;
	#60
	change1
	
	
      
endmodule

