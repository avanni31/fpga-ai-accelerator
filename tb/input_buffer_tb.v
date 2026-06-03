`timescale 1ns/1ps

module input_buffer_tb;

reg clk;
reg reset;
reg load;
reg [7:0] data_in;
wire [7:0] data_out;

input_buffer uut(
	.clk(clk),
	.reset(reset),
	.load(load),
	.data_in(data_in),
	.data_out(data_out)
);

initial begin
	clk=0;
	forever #5 clk=~clk;
end
initial begin
	$dumpfile("build/input_buffer.vcd");
	$dumpvars(0, input_buffer_tb);

	clk=0;
	reset=1;
	load=0;
	data_in=0;

	#10 reset =0;

	load=1;
	data_in= 8'd25;
	#10;

	data_in=8'd50;
	#10;

	load=0;
	data_in=8'd100;
	#10;

	$finish;
end
endmodule
