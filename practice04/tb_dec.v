module tb_dec ;

reg     [2:0]	in ;
reg		en ;

wire	[7:0]	out1;
wire	[7:0]	out2;

dec3to8_shift		dut_1(	.out	( out1 ),
				.in	( in   ),
				.en	( en   ));

dec3to8_case		dut_2(	.out	( out2 ),
				.in	( in   ),
				.en	( en   ));

initial begin 
	$display("shift : out1");
	$display("case : out2");
	$display("===========================");
	$display("en in[2], in[1], in[0] out1 out2");
	$display("===========================");

	#(50)	{en, in} = 4'b0000;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b0001;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b0010;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b0011;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b0100;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b0101;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b0110;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b0111;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b1000;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b1001;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b1010;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b1011;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b1100;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b1101;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b1110;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	{en, in} = 4'b1111;	#(50)		$display("%b\t%b\t%b\t%b\t%b\t%b\t", en, in[2], in[1], in[0], out1, out2);
	#(50)	$finish		  ;
end

endmodule 
