`timescale 1ns/1ps

module mac_unit_tb;

reg clk;
reg reset;
reg [3:0] A;
reg [3:0] B;

wire [15:0] Y;

mac_unit uut(
	.clk(clk),
	.reset(reset),
	.A(A),
	.B(B),
	.Y(Y)
);

always #5 clk = ~clk;

initial begin

	$dumbfile("build/mac_unit.vcd");
	$dumbvars(0, mac_unit_tb);

	clk=0;
	reset=0;
	A=0;
	B=0;

	#12;
	reset=0;

	A=2; B=3;
	#10;

	A=4; B=5;
	#10;

	A=1; B=7;
	#10;

	A=3; B=3;
	#10;

	$finish;
end 
endmodule
