`timescale 1ns/1ps

module accumulator_tb;

reg clk;
reg reset;
reg [7:0] in;

wire [15:0] sum;

accumulator uut(
	.clk(clk),
	.reset(reset),
	.in(in),
	.sum(sum)
);

initial begin
	clk=0;
	forever #5 clk = ~clk;
end

initial begin 

	$dumpfile("build/accumulator.vcd");
	$dumpvars(0, accumulator_tb);

	reset=1;
	in=0;

	#10;
	reset=0;

	in=5;
	#10;

	in=3;
	#10;

	in=2;
	#10;

	in=10;
	#10;

	$finish;
end 
endmodule 
