//	==================================================
//	Copyright (c) 2019 Sookmyung Women's University.
//	--------------------------------------------------
//	FILE 			: Prj.clock
//	DEPARTMENT		: EE
//	--------------------------------------------------
//	RELEASE HISTORY
//	--------------------------------------------------
//	VERSION			DATE
//	2.0			2019
//	--------------------------------------------------
//	PURPOSE			: Digital Clock
//	==================================================

//	--------------------------------------------------
//	Numerical Controlled Oscillator
//	Hz of o_gen_clk = Clock Hz / num
//	--------------------------------------------------
module	nco(	      
		o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	// 50Mhz CLK
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt		<= 32'd0;
		o_gen_clk	<= 1'd0	;
	end else begin
		if(cnt >= i_nco_num/2-1) begin
			cnt 	<= 32'd0;
			o_gen_clk	<= ~o_gen_clk;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule

module	nco_spark(	      
		o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	// 50Mhz CLK
input		rst_n		;

reg	[31:0]	cnt_spark	;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_spark	<= 32'd0;
		o_gen_clk	<= 1'd0	;
	end else begin
		if(cnt_spark >= i_nco_num/2-1) begin
			cnt_spark 	<= 32'd0;
			o_gen_clk	<= ~o_gen_clk;
		end else begin
			cnt_spark <= cnt_spark + 1'b1;
		end
	end
end

endmodule

module	nco_alarm(	
		o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt		<= 32'd0;
		o_gen_clk	<= 1'd0	;
	end else begin
		if(cnt >= i_nco_num/4-1) begin
			cnt 	<= 32'd0;
			o_gen_clk	<= ~o_gen_clk;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule

//	--------------------------------------------------
//	Flexible Numerical Display Decoder
//	--------------------------------------------------
module	fnd_dec(
		o_seg,
		i_num);

output	[6:0]	o_seg		;	// {o_seg_a, o_seg_b, ... , o_seg_g}

input	[3:0]	i_num		;
reg	[6:0]	o_seg		;
//making
always @(i_num) begin 
 	case(i_num) 
 		4'd0:	o_seg = 7'b111_1110; 
 		4'd1:	o_seg = 7'b011_0000; 
 		4'd2:	o_seg = 7'b110_1101; 
 		4'd3:	o_seg = 7'b111_1001; 
 		4'd4:	o_seg = 7'b011_0011; 
 		4'd5:	o_seg = 7'b101_1011; 
 		4'd6:	o_seg = 7'b101_1111; 
 		4'd7:	o_seg = 7'b111_0000; 
 		4'd8:	o_seg = 7'b111_1111; 
 		4'd9:	o_seg = 7'b111_0011; 
		default:o_seg = 7'b000_0000; 
	endcase 
end

endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	double_fig_sep(
		o_left,
		o_right,
		i_double_fig);

output	[3:0]	o_left		;
output	[3:0]	o_right		;

input	[5:0]	i_double_fig	;

assign		o_left	= i_double_fig / 10	;
assign		o_right	= i_double_fig % 10	;

endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	led_disp(
		o_seg,
		o_seg_dp,
		o_seg_enb,
		i_six_digit_seg,
		i_mode,
		i_position,
		clk,
		rst_n);

output	[5:0]	o_seg_enb		;
output		o_seg_dp		;
output	[6:0]	o_seg			;

input	[41:0]	i_six_digit_seg		;
input	[1:0]	i_mode			;
input	[1:0] 	i_position		;
input		clk			;
input		rst_n			;

wire		gen_clk		;

nco		u_nco(
		.o_gen_clk	( gen_clk	),
		.i_nco_num	( 32'd5000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

//blink
nco		u1_nco(
		.o_gen_clk	( clk_blink	),
		.i_nco_num	( 32'd5000000   ),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg	[3:0]	cnt_common_node	;
reg		cnt_hr		; //count hr (blink: on/off repeat)
reg		cnt_min		; //count min(blink: on/off repeat)
reg		cnt_sec		; //count sec(blink)

always @(posedge gen_clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_common_node <= 4'd0;
	end else begin
		if(cnt_common_node >= 4'd5) begin
			cnt_common_node <= 4'd0;
		end else begin
			cnt_common_node <= cnt_common_node + 1'b1;
		end
	end
end

always @(posedge clk_blink or negedge rst_n) begin
	if(rst_n ==1'b0) begin
		cnt_hr = 0;
		cnt_min= 0;
		cnt_sec= 0;
	end else begin
		cnt_hr <= cnt_hr + 1'b1; // count hr  repeat (blink)
		cnt_min<= cnt_min+ 1'b1; // count min repeat (blink)
		cnt_sec<= cnt_sec+ 1'b1; // count sec repaet (blink)
	end
end

reg	[5:0]	o_seg_enb		;

always @(i_position, i_mode, cnt_sec, cnt_min, cnt_hr, cnt_common_node) begin
	if((i_mode==2'b01)||(i_mode==2'b10)) begin // if mode is 'setup' or 'alarm'
		case(i_position) 
		2'b00: begin//position is sec
			if (cnt_sec == 1'b0) begin //count set off
				case (cnt_common_node)
					4'd0:	o_seg_enb = 6'b111111;
					4'd1:	o_seg_enb = 6'b111111;
					4'd2:	o_seg_enb = 6'b111011;
					4'd3:	o_seg_enb = 6'b110111;
					4'd4:	o_seg_enb = 6'b101111;
					4'd5:	o_seg_enb = 6'b011111;
					default:o_seg_enb = 6'b111111;
				endcase
			end else begin
				case (cnt_common_node)
					4'd0:	o_seg_enb = 6'b111110;
					4'd1:	o_seg_enb = 6'b111101;
					4'd2:	o_seg_enb = 6'b111011;
					4'd3:	o_seg_enb = 6'b110111;
					4'd4:	o_seg_enb = 6'b101111;
					4'd5:	o_seg_enb = 6'b011111;
					default:o_seg_enb = 6'b111111;
				endcase
			end
		end
		2'b01: begin
			if (cnt_min == 1'b0) begin
				case (cnt_common_node)
					4'd0:	o_seg_enb = 6'b111110;
					4'd1:	o_seg_enb = 6'b111101;
					4'd2:	o_seg_enb = 6'b111111;
					4'd3:	o_seg_enb = 6'b111111;
					4'd4:	o_seg_enb = 6'b101111;
					4'd5:	o_seg_enb = 6'b011111;
					default:o_seg_enb = 6'b111111;
				endcase
			end else begin
				case (cnt_common_node)
					4'd0:	o_seg_enb = 6'b111110;
					4'd1:	o_seg_enb = 6'b111101;
					4'd2:	o_seg_enb = 6'b111011;
					4'd3:	o_seg_enb = 6'b110111;
					4'd4:	o_seg_enb = 6'b101111;
					4'd5:	o_seg_enb = 6'b011111;
					default:o_seg_enb = 6'b111111;
				endcase
			end
		end
		2'b10: begin
			if (cnt_hr == 1'b0) begin
				case (cnt_common_node)
					4'd0:	o_seg_enb = 6'b111110;
					4'd1:	o_seg_enb = 6'b111101;
					4'd2:	o_seg_enb = 6'b111011;
					4'd3:	o_seg_enb = 6'b110111;
					4'd4:	o_seg_enb = 6'b111111;
					4'd5:	o_seg_enb = 6'b111111;
					default:o_seg_enb = 6'b111111;
				endcase
			end else begin
				case (cnt_common_node)
					4'd0:	o_seg_enb = 6'b111110;
					4'd1:	o_seg_enb = 6'b111101;
					4'd2:	o_seg_enb = 6'b111011;
					4'd3:	o_seg_enb = 6'b110111;
					4'd4:	o_seg_enb = 6'b101111;
					4'd5:	o_seg_enb = 6'b011111;
					default:o_seg_enb = 6'b111111;
				endcase		
			end
		end	
		endcase
	end else begin
		case (cnt_common_node)
			4'd0:	o_seg_enb = 6'b111110;
			4'd1:	o_seg_enb = 6'b111101;
			4'd2:	o_seg_enb = 6'b111011;
			4'd3:	o_seg_enb = 6'b110111;
			4'd4:	o_seg_enb = 6'b101111;
			4'd5:	o_seg_enb = 6'b011111;
			default:o_seg_enb = 6'b111111;
		endcase
	end
end



reg		o_seg_dp		;
reg	[5:0]	i_six_dp		;
always @(cnt_common_node, i_six_dp) begin
	case (cnt_common_node)
		4'd0:	o_seg_dp = i_six_dp[0];
		4'd1:	o_seg_dp = i_six_dp[1];
		4'd2:	o_seg_dp = i_six_dp[2];
		4'd3:	o_seg_dp = i_six_dp[3];
		4'd4:	o_seg_dp = i_six_dp[4];
		4'd5:	o_seg_dp = i_six_dp[5];
		default:o_seg_dp = 1'b0;
	endcase
end
//how 'i_six_dp' is shown to 'o_seg_dp'

always @(i_mode, i_position) begin
	if((i_mode==2'b01)||(i_mode==2'b10))begin // if mode is 'setup' or 'alarm'
		case(i_position)
		2'b00: 	i_six_dp = 6'b000001	;
		2'b01: 	i_six_dp = 6'b000100	;
		2'b10: 	i_six_dp = 6'b010000	;
		default:i_six_dp = 6'b000000	;	
		endcase
	end else begin
		i_six_dp = 6'b000000		;
	end
end 

// dp turn on

reg	[6:0]	o_seg			;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0:	o_seg = i_six_digit_seg[6:0];
		4'd1:	o_seg = i_six_digit_seg[13:7];
		4'd2:	o_seg = i_six_digit_seg[20:14];
		4'd3:	o_seg = i_six_digit_seg[27:21];
		4'd4:	o_seg = i_six_digit_seg[34:28];
		4'd5:	o_seg = i_six_digit_seg[41:35];
		default:o_seg = 7'b111_1110; // 0 display
	endcase
end

//always @(cnt_common_node) begin
	

endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hms_cnt(
		o_hms_cnt,
		o_max_hit,
		i_max_cnt,
		clk,
		rst_n);

output	[5:0]	o_hms_cnt		;
output		o_max_hit		;

input	[5:0]	i_max_cnt		;
input		clk			;
input		rst_n			;

reg	[5:0]	o_hms_cnt		;
reg		o_max_hit		;
always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_cnt <= 6'd0;
		o_max_hit <= 1'b0;
	end else begin
		if(o_hms_cnt >= i_max_cnt) begin
			o_hms_cnt <= 6'd0;
			o_max_hit <= 1'b1;
		end else begin
			o_hms_cnt <= o_hms_cnt + 1'b1;
			o_max_hit <= 1'b0;
		end
	end
end

endmodule

//----------------------------------------------------

module  debounce(
		o_sw,
		i_sw,
		clk);
output		o_sw			;

input		i_sw			;
input		clk			;

reg		dly1_sw			;
always @(posedge clk) begin
	dly1_sw <= i_sw;
end

reg		dly2_sw			;
always @(posedge clk) begin
	dly2_sw <= dly1_sw;
end

assign		o_sw = dly1_sw | ~dly2_sw;

endmodule

//	--------------------------------------------------
//	Clock Controller
//	--------------------------------------------------
module	controller(
		o_mode,
		o_position,
		o_alarm_en,
		o_alarm_spark_en,
		o_stw_en,
		o_sec_clk,
		o_min_clk,
		o_hour_clk,
		o_alarm_sec_clk,
		o_alarm_min_clk,
		o_alarm_hour_clk,
		o_stw_sec_clk,
		o_stw_min_clk,
		o_stw_hour_clk,
		i_max_hit_sec,
		i_max_hit_min,
		i_max_hit_hour,
		i_max_hit_stw_sec,
		i_max_hit_stw_min,
		i_max_hit_stw_hour,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		i_sw4, // for stopwatch 'stop/start'
		i_sw5, // for stopwatch 'reset'
		clk,
		rst_n);

output	[1:0]	o_mode			; // 000 clk, 001 setup, 010 alarm, 011 stopwatch, 100 timer [2:0]
output	[1:0]	o_position		; // 00 sec, 01 min, 10 hour
output		o_alarm_en		;
output		o_alarm_spark_en	;
output		o_stw_en		;
output		o_sec_clk		;
output		o_min_clk		;
output		o_hour_clk		;
output		o_alarm_sec_clk		;
output		o_alarm_min_clk		;
output		o_alarm_hour_clk	;
output		o_stw_sec_clk		;
output		o_stw_min_clk		;
output		o_stw_hour_clk		;

input		i_max_hit_sec		;
input		i_max_hit_min		;
input		i_max_hit_hour		;
input		i_max_hit_stw_sec	;
input		i_max_hit_stw_min	;
input		i_max_hit_stw_hour	;

input		i_sw0			;
input		i_sw1			;
input		i_sw2			;
input		i_sw3			;
input		i_sw4			;
input 		i_sw5			;

input		clk			;
input		rst_n			;

parameter	MODE_CLOCK	= 2'b00	; //3'b000
parameter	MODE_SETUP	= 2'b01	; //3'b001
parameter	MODE_ALARM	= 2'b10	; //3'b010
parameter 	MODE_STOPWATCH 	= 2'b11 ; //3'b011
//MODE_TIMER = 3'b100  
parameter	POS_SEC		= 2'b00	;
parameter	POS_MIN		= 2'b01	;
parameter	POS_HOUR	= 2'b10	;
//parameter 	RESET 		= 1'b0	;


//nco for debounce
wire		clk_100hz		;
nco		u0_nco(
		.o_gen_clk	( clk_100hz	),
		.i_nco_num	( 32'd500000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

wire		sw0			;
debounce	u0_debounce(
		.o_sw		( sw0		),
		.i_sw		( i_sw0		),
		.clk		( clk_100hz	));

wire		sw1			;
debounce	u1_debounce(
		.o_sw		( sw1		),
		.i_sw		( i_sw1		),
		.clk		( clk_100hz	));

wire		sw2			;
debounce	u2_debounce(
		.o_sw		( sw2		),
		.i_sw		( i_sw2		),
		.clk		( clk_100hz	));

wire		sw3			;
debounce	u3_debounce(
		.o_sw		( sw3		),
		.i_sw		( i_sw3		),
		.clk		( clk_100hz	));
		
wire		sw4			;
debounce	u4_debounce(
		.o_sw		( sw4		),
		.i_sw		( i_sw4		),
		.clk		( clk_100hz	));
	
wire		sw5			;
debounce	u5_debounce(
		.o_sw		( sw5		),
		.i_sw		( i_sw5		),
		.clk		( clk_100hz	)); 

reg	[1:0]	o_mode			; 
always @(posedge sw0 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_mode <= MODE_CLOCK;
	end else begin
		if (o_mode >= MODE_STOPWATCH) begin
			o_mode <= MODE_CLOCK;
		end else begin
			o_mode <= o_mode + 1'b1;
		end
	end
end

reg	[1:0]	o_position		;
always @(posedge sw1 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_position <= POS_SEC;
	end else begin
		if(o_position >= POS_HOUR) begin
			o_position <= POS_SEC;
		end else begin
			o_position <= o_position + 1'b1;
		end
	end
end

reg	o_stw_en		;

always @(posedge sw4) begin
	o_stw_en <= ~o_stw_en	;
end
// stopwatch 'stop' & 'start'

/*reg	o_stw_rst		;
always @(posedge sw5) begin
	o_stw_rst <= ~o_stw_rst	;
end*/
// stopwatch 'reset'

reg		o_alarm_en	;
reg		o_alarm_spark_en;
always @(posedge sw3 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_alarm_en <= 1'b0;
		o_alarm_spark_en <= 1'b0;
	end else begin
		o_alarm_en <= o_alarm_en + 1'b1 ;
		o_alarm_spark_en <= o_alarm_spark_en + 1'b1;
	end
end


wire		clk_1hz			;
nco		u1_nco(
		.o_gen_clk	( clk_1hz	),
		.i_nco_num	( 32'd50000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg		o_sec_clk		;
reg		o_min_clk		;
reg		o_hour_clk		;
reg		o_alarm_sec_clk		;
reg		o_alarm_min_clk		;
reg		o_alarm_hour_clk	;
reg		o_stw_sec_clk		;
reg		o_stw_min_clk		;
reg		o_stw_hour_clk		;

always @(*) begin
	case(o_mode)
		MODE_CLOCK : begin
			if(o_stw_en == 1'b1) begin
				o_sec_clk = clk_1hz			;
				o_min_clk = i_max_hit_sec		;
				o_hour_clk = i_max_hit_min		;
				o_alarm_sec_clk = 1'b0			;
				o_alarm_min_clk = 1'b0			;
				o_alarm_hour_clk = 1'b0			;
				o_stw_sec_clk	= clk_1hz		;
				o_stw_min_clk	= i_max_hit_stw_sec	;
				o_stw_hour_clk	= i_max_hit_stw_min	;
			end else begin
				o_sec_clk = clk_1hz			;
				o_min_clk = i_max_hit_sec		;
				o_hour_clk = i_max_hit_min		;
				o_alarm_sec_clk = 1'b0			;
				o_alarm_min_clk = 1'b0			;
				o_alarm_hour_clk = 1'b0			;
				o_stw_sec_clk	= 1'b0			;
				o_stw_min_clk	= 1'b0			;
				o_stw_hour_clk	= 1'b0			;
			end
		end
		MODE_SETUP : begin
			case(o_position)
				POS_SEC : begin
					if(o_stw_en == 1'b1) begin
						o_sec_clk = ~sw2	;
						o_min_clk = 1'b0	;
						o_hour_clk = 1'b0	;
						o_alarm_sec_clk = 1'b0	;
						o_alarm_min_clk = 1'b0	;
						o_alarm_hour_clk = 1'b0	;
						o_stw_sec_clk	= clk_1hz		;
						o_stw_min_clk	= i_max_hit_stw_sec	;
						o_stw_hour_clk	= i_max_hit_stw_min	;
					end else begin
						o_sec_clk = ~sw2	;
						o_min_clk = 1'b0	;
						o_hour_clk = 1'b0	;
						o_alarm_sec_clk = 1'b0	;
						o_alarm_min_clk = 1'b0	;
						o_alarm_hour_clk = 1'b0	;
						o_stw_sec_clk	= 1'b0	;
						o_stw_min_clk	= 1'b0	;
						o_stw_hour_clk	= 1'b0	;
					end
				end
				POS_MIN : begin
					if(o_stw_en == 1'b1) begin
						o_sec_clk = 1'b0	;
						o_min_clk = ~sw2	;
						o_hour_clk = 1'b0	;
						o_alarm_sec_clk = 1'b0	;
						o_alarm_min_clk = 1'b0	;
						o_alarm_hour_clk = 1'b0	;
						o_stw_sec_clk	= clk_1hz		;
						o_stw_min_clk	= i_max_hit_stw_sec	;
						o_stw_hour_clk	= i_max_hit_stw_min	;
					end else begin
						o_sec_clk = 1'b0	;
						o_min_clk = ~sw2	;
						o_hour_clk = 1'b0	;
						o_alarm_sec_clk = 1'b0	;
						o_alarm_min_clk = 1'b0	;
						o_alarm_hour_clk = 1'b0	;
						o_stw_sec_clk	= 1'b0	;
						o_stw_min_clk	= 1'b0	;
						o_stw_hour_clk	= 1'b0	;
					end
				end
				POS_HOUR : begin
					if(o_stw_en == 1'b1) begin
						o_sec_clk = 1'b0	;
						o_min_clk = 1'b0	;
						o_hour_clk = ~sw2	;
						o_alarm_sec_clk = 1'b0	;
						o_alarm_min_clk = 1'b0	;
						o_alarm_hour_clk = 1'b0	;
						o_stw_sec_clk	= clk_1hz		;
						o_stw_min_clk	= i_max_hit_stw_sec	;
						o_stw_hour_clk	= i_max_hit_stw_min	;
					end else begin
						o_sec_clk = 1'b0	;
						o_min_clk = 1'b0	;
						o_hour_clk = ~sw2	;
						o_alarm_sec_clk = 1'b0	;
						o_alarm_min_clk	= 1'b0	;
						o_alarm_hour_clk = 1'b0	;
						o_stw_sec_clk	= 1'b0	;
						o_stw_min_clk	= 1'b0	;
						o_stw_hour_clk	= 1'b0	;
					end
				end
			endcase
		end
		MODE_ALARM : begin
			case(o_position)
				POS_SEC : begin
					if(o_stw_en == 1'b1) begin 
						o_sec_clk = clk_1hz		;
						o_min_clk = i_max_hit_sec	;	
						o_hour_clk = i_max_hit_min	;
						o_alarm_sec_clk = ~sw2		;
						o_alarm_min_clk = 1'b0		;
						o_alarm_hour_clk = 1'b0		;
						o_stw_sec_clk	= clk_1hz		;
						o_stw_min_clk	= i_max_hit_stw_sec	;
						o_stw_hour_clk	= i_max_hit_stw_min	;
					end else begin
						o_sec_clk = clk_1hz		;
						o_min_clk = i_max_hit_sec	;	
						o_hour_clk = i_max_hit_min	;
						o_alarm_sec_clk = ~sw2		;
						o_alarm_min_clk = 1'b0		;
						o_alarm_hour_clk = 1'b0		;
						o_stw_sec_clk	= 1'b0		;
						o_stw_min_clk	= 1'b0		;
						o_stw_hour_clk	= 1'b0		;
					end
				end
				POS_MIN : begin
					if(o_stw_en == 1'b1) begin 
						o_sec_clk = clk_1hz		;
						o_min_clk = i_max_hit_sec	;	
						o_hour_clk = i_max_hit_min	;
						o_alarm_sec_clk = 1'b0		;
						o_alarm_min_clk = ~sw2		;
						o_alarm_hour_clk = 1'b0		;
						o_stw_sec_clk	= clk_1hz		;
						o_stw_min_clk	= i_max_hit_stw_sec	;
						o_stw_hour_clk	= i_max_hit_stw_min	;
					end else begin
						o_sec_clk = clk_1hz		;
						o_min_clk = i_max_hit_sec	;	
						o_hour_clk = i_max_hit_min	;
						o_alarm_sec_clk = 1'b0		;
						o_alarm_min_clk = ~sw2		;
						o_alarm_hour_clk = 1'b0		;
						o_stw_sec_clk	= 1'b0	;
						o_stw_min_clk	= 1'b0	;
						o_stw_hour_clk	= 1'b0	;
					end
				end
				POS_HOUR : begin
					if(o_stw_en == 1'b1) begin 
						o_sec_clk = clk_1hz		;
						o_min_clk = i_max_hit_sec	;	
						o_hour_clk = i_max_hit_min	;
						o_alarm_sec_clk = 1'b0		;
						o_alarm_min_clk = 1'b0		;
						o_alarm_hour_clk = ~sw2		;
						o_stw_sec_clk	= clk_1hz		;
						o_stw_min_clk	= i_max_hit_stw_sec	;
						o_stw_hour_clk	= i_max_hit_stw_min	;
					end else begin
						o_sec_clk = clk_1hz		;
						o_min_clk = i_max_hit_sec	;	
						o_hour_clk = i_max_hit_min	;
						o_alarm_sec_clk = 1'b0		;
						o_alarm_min_clk = 1'b0		;
						o_alarm_hour_clk = ~sw2		;
						o_stw_sec_clk	= 1'b0	;
						o_stw_min_clk	= 1'b0	;
						o_stw_hour_clk	= 1'b0	;
					end
				end
			endcase
		end
		MODE_STOPWATCH : begin
		  	if(o_stw_en == 1'b1) begin
				o_sec_clk = clk_1hz			;
				o_min_clk = i_max_hit_sec		;
				o_hour_clk = i_max_hit_min		;
				o_alarm_sec_clk = 1'b0			;
				o_alarm_min_clk = 1'b0			;
				o_alarm_hour_clk = 1'b0			;
				o_stw_sec_clk	= clk_1hz		;
				o_stw_min_clk	= i_max_hit_stw_sec	;
				o_stw_hour_clk	= i_max_hit_stw_min	;
			end else begin
				o_sec_clk = clk_1hz			;
				o_min_clk = i_max_hit_sec		;
				o_hour_clk = i_max_hit_min		;
				o_alarm_sec_clk = 1'b0			;
				o_alarm_min_clk = 1'b0			;
				o_alarm_hour_clk = 1'b0			;
				o_stw_sec_clk	= 1'b0			;
				o_stw_min_clk	= 1'b0			;
				o_stw_hour_clk	= 1'b0			;
			end
		end
	//	MODE_TIMER

		default: begin
			o_sec_clk = 1'b0		;
			o_min_clk = 1'b0		;
			o_hour_clk = 1'b0		;
			o_alarm_sec_clk = 1'b0		;
			o_alarm_min_clk = 1'b0		;
			o_alarm_hour_clk = 1'b0		;
			o_stw_sec_clk	 = 1'b0		;
			o_stw_min_clk	 = 1'b0		;
			o_stw_hour_clk = 1'b0		;	
		end
	endcase
end
endmodule
//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hrminsec(	
		o_hour,
		o_min,
		o_sec,
		o_max_hit_sec,
		o_max_hit_min,
		o_max_hit_hour,
		o_max_hit_stw_sec,
		o_max_hit_stw_min,
		o_max_hit_stw_hour,
		o_alarm,
		o_alarm_spark,
		i_mode,
		i_position,
		i_sec_clk,
		i_min_clk,
		i_hour_clk,
		i_alarm_sec_clk,
		i_alarm_min_clk,
		i_alarm_hour_clk,
		i_alarm_en,
		i_alarm_spark_en,
		i_stw_sec_clk,
		i_stw_min_clk,
		i_stw_hour_clk,
		clk,
		rst_n);


output	[5:0]	o_sec		;
output	[5:0]	o_min		;
output	[5:0]	o_hour		;


output		o_max_hit_sec	;
output		o_max_hit_min	;
output		o_max_hit_hour	;

output		o_max_hit_stw_sec;
output		o_max_hit_stw_min;
output		o_max_hit_stw_hour;

output		o_alarm		;
output		o_alarm_spark	;

input	[1:0]	i_mode		;
input	[1:0]	i_position	;

input		i_sec_clk	;
input		i_min_clk	;
input		i_hour_clk	;

input		i_alarm_sec_clk	;
input		i_alarm_min_clk	;
input		i_alarm_hour_clk;

input		i_stw_sec_clk	;
input		i_stw_min_clk	;
input		i_stw_hour_clk;

input		i_alarm_en	;
input		i_alarm_spark_en;

input		clk		;
input		rst_n		;

parameter	MODE_CLOCK	= 2'b00	; //3'b000
parameter	MODE_SETUP	= 2'b01	; //3'b001
parameter	MODE_ALARM	= 2'b10	; //3'b010
parameter 	MODE_STOPWATCH 	= 2'b11 ; //3'b011
//MODE_TIMER = 3'b100  
parameter	POS_SEC		= 2'b00	;
parameter	POS_MIN		= 2'b01	;
parameter	POS_HOUR	= 2'b10	;
//parameter 	RESET 		= 1'b0	;




//	MODE_CLOCK
wire	[5:0]	sec		;
wire		max_hit_sec	;
hms_cnt		u_hms_cnt_sec(
		.o_hms_cnt	( sec			),
		.o_max_hit	( o_max_hit_sec		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_sec_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	min		;
wire		max_hit_min	;
hms_cnt		u_hms_cnt_min(
		.o_hms_cnt	( min			),
		.o_max_hit	( o_max_hit_min		),
		.i_max_cnt	( 6'd59			),
		.clk		( i_min_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	hour		;
wire		max_hit_hour	;
hms_cnt		u_hms_cnt_hour(
		.o_hms_cnt	( hour			),
		.o_max_hit	( o_max_hit_hour	),
		.i_max_cnt	( 6'd23			),
		.clk		( i_hour_clk		),
		.rst_n		( rst_n			));

//	MODE_ALARM
wire	[5:0]	alarm_sec	;
hms_cnt		u_hms_cnt_alarm_sec(
		.o_hms_cnt	( alarm_sec		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_min	;
hms_cnt		u_hms_cnt_alarm_min(
		.o_hms_cnt	( alarm_min		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_min_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_hour	;
hms_cnt		u_hms_cnt_alarm_hour(
		.o_hms_cnt	( alarm_hour		),
		.o_max_hit	( 			),
		.i_max_cnt	( 6'd23			),
		.clk		( i_alarm_hour_clk	),
		.rst_n		( rst_n			));

//	MODE TIMER
wire	[5:0]	stw_sec		;
hms_cnt		u_hms_stw_sec(
		.o_hms_cnt	( stw_sec		),
		.o_max_hit	( o_max_hit_stw_sec	),
		.i_max_cnt	( 6'd59			),
		.clk		( i_stw_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	stw_min		;
hms_cnt		u_hms_stw_min(
		.o_hms_cnt	( stw_min		),
		.o_max_hit	( o_max_hit_stw_min	),
		.i_max_cnt	( 6'd59			),
		.clk		( i_stw_min_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	stw_hour		;
hms_cnt		u_hms_stw_hour(
		.o_hms_cnt	( stw_hour		),
		.o_max_hit	( o_max_hit_stw_hour	),
		.i_max_cnt	( 6'd23			),
		.clk		( i_stw_hour_clk	),
		.rst_n		( rst_n			));

 
reg	[5:0]	o_sec		;
reg	[5:0]	o_min		;
reg	[5:0]	o_hour		;

always @ (*) begin
	case(i_mode)
		MODE_CLOCK: 	begin
			o_sec	= sec;
			o_min	= min;
			o_hour	= hour;
		end
		MODE_SETUP:	begin
			o_sec	= sec;
			o_min	= min;
			o_hour	= hour;
		end
		MODE_ALARM:	begin
			o_sec	= alarm_sec;
			o_min	= alarm_min;
			o_hour	= alarm_hour;
		end
		MODE_STOPWATCH:	begin
			o_sec	= stw_sec;
			o_min	= stw_min;
			o_hour	= stw_hour;
		end

	endcase
end

reg		o_alarm		;
always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		o_alarm <= 1'b0;
	end else begin
		if((sec == alarm_sec) && (min == alarm_min) && (hour == alarm_hour)) begin
			o_alarm <= 1'b1 & i_alarm_en;
		end else begin
			o_alarm <= o_alarm & i_alarm_en;
		end
	end
end

reg		o_alarm_spark		;
always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		o_alarm_spark <= 1'b0;
	end else begin
		if( /*spark*/ ) begin
			o_alarm_spark <= 1'b1 & i_alarm_spark_en;
		end else begin
			o_alarm_spark <= o_alarm_spark & i_alarm_spark_en;
		end
	end
end

endmodule

module	buzz(
		o_buzz,
		o_alarm,
		i_buzz_en,
		i_buzz_spark_en,
		clk,
		rst_n);

output		o_buzz		;

input		o_alarm		;
input		i_buzz_en	;
input		i_buzz_spark_en	;
input		clk		;
input		rst_n		;

parameter	C = 47778	;
parameter	D = 85131	;
parameter	E = 75843	;
parameter	F = 67569	;
parameter	G = 63776	;
parameter	A = 56818	;
parameter	B = 50619	;
parameter	O = 1000	;

wire		clk_alarm_beat	;
nco_alarm		u_alarm_beat(	
			.o_gen_clk	( clk_alarm_beat),
			.i_nco_num	( 25000000	),
			.clk		( clk		),
			.rst_n		( rst_n		));

wire		clk_spark_beat	;
nco_spark		u_spark_beat(	
			.o_gen_clk	( clk_spark_beat),
			.i_nco_num	( 25000000	),
			.clk		( clk		),
			.rst_n		( rst_n		));

reg	[5:0]	cnt		;
always @ (posedge clk_alarm_beat or negedge i_buzz_en ) begin
	if(i_buzz_en == 1'b0) begin
		cnt <= 6'd00;
	end else begin
		if(cnt >= 6'd49) begin
			cnt <= 6'd0;
		end else begin
			cnt <= cnt + 1'd1;
		end
	end
end

reg	[5:0]	cnt_spark	;
always @ (posedge clk_spark_beat or negedge i_buzz_spark_en ) begin
	if(i_buzz_spark_en == 1'b0) begin
		cnt_spark <= 6'd00;
	end else begin
		if( cnt_spark >= 6'd49) begin
			cnt_spark <= 6'd0;
		end else begin
			cnt_spark <= cnt_spark + 1'd1;
		end
	end
end

reg	[15:0]	nco_num		;
always @ (*) begin
	case(cnt)
		6'd00: nco_num = D	;
		6'd01: nco_num = D	;
		6'd02: nco_num = G	;
		6'd03: nco_num = G	;

		6'd04: nco_num = G	;
		6'd05: nco_num = A	;
		6'd06: nco_num = G	;
		6'd07: nco_num = F	;

		6'd08: nco_num = E	;
		6'd09: nco_num = E	;
		6'd10: nco_num = E	;
		6'd11: nco_num = E	;


		6'd12: nco_num = E	;
		6'd13: nco_num = E	;
		6'd14: nco_num = A	;
		6'd15: nco_num = A	;

		6'd16: nco_num = A	;
		6'd17: nco_num = B	;
		6'd18: nco_num = A	;
		6'd19: nco_num = G	;

		6'd20: nco_num = F	;
		6'd21: nco_num = F	;
		6'd22: nco_num = D	;
		6'd23: nco_num = D	;
		

		6'd24: nco_num = D	;
		6'd25: nco_num = D	;
		6'd26: nco_num = B	;
		6'd27: nco_num = B	;

		6'd28: nco_num = B	;
		6'd29: nco_num = C	;
		6'd30: nco_num = B	;
		6'd31: nco_num = A	;

		6'd32: nco_num = G	;
		6'd33: nco_num = G	;
		6'd34: nco_num = E	;
		6'd35: nco_num = E	;

		6'd36: nco_num = D	;
		6'd37: nco_num = D	;

		6'd38: nco_num = E	;
		6'd39: nco_num = E	;
		6'd40: nco_num = A	;
		6'd41: nco_num = A	;
		6'd42: nco_num = F	;
		6'd43: nco_num = F	;

		6'd44: nco_num = G	;
		6'd45: nco_num = G	;
		6'd46: nco_num = G	;
		6'd47: nco_num = G	;
		6'd48: nco_num = O	;
		6'd49: nco_num = O	;

	endcase
end

reg	[15:0]	nco_num_spark	;
always @ (*) begin
	case(cnt_spark)
		6'd00: nco_num_spark = D	;
		6'd01: nco_num_spark = D	;
		6'd02: nco_num_spark = G	;
		6'd03: nco_num_spark = G	;

		6'd04: nco_num_spark = G	;
		6'd05: nco_num_spark = A	;
		6'd06: nco_num_spark = G	;
		6'd07: nco_num_spark = F	;

		6'd08: nco_num_spark = E	;
		6'd09: nco_num_spark = E	;
		6'd10: nco_num_spark = E	;
		6'd11: nco_num_spark = E	;


		6'd12: nco_num_spark = E	;
		6'd13: nco_num_spark = E	;
		6'd14: nco_num_spark = A	;
		6'd15: nco_num_spark = A	;

		6'd16: nco_num_spark = A	;
		6'd17: nco_num_spark = B	;
		6'd18: nco_num_spark = A	;
		6'd19: nco_num_spark = G	;

		6'd20: nco_num_spark = F	;
		6'd21: nco_num_spark = F	;
		6'd22: nco_num_spark = D	;
		6'd23: nco_num_spark = D	;
		
		6'd24: nco_num_spark = D	;
		6'd25: nco_num_spark = D	;
		6'd26: nco_num_spark = B	;
		6'd27: nco_num_spark = B	;

		6'd28: nco_num_spark = B	;
		6'd29: nco_num_spark = C	;
		6'd30: nco_num_spark = B	;
		6'd31: nco_num_spark = A	;

		6'd32: nco_num_spark = G	;
		6'd33: nco_num_spark = G	;
		6'd34: nco_num_spark = E	;
		6'd35: nco_num_spark = E	;

		6'd36: nco_num_spark = D	;
		6'd37: nco_num_spark = D	;

		6'd38: nco_num_spark = E	;
		6'd39: nco_num_spark = E	;
		6'd40: nco_num_spark = A	;
		6'd41: nco_num_spark = A	;
		6'd42: nco_num_spark = F	;
		6'd43: nco_num_spark = F	;

		6'd44: nco_num_spark = G	;
		6'd45: nco_num_spark = G	;
		6'd46: nco_num_spark = G	;
		6'd47: nco_num_spark = G	;
		6'd48: nco_num_spark = O	;
		6'd49: nco_num_spark = O	;

	endcase
end

wire		buzz		;
nco		u_nco_buzz(	
		.o_gen_clk	( buzz		),
		.i_nco_num	( nco_num	),
		.clk		( clk		),
		.rst_n		( rst_n		));

wire		spark		;
nco_spark	u_nco_spark(	
		.o_gen_clk	( spark		),
		.i_nco_num	( nco_num_spark	),
		.clk		( clk		),
		.rst_n		( rst_n		));

assign		o_buzz_alarm = buzz & i_buzz_en		;
assign		o_buzz_spark = spark & i_buzz_spark_en	;

assign		o_buzz = o_buzz_alarm | o_buzz_spark 	;

endmodule

module	top_project(
		o_seg_enb,
		o_seg_dp,
		o_seg,
		o_alarm,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		i_sw4,
		i_sw5,
		clk,
		rst_n);

output	[5:0]	o_seg_enb	;
output		o_seg_dp	;
output	[6:0]	o_seg		;
output		o_alarm		;

input		i_sw0		;
input		i_sw1		;
input		i_sw2		;
input		i_sw3		;
input		i_sw4		;
input		i_sw5		;
input		clk		;
input		rst_n		;

wire		controller_1	;
wire		controller_2	;
wire		controller_3	;
wire		controller_4	;
wire		controller_5	;
wire		controller_6	;
wire		controller_7	;
wire		controller_8	;
wire		controller_9	;

wire	[1:0]	mode		;
wire	[1:0]	position	;
wire		alarm_en	;
wire		timer_en	;
wire		alarm_hour_clk	;
wire		alarm_min_clk	;
wire		alarm_sec_clk	;
wire		stw_hour_clk	;
wire		stw_min_clk	;
wire		stw_sec_clk	;



controller		u_ctrl(
			.i_sw0			(i_sw0		),
			.i_sw1			(i_sw1		),
			.i_sw2			(i_sw2		),
			.i_sw3			(i_sw3		),
			.i_sw4			(i_sw4		),
			.i_sw5			(i_sw5		),
			.clk			(clk		),
			.i_max_hit_hour		(controller_5	),
			.i_max_hit_min		(controller_3	),
			.i_max_hit_sec		(controller_4	),
			.i_max_hit_stw_hour	(controller_7	),
			.i_max_hit_stw_min	(controller_8	),
			.i_max_hit_stw_sec	(controller_9	),
			.o_mode			(mode		),
			.o_position		(position	),
			.o_stw_sec_clk		(stw_sec_clk	),
			.o_stw_min_clk		(stw_min_clk	),
			.o_stw_hour_clk		(stw_hour_clk	),
			.o_alarm_en		(alarm_en	),
			.o_alarm_spark_en	(alarm_spark_en	),
			.o_stw_en		(stw_en		),
			.o_alarm_hour_clk	(alarm_hour_clk	),
			.o_alarm_min_clk	(alarm_min_clk	),
			.o_alarm_sec_clk	(alarm_sec_clk	),
			.o_hour_clk		(controller_6	),
			.o_min_clk		(controller_1	),
			.o_sec_clk		(controller_2	),
			.rst_n			(rst_n		));

wire	[5:0]	hrminsec_1	;
wire	[5:0]	hrminsec_2	;
wire	[5:0]	hrminsec_3	;

wire		alarm		;
wire		alarm_spark	;
wire		stw		;


hrminsec		u_hrminsec(
			.clk			(clk		),
			.i_hour_clk		(controller_6	),
			.i_min_clk		(controller_1	),
			.i_sec_clk		(controller_2	),
			.i_mode			(mode		),
			.i_position		(position	),
			.i_alarm_en		(alarm_en	),
			.i_alarm_spark_en	(alarm_spark_en	),
			.i_alarm_hour_clk	(alarm_hour_clk	),
			.i_alarm_min_clk	(alarm_min_clk	),
			.i_alarm_sec_clk	(alarm_sec_clk	),
			.i_stw_sec_clk		(stw_sec_clk	),
			.i_stw_min_clk		(stw_min_clk	),
			.i_stw_hour_clk		(stw_hour_clk	),
			.o_alarm		(alarm		),
			.o_alarm_spark		(alarm_spark	),
			.o_hour			(hrminsec_3	),
			.o_min			(hrminsec_2	),
			.o_sec			(hrminsec_1	),
			.o_max_hit_hour		(controller_5	),
			.o_max_hit_min		(controller_3	),
			.o_max_hit_sec		(controller_4	),
			.o_max_hit_stw_hour	(controller_7	),
			.o_max_hit_stw_min	(controller_8	),
			.o_max_hit_stw_sec	(controller_9	),
			.rst_n			(rst_n		));

buzz			u_buzz(
			.clk			(clk		),
			.i_buzz_en		(alarm		),
			.i_buzz_spark_en	(alarm_spark	),
			.o_buzz			(o_alarm	),
			.rst_n			(rst_n		));

//sec

wire	[3:0]	left_1	;
wire	[3:0]	right_1	;

double_fig_sep		u0_dfs(
			.i_double_fig	(hrminsec_1	),
			.o_left		(left_1		),
			.o_right	(right_1	));

//min

wire	[3:0]	left_2	;
wire	[3:0]	right_2	;

double_fig_sep		u1_dfs(
			.i_double_fig	(hrminsec_2	),
			.o_left		(left_2		),
			.o_right	(right_2	));

//hour

wire	[3:0]	left_3	;
wire	[3:0]	right_3	;

double_fig_sep		u2_dfs(
			.i_double_fig	(hrminsec_3	),
			.o_left		(left_3		),
			.o_right	(right_3	));



//sec

wire	[6:0]	sec_left	;
wire	[6:0]	sec_right	;

fnd_dec			u0_fnd_dec(
			.i_num		(left_1		),
			.o_seg		(sec_left	));

fnd_dec			u1_fnd_dec(
			.i_num		(right_1	),
			.o_seg		(sec_right	));

//min

wire	[6:0]	min_left	;
wire	[6:0]	min_right	;

fnd_dec			u2_fnd_dec(
			.i_num		(left_2		),
			.o_seg		(min_left	));

fnd_dec			u3_fnd_dec(
			.i_num		(right_2	),
			.o_seg		(min_right	));

//hour

wire	[6:0]	hour_left	;
wire	[6:0]	hour_right	;

fnd_dec			u4_fnd_dec(
			.i_num		(left_3		),
			.o_seg		(hour_left	));

fnd_dec			u5_fnd_dec(
			.i_num		(right_3	),
			.o_seg		(hour_right	));

wire	[41:0]	six_digit_seg		;

assign		six_digit_seg ={ hour_left, hour_right, min_left, min_right, sec_left, sec_right };

led_disp	u_led_disp(
				.o_seg		(o_seg		),
				.o_seg_dp	(o_seg_dp	),
				.o_seg_enb	(o_seg_enb	),
				.i_mode		(mode		),	
				.i_position	(position	),				
				.i_six_digit_seg(six_digit_seg	),
				.clk		(clk		),
				.rst_n		(rst_n		));

endmodule
