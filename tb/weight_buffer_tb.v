`timescale 1ns/1ps

module weight_buffer_tb;

reg clk;
reg reset;
reg load;
reg [7:0] weight_in;
wire [7:0] weight_out;

weight_buffer uut(
	.clk(clk),
	.reset(reset),
	.load(load),
	.weight_in(weight_in),
	.weight_out(weight_out)
);

initial begin
	clk=0;
	forever #5 clk=~clk;
end

initial begin
	$dumpfile("build/weight_buffer.vcd");
	$dumpvars(0, weight_buffer_tb);

	clk=0;
	reset=1;
	load=0;
	weight_in=0;

	#10 reset=0;

	load=1;
	weight_in=8'd3;
	#10;

	weight_in=8'd7;
	#10;

	load=0;
	#10;

	$finish;
end
endmodule
