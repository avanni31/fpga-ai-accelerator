module systolic_array_2d(
	input clk,
	input reset,
	input enable,

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
	output [15:0] Y11
);

processing_element PE00(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.A(A00),
	.B(B00),
	.Y(Y00)
);

processing_element PE01( 
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(A01),
        .B(B01),
        .Y(Y01)
);

processing_element PE10( 
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(A10),
        .B(B10),
        .Y(Y10)
);

processing_element PE11( 
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(A11),
        .B(B11),
        .Y(Y11)
);

endmodule
