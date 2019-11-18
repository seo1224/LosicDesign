module mux2to1_cond( 	out,
			in0,
			in1,
			sel);

output 			out ;
input 			in0 ;
input 			in1 ;
input 			sel ;

assign out = (sel)? in1 : in0 ;

endmodule


module mux2to1_if( 	out, 
		   	in0, 
			in1, 
			sel);

output 			out ;
input 			in0 ;
input 			in1 ;
input 			sel ;

reg 			out ;

always @(*) begin
	if (sel == 1'b0) begin
		out = in0 ;
	end else begin
		out = in1 ;
	end
end
endmodule


module mux2to1_case( 	out, 
		   	in0, 
			in1, 
			sel);

output 			out ;
input 			in0 ;
input 			in1 ;
input 			sel ;

reg 			out ;

always @(*) begin
case( {sel} )
	1'b0 : out = in0 ;
	1'b1 : out = in1 ;
	endcase
end
endmodule
