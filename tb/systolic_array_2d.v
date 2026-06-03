`timescale 1ns/1ps

module systolic_array_2d_tb;


reg clk;
reg reset;
reg enable;

reg [3:0] A00,A01,A10,A11;
reg [3:0] B00,B01,B10,B11;

wire [15:0] Y00,Y01,Y10,Y11;

systolic_array_2d uut(
	.clk(clk),
	.reset(reset),
	.enable(enable),

	.A00(A00),
	.A01(A01),
	.A10(A10),
	.A11(A11),

	.B00(B00),
	.B01(B01),
	.B10(B10),
	.B11(B11),

	.Y00(Y00),
	.Y01(Y01),
	.Y10(Y10),
	.Y11(Y11)
);

initial begin 
	clk=0;
	forever #5 clk= ~clk;
end 

intial begin 
	$dumpfile("build/systolic_array_2d.vcd");
	$dumpvars(0, systolic_array_2d_tb);

	clk=0;
	reset=1;
	enable=0;

	#10; 

	reset=0;
	enable=1;

	A00=2; A01=3;
	A10=4; A11=5;

	B00=6; B01=7;
	B10=8; B11=9;

	#20;

	$finish;
end 
endmodule
