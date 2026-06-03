module systolic_array_1d(
	input clk,
	input reset,
	input enable,

	input [3:0] data_in,
	input [3:0] weight0,
	input [3:0] weight1,

	output [15:0] out0,
	output [15:0] out1
);

reg [3:0] data_pipe;

processing_element PE0(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.A(data_in),
	.B(weight0),
	.Y(out0)
);

always @(posedge clk)
begin
	if(reset)
		data_pipe <= 0;
	else
		data_pipe <= data_in;
end

processing_element PE1( 
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(data_in),
        .B(weight1),
        .Y(out1)
);

endmodule

