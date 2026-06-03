module ai_accelerator_top(
	input clk,
	input reset,
	input start,

	input [3:0] A00,
	input [3:0] A01,
	input [3:0] A10,
	input [3:0] A11,

	input [3:0] B00,
	input [3:0] B01,
	input [3:0] B10,
	input [3:0] B11,

	output [15:0] Y00,
	output [15:0] Y01,
	output [15:0] Y10,
	output [15:0] Y11,
	output done
);

wire enable;

controller_fsm controller(
	.clk(clk),
	.reset(reset),
	.start(start),

	.enable(enable),
	.done(done)
);

systolic_array_2d systolic(
	.clk(clk),
	.reset(reset),
	.enable(enable),

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
        .Y11(Y11)
);

endmodule
