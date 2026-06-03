module board_demo_top(
	input clk,
	input reset,
	input start,
	output done
);

wire [15:0] Y00;
wire [15:0] Y01;
wire [15:0] Y10;
wire [15:0] Y11;

ai_accelerator_top accelerator(
	.clk(clk),
	.reset(reset),
	.start(start),

	.A00(4'd2),
	.A01(4'd3),
	.A10(4'd4),
	.A11(4'd5),

	.B00(4'd6),
	.B01(4'd7),
	.B10(4'd8),
	.B11(4'd9),

	.Y00(Y00),
	.Y01(Y01),
	.Y10(Y10),
	.Y11(Y11),

	.done(done)
);

endmodule
