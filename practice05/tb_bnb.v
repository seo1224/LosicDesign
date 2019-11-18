module tb_bnb		;

wire 	q1		;
wire	q2		;

reg 	q		;
reg	d		;
reg	clk		;

initial clk = 1'b0;
always #(50) clk = ~clk;

block		dut_0(	.q  ( q1  ),
			.d  ( d   ),
			.clk( clk ));

nonblock	dut_1(	.q  ( q2  ),
			.d  ( d   ),
			.clk( clk ));

initial begin
#(0)	{d} = 1'b0; #(100) $display("%b\t%b\t%b\t%b\t", d, clk, q1, q2);
#(125)	{d} = 1'b1; #(100) $display("%b\t%b\t%b\t%b\t", d, clk, q1, q2);
#(100)	{d} = 1'b0; #(100) $display("%b\t%b\t%b\t%b\t", d, clk, q1, q2);
#(100)	{d} = 1'b1; #(100) $display("%b\t%b\t%b\t%b\t", d, clk, q1, q2);	
$finish		  ;

end

endmodule
