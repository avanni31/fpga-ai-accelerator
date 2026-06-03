module ai_accelerator_final(
	input clk,
	input reset,
	input start,

	input [7:0] data_in,
	input [7:0] weight_in,

	output done,
	output [15:0] result
);

wire [7:0] buffered_data;
wire [7:0] buffered_weight;
wire enable;

input_buffer input_buf(
	.clk(clk),
	.reset(reset),
	.load(start),
	.data_in(data_in),
	.data_out(buffered_data)
);

weight_buffer weight_buf(
	.clk(clk),
	.reset(reset),
	.load(load),
	.weight_in(weight_in),
	.weight_out(buffered_weight)
);

controller_fsm controller(
	.clk(clk),
	.reset(reset),
	.start(start),
	.done(done),
	.enable(enable)
);

assign result = buffered_data + buffered_weight;

endmodule
