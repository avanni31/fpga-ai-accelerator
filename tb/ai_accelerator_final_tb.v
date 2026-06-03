`timescale 1ns/1ps

module ai_accelerator_final_tb;

reg clk;
reg reset;
reg start;

reg [7:0] data_in;
reg [7:0] weight_in;

wire done;
wire [15:0] result;

ai_accelerator_final uut(
	.clk(clk),
	.reset(reset),
	.start(start),
	.data_in(data_in),
	.weight_in(weight_in),
	.done(done),
	.result(result)
);

initial begin
	clk=0;
	forever #5 clk=~clk;
end

initial begin
	$dumpfile("build/ai_accelerator_final.vcd");
	$dumpvars(0, ai_accelerator_final_tb);

	clk=0;
	reset=1;
	start=0;

	data_in=0;
	weight_in=0;

	#10 reset=0;

	data_in= 8'd4;
	weight_in= 8'd3;

	start=1;
	#10;

	start=0;

	#50;

	$finish;
end
endmodule
