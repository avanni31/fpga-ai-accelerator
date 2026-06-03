`timescale 1ns/1ps

module controller_fsm_tb;

reg clk;
reg reset;
reg start;

wire enable;
wire done;

controller_fsm uut(
	.clk(clk),
	.reset(reset),
	.start(start),
	
	.enable(enable),
	.done(done)
);

initial begin
	clk=0;
	forever #5 clk=~clk;
end

initial begin
	$dumpfile("build/controller_fsm.vcd");
	$dumpvars(0, controller_fsm_tb);

	clk=0;
	reset=1;
	start=0;

	#10;

	reset=0;

	#10;

	start=1;

	#10;

	start=0;

	#50;

	$finish;
end
endmodule
