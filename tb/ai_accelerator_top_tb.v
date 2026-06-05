`timescale 1ns/1ps
module ai_accelerator_top_tb;

reg clk;
reg reset;
reg start;

reg [3:0] A00,A01,A10,A11;
reg [3:0] B00,B01,B10,B11;

wire [15:0] Y00,Y01,Y10,Y11;
wire done;

ai_accelerator_top uut(
	.clk(clk),
	.reset(reset),
	.start(start),

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
	.Y11(Y11),

	.done(done)
);

initial begin
	clk=0;
	forever #5 clk=~clk;
end

initial begin
	$dumpfile("build/ai_accelerator_top.vcd");
	$dumpvars(0, ai_accelerator_top_tb);

	clk=0;
	reset=1;
	start=0;

	A00=2; A01=3;
	A10=4; A11=5;

	B00=6; B01=7;
	B10=8; B11=9;

	#10;
	reset=0;

	#10;
	start=1;

	#10;
	start=0;

	#100;

	$display("");
	$display("=================================");
	$display("     AI ACCELERATOR RESULTS      ");
	$display("=================================");
	$display("  Y00 = %0d  (expected 12)", Y00);
	$display("  Y01 = %0d  (expected 21)", Y01);
	$display("  Y10 = %0d  (expected 32)", Y10);
	$display("  Y11 = %0d  (expected 45)", Y11);
	$display("=================================");

	if (Y00==16'd36 && Y01==16'd41 && Y10==16'd64 && Y11==16'd73)
		$display("  STATUS : ALL OUTPUTS CORRECT  ");
	else
		$display("  STATUS : MISMATCH DETECTED    ");

	$display("=================================");
	$display("");

	$finish;
end

endmodule
