module full_adder(Sum,Cout,A,B,Cin);
input A, B, Cin;
output Sum, Cout;
assign Sum = A ^ B ^ Cin;
assign Cout = ( A & B ) | ( B & Cin ) | ( A & Cin );
endmodule
