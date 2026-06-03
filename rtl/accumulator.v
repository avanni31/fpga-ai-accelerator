module accumulator(
	input clk,
	input reset,
	input [7:0] in,
	output reg [15:0] sum
);

always @(posedge clk)
begin 
	if (reset == 1)
		sum <= 16'd0;
	else
		sum <= sum + in;
end
endmodule
