`timescale 1ns/1ps

module systolic_array_1d_tb;

reg clk;
reg reset;
reg enable;

reg [3:0] data_in;
reg [3:0] weight0;
reg [3:0] weight1;

wire [15:0] out0;
wire [15:0] out1;

systolic_arrat_1d uut(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	
	.data_in(data_in),
	.weight0(weight0),
	.weight1(weight1),

	.out0(out0),
	.out1(out1)
);

initial begin 
	clk=0;
	forever #5 clk = ~clk;
end 

initial begin
	$dumpfile("build/systolic_array_1d.vcd");
	$dumpvars(0, systolic_array_1d_tb);

	reset=1;
	enable=0;

	data_in=0;
	weight0=2;
	weight1=3;

	#12;

	reset=0;
	enable=1;

	data_in=4;
	#10;

	data_in=5;
	#10;

	data_in=2;
	#10;

	$finish;
end
endmodule
