`timescale 1ns/1ps 

module matrix_mult_2_2_tb;

reg [3:0] A00,A01,A10,A11;
reg [3:0] B00,B01,B10,B11;

wire [15:0] C00,C01,C10,C11;

matrix_mult_2_2 uut(
	.A00(A00),
	.A01(A01), 
	.A10(A10), 
	.A11(A11),
	
	.B00(B00),
	.B01(B01),
	.B10(B10),
	.B11(B11), 

	.C00(C00),
	.C01(C01),
	.C10(C10),
	.C11(C11)
);

initial begin 

	$dumpfile("build/matrix_mult_2_2.vcd");
	$dumpvars(0, matrix_mult_2_2_tb);

	A00=1;
	A01=2;
	A10=3;
	A11=4;

	B00=5;
	B01=6;
	B10=7;
	B11=8;

	#20;

	$finish;
end

endmodule
