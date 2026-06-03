module weight_buffer(
	input clk,
	input reset,
	input load,
	input [7:0] weight_in,
	output reg [7:0] weight_out
);

always @(posedge clk or posedge reset) begin
	if(reset)
		weight_out <= 8'd0;
	else if(load)
		weight_out <= weight_in;
end
endmodule
