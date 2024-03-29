module tb3_1 ;

reg		in0;
reg		in1;
reg		in2;
reg		in3;
reg	[1:0]	sel;

wire		out1;
wire		out2;
wire		out3;

mux4to1_inst		dut_1(	.out1	( out1   ),
				.in0	( in0   ),
				.in1    ( in1   ),
				.in2	( in2   ),
				.in3	( in3   ),
				.sel	( sel   ));

mux4to1_if		dut_2(	.out2	( out2   ),
				.in0	( in0   ),
				.in1    ( in1   ),
				.in2	( in2   ),
				.in3	( in3   ),
				.sel	( sel   ));

mux4to1_case		dut_3(	.out3	( out3   ),
				.in0	( in0   ),
				.in1    ( in1   ),
				.in2	( in2   ),
				.in3	( in3   ),
				.sel	( sel   ));

initial begin 
	$display("inst : out1");
	$display("if : out2");
	$display("case : out3");
	$display("===========================");
	$display("in0 in1 in2 in3 sel[0] sel[1] out1 out2 out3");
	$display("===========================");

	#(50)	{sel[0], sel[1], in3, in2, in1, in0} = 6'b_000000;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel[0], sel[1], out1, out2, out3);
	#(50)	{sel[0], sel[1], in3, in2, in1, in0} = 6'b_000001;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel[0], sel[1], out1, out2, out3);
	#(50)	{sel[0], sel[1], in3, in2, in1, in0} = 6'b_000010;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel[0], sel[1], out1, out2, out3);
	#(50)	{sel[0], sel[1], in3, in2, in1, in0} = 6'b_000011;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel[0], sel[1], out1, out2, out3);
	#(50)	{sel[0], sel[1], in3, in2, in1, in0} = 6'b_000100;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel[0], sel[1], out1, out2, out3);
	#(50)	{sel[0], sel[1], in3, in2, in1, in0} = 6'b_000101;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel[0], sel[1], out1, out2, out3);
	#(50)	{sel[0], sel[1], in3, in2, in1, in0} = 6'b_000110;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel[0], sel[1], out1, out2, out3);
	#(50)	{sel[0], sel[1], in3, in2, in1, in0} = 6'b_000111;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", in0, in1, in2, in3, sel[0], sel[1], out1, out2, out3);
	#(50)   $finish			 ;
end

endmodule 
