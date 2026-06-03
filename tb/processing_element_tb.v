`timescale 1ns/1ps

module processing_element_tb;

reg clk;
reg reset;
reg enable;
reg [3:0] A;
reg [3:0] B;

wire [15:0] Y;

processing_element uut(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.A(A),
	.B(B),
	.Y(Y)
);

initial begin
	clk=0;
	forever #5 clk= ~clk;
end

initial begin 
	$dumpfile("build/processing_element.vcd");
	$dumpvars(0, processing_element_tb);

	reset=1;
	enable=0;
	A=0;
	B=0;

	#12;
	reset=0;

	enable=1;

	A=2;
	B=3;
	#10;

	A=4;
	B=5;
	#10;

	A=7;
	B=7;
	#10;

	enable=1;

	A=1;
	B=8;
	#10;

	$finish;
end 
endmodule

