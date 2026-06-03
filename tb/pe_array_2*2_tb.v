`timescale 1ns/1ps

module pe_array_2_2_tb;

reg clk;
reg reset;
reg enable;

reg [3:0] A0,B0;
reg [3:0] A1,B1;
reg [3:0] A2,B2;
reg [3:0] A3,B3;

wire [15:0] Y0.Y1,Y2,Y3;

pe_array_2_2 uut(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	
	.A0(A0), .B0(B0),
	.A1(A1), .B1(B1),
	.A2(A2), .B2(B2),
	.A3(A3), .B3(B3),

	.Y0(Y0),
	.Y1(Y1),
	.Y2(Y2),
	.Y3(Y3)
);

initial begin 
	clk=0;
	forever #5 clk= ~clk;
end 

initial begin 

	$dumpfile("build/pe_array_2_2.vcd");
	$dumpvars(0, pe_array_2_2_tb);

	reset=1;
	enable=0;

	A0=0; B0=0;
	A1=0; B1=0;
	A2=0; B2=0;
	A3=0; B3=0;

	#12;
	reset=0;
	enable=1;

	A0=2; B0=3;
        A1=1; B1=4;
        A2=5; B2=2;
        A3=3; B3=3;

	#10;

	A0=1; B0=1;
        A1=2; B1=2;
        A2=3; B2=3;
        A3=4; B3=4;

	#10;
	$finish;
end 
endmodule
