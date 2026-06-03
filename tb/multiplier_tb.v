`timescale 1ns/1ps

module multiplier_tb;

reg [3:0] A;
reg [3:0] B;

wire [7:0] P;

multiplier uut(
	.A(A),
	.B(B),
	.P(P)
);

initial begin

	$dumpfile("build/multiplier.vcd");
	$dumpvars(0, multiplier_tb);

	A=2; B=3;
	#10;
	A=4; B=5;
	#10;
	A=7; B=3;
	#10;
	A=15; B=15;
	#10;

	$finish;
end
endmodule
