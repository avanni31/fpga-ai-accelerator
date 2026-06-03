module mac_unit(
	input clk,
	input reset,
	input [3:0] A,
	input [3:0] B,
	output reg [15:0] Y
);

wire [7:0] mult;

assign mult = A * B;

always @(posedge clk)
begin
	if(reset)
		Y <= 0;
	else
		Y <= Y + mult;
end 
endmodule

