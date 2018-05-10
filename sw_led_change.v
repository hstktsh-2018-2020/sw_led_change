`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:11 04/13/2018 
// Design Name: 
// Module Name:    sw_led_change 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sw_led_change(
	 input   CLK,
	 input	PSW0,
	 output  LED0,
	 output  LED1,
	 output  LED2
    );
	
	reg [6:0]	base_cycle_counter_reg = 7'h00;
	reg [15:0]	count_base_reg = 16'h0000;
	
	reg [19:0]	count_reg = 20'h00000;
	reg [1:0]	psw0_reg = 2'h0;
	reg [2:0]	psw0_smp_reg = 3'h0;
	reg 			psw0_filt_reg = 1'h0;
	reg [6:0]	select_trans_reg = 7'h00;	

//LED用

	//メタステーブル対策用
	always @(posedge CLK) begin
		psw0_reg <={psw0_reg[0],PSW0};
	end
	
	//低速サンプリング用パルス生成部
	always @(posedge CLK) begin
		if (count_reg[19] == 1'b1) begin
			count_reg <= 20'd0;
		end
		else begin
			count_reg <= count_reg + 1'b1;
		end
	end
	
	//低速サンプリング部
	always @(posedge CLK) begin
		if (count_reg[19] == 1'b1) begin	
			psw0_smp_reg <= {psw0_smp_reg[1:0], psw0_reg[1]};
		end
	end
	
	assign psw0_filt = (~psw0_smp_reg[0] &  psw0_smp_reg[1] &  psw0_smp_reg[2]) |
							( psw0_smp_reg[0] & ~psw0_smp_reg[1] &  psw0_smp_reg[2]) |
							( psw0_smp_reg[0] &  psw0_smp_reg[1] & ~psw0_smp_reg[2]) |
							( psw0_smp_reg[0] &  psw0_smp_reg[1] &  psw0_smp_reg[2]) ;
					
	//微分回路
	always @(posedge CLK) begin
		psw0_filt_reg <= psw0_filt;
	end
	
	assign psw0_filt_pos = psw0_filt & (~psw0_filt_reg);
	
	always @(posedge CLK) begin
		if (psw0_filt_pos == 1'b1) begin
			select_trans_reg <= select_trans_reg + 1'b1;
		end
	end

//↑LED用




	//メタステーブル対策用
	always @(posedge CLK) begin
		psw0_reg <={psw0_reg[0],PSW0};
	end
	
	//低速サンプリング用パルス生成部
	always @(posedge CLK) begin
		if (count_reg[19] == 1'b1) begin
			count_reg <= 20'd0;
		end
		else begin
			count_reg <= count_reg + 1'b1;
		end
	end
	
	//低速サンプリング部
	always @(posedge CLK) begin
		if (count_reg[19] == 1'b1) begin	
			psw0_smp_reg <= {psw0_smp_reg[1:0], psw0_reg[1]};
		end
	end
	
	assign psw0_filt = (~psw0_smp_reg[0] &  psw0_smp_reg[1] &  psw0_smp_reg[2]) |
							( psw0_smp_reg[0] & ~psw0_smp_reg[1] &  psw0_smp_reg[2]) |
							( psw0_smp_reg[0] &  psw0_smp_reg[1] & ~psw0_smp_reg[2]) |
							( psw0_smp_reg[0] &  psw0_smp_reg[1] &  psw0_smp_reg[2]) ;
					
	//微分回路
	always @(posedge CLK) begin
		psw0_filt_reg <= psw0_filt;
	end
	
	assign psw0_filt_pos = psw0_filt & (~psw0_filt_reg);
	
	always @(posedge CLK) begin
		if (psw0_filt_pos == 1'b1) begin
			select_trans_reg <= select_trans_reg + 1'b1;
		end
	end
		
	assign LED0 = (select_trans_reg[6:0] == 7'd0)? 1'b1 :  (select_trans_reg[6:0] == 7'd1)? 1'b0 : 1'b0 ;
	assign LED1 = (select_trans_reg[6:0] == 7'd1)? 1'b1 : (select_trans_reg[6:0] == 7'd3)? 1'b1:1'b0 ;
	assign LED2 = (select_trans_reg[6:0] == 7'd2)? 1'b1 : 1'b0 ;

endmodule
