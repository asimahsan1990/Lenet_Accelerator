/**
 * Editor : Steven
 * File : fc_controller.v
 */
module fc_controller#(
	parameter WEIGHT_WIDTH = 4,
    parameter WEIGHT_NUM = 20,
    parameter DATA_WIDTH = 8,
    parameter DATA_NUM_PER_SRAM_ADDR = 4,
    parameter WEIGHT_ADDR_WIDTH = 15
)
(
input clk,
input srstn,

input conv_done,					//connect to conv_done from CONV
input mem_sel,						//mem_sel = 1: FC reads c, mem_sel = 0: FC reads d

output reg accumulate_reset,		//connect to multiplier_accumulator
output reg fc_state,
output reg [1:0] sram_sel,			//select to read sram c, sram d or sram e

//Read c/d sram addr
output [9:0] sram_raddr_c0,
output [9:0] sram_raddr_c1,
output [9:0] sram_raddr_c2,
output [9:0] sram_raddr_c3,
output [9:0] sram_raddr_c4,
output [9:0] sram_raddr_d0,
output [9:0] sram_raddr_d1,
output [9:0] sram_raddr_d2,
output [9:0] sram_raddr_d3,
output [9:0] sram_raddr_d4,
output [9:0] sram_raddr_e0,
output [9:0] sram_raddr_e1,
output [9:0] sram_raddr_e2,
output [9:0] sram_raddr_e3,
output [9:0] sram_raddr_e4,

//write_enable of sram e series 
output reg sram_write_enable_e0,
output reg sram_write_enable_e1,
output reg sram_write_enable_e2,
output reg sram_write_enable_e3,
output reg sram_write_enable_e4,

//write_enable of sram f 
output reg sram_write_enable_f,

//write addr and mask
output reg [9:0] sram_waddr,		//addr for writing to sram e and f
output reg [3:0] sram_bytemask,		//mask for writing to sram e and f

//sram weight addr
output [WEIGHT_ADDR_WIDTH-1:0] sram_raddr_weight,

//fc_done signal
output reg fc1_done,
output reg fc2_done
);

localparam IDLE = 0, PRE_FETCH = 1, FC_1 = 2, FC_2 = 3, DONE = 4;

//FSM
reg [2:0] state, n_state;

//conv_done signal record
reg conv_done_record, n_conv_done_record;

//switch signal
reg fetch_data_start;
reg fetch_done, n_fetch_done;
reg n_fc1_done;									
reg n_fc2_done;									
reg busy, n_busy;				//1: busy, 0: idle

/************************************************
counter: 										*
------------------------------------------------*
data addr cnt:									*
col_cnt(fc1: 0~499; fc2: 0~9;)					*
row_cnt(20 rows as a set; fc1: 0~39; fc2: 0~24)	*
												*
weight addr cnt:								*
weight_cnt(fc1: 0~19999; fc2: 20000~20249;)		*
												*
state (delay) cnt:								* 
*************************************************/
reg [5:0] row_cnt, n_row_cnt, row_cnt_getdata, row_cnt_multi, row_cnt_quantize;
reg [8:0] col_cnt, n_col_cnt, col_cnt_getdata, col_cnt_multi, col_cnt_quantize, col_cnt_output;
reg [WEIGHT_ADDR_WIDTH-1:0] weight_cnt, n_weight_cnt;
reg [WEIGHT_ADDR_WIDTH-1:0] weight_cnt_getdata, weight_cnt_multi, weight_cnt_quantize, weight_cnt_output;

reg data_addr_complete, n_data_addr_complete;	//All addresses have been sent out.
reg write_enable, n_write_enable;
reg [2:0] write_e_sram_cnt, n_write_e_sram_cnt;

reg [9:0] n_sram_waddr;

wire [1:0] bytemask_sel;
reg [1:0] n_sram_sel;

assign bytemask_sel = col_cnt_output[1:0];

//sram_sel setting: select to read sram c, sram d or sram e
always@* begin
	if(weight_cnt==0)
		n_sram_sel = ~mem_sel;
	else if(weight_cnt==19999)
		n_sram_sel = 3;
	else
		n_sram_sel = sram_sel;
end
always@(posedge clk) begin
	if(~srstn) 		
		sram_sel <= 0;
	else 
		sram_sel <= n_sram_sel;
end
//fc_state
always@* begin
	fc_state = (n_state==FC_2);
end
//accumulate_reset
always@* begin
	accumulate_reset = n_write_enable;
end
//bytemask
always@ *begin
	case (bytemask_sel)
		2'b00 : sram_bytemask = 4'b1000;
		2'b01 : sram_bytemask = 4'b0100;
		2'b10 : sram_bytemask = 4'b0010;
		2'b11 : sram_bytemask = 4'b0001;
	  	default: sram_bytemask = 4'b0000;
	endcase
end
//write addr
always@* begin
	case(state)
		IDLE: n_sram_waddr = 0;
		PRE_FETCH: n_sram_waddr = 0;
		FC_1: n_sram_waddr = (write_enable&&write_e_sram_cnt==4&&bytemask_sel==2'b11)? ((sram_waddr==24)? 0 : sram_waddr+1) : sram_waddr;
		FC_2: n_sram_waddr = (write_enable)? sram_waddr+1 : sram_waddr;
		DONE: n_sram_waddr = 0;
		default: n_sram_waddr = 0;
	endcase
end
always@(posedge clk) begin
	if(~srstn)
		sram_waddr <= 0;
	else
		sram_waddr <= n_sram_waddr;
end

//write_enable and write e sram counter
always@* begin
	case(state)
		IDLE: n_write_enable = 0; 
		PRE_FETCH: n_write_enable = 0; 
		FC_1: n_write_enable = (row_cnt_quantize==39); 
		FC_2: n_write_enable = (row_cnt_quantize==24); 
		DONE: n_write_enable = 0; 
		default : n_write_enable = 0; 
	endcase
end
always@* begin
	case(state)
		IDLE: n_write_e_sram_cnt = 0; 
		PRE_FETCH: n_write_e_sram_cnt = 0; 
		FC_1: n_write_e_sram_cnt = (write_enable&&bytemask_sel==2'b11)? ((write_e_sram_cnt==4)? 0 : write_e_sram_cnt+1) : write_e_sram_cnt;
		FC_2: n_write_e_sram_cnt = 0;
		DONE: n_write_e_sram_cnt = 0; 
		default : n_write_e_sram_cnt = 0; 
	endcase
end
always@(posedge clk) begin
	if(~srstn) begin 		
		write_enable <= 0;
		write_e_sram_cnt <= 0;
	end
	else begin
		write_enable <= n_write_enable;
		write_e_sram_cnt <= n_write_e_sram_cnt;
	end
end
//write_enable of sram e series and f: controlled by a counter(0~4)
always@* begin
	case(state)
		IDLE: begin
			sram_write_enable_e0 = 1;
			sram_write_enable_e1 = 1;
			sram_write_enable_e2 = 1;
			sram_write_enable_e3 = 1;
			sram_write_enable_e4 = 1;
			sram_write_enable_f = 1;
		end
		PRE_FETCH: begin
			sram_write_enable_e0 = 1;
			sram_write_enable_e1 = 1;
			sram_write_enable_e2 = 1;
			sram_write_enable_e3 = 1;
			sram_write_enable_e4 = 1;
			sram_write_enable_f = 1;
		end
		FC_1: begin
			sram_write_enable_e0 = ~((write_e_sram_cnt==0)&&write_enable);
			sram_write_enable_e1 = ~((write_e_sram_cnt==1)&&write_enable);
			sram_write_enable_e2 = ~((write_e_sram_cnt==2)&&write_enable);
			sram_write_enable_e3 = ~((write_e_sram_cnt==3)&&write_enable);
			sram_write_enable_e4 = ~((write_e_sram_cnt==4)&&write_enable);
			sram_write_enable_f = 1;
		end
		FC_2: begin
			sram_write_enable_e0 = 1;
			sram_write_enable_e1 = 1;
			sram_write_enable_e2 = 1;
			sram_write_enable_e3 = 1;
			sram_write_enable_e4 = 1;
			sram_write_enable_f = ~write_enable;
		end
		DONE: begin
			sram_write_enable_e0 = 1;
			sram_write_enable_e1 = 1;
			sram_write_enable_e2 = 1;
			sram_write_enable_e3 = 1;
			sram_write_enable_e4 = 1;
			sram_write_enable_f = 1;
		end
		default: begin
			sram_write_enable_e0 = 1;
			sram_write_enable_e1 = 1;
			sram_write_enable_e2 = 1;
			sram_write_enable_e3 = 1;
			sram_write_enable_e4 = 1;
			sram_write_enable_f = 1;
		end
	endcase
end

//fetch_done
always@* begin
	n_fetch_done = (weight_cnt==2);
end

always@(posedge clk) begin
	if(~srstn) 	fetch_done <= 0;
	else fetch_done <= n_fetch_done;
end
//fc_done signal: fc1_done and fc2_done, when output is ready, n_done is raised.
always@*begin
	n_fc1_done = (weight_cnt_output==19999);
	n_fc2_done = (weight_cnt_output==20249);
end
always@(posedge clk)begin
	if(~srstn) begin
		fc1_done <= 0;
		fc2_done <= 0;
	end			
	else begin
		fc1_done <= n_fc1_done;
		fc2_done <= n_fc2_done;
	end
end
//data_addr_complete
always@*begin
	case(state)
		IDLE: n_data_addr_complete = 0;
		PRE_FETCH: n_data_addr_complete = 0;
		FC_1: n_data_addr_complete = 0;
		FC_2: n_data_addr_complete = (n_weight_cnt==20249)? 1 : data_addr_complete;
		DONE: n_data_addr_complete = 0;
		default: n_data_addr_complete = 0;
	endcase
end
always@(posedge clk)begin
	if(~srstn) 
		data_addr_complete <= 0;
	else 
		data_addr_complete <= n_data_addr_complete;
end

//counter control and addr assign
always@* begin
	case(state)
		IDLE: begin
			n_row_cnt = 0;
			n_col_cnt = 0;
			n_weight_cnt = 0;
		end
		PRE_FETCH: begin
			n_row_cnt = row_cnt + 1;
			n_col_cnt = col_cnt + 1;
			n_weight_cnt = weight_cnt + 1;
		end
		FC_1: begin
			n_row_cnt = (row_cnt==39)? 0 : row_cnt+ 1;
			n_col_cnt = (row_cnt==39)? ((col_cnt==499)? 0 : col_cnt+1) : col_cnt;   
			n_weight_cnt = weight_cnt + 1;
		end
		FC_2: begin
			n_row_cnt = (data_addr_complete)? 0 : ((row_cnt==24)? 0 : (row_cnt+ 1));
			n_col_cnt = (data_addr_complete)? 0 : ((row_cnt==24)? col_cnt+1 : col_cnt);
			n_weight_cnt = (data_addr_complete)? 0 : weight_cnt+1;   
		end
		DONE: begin
			n_row_cnt = 0;
			n_col_cnt = 0;
			n_weight_cnt = 0;
		end
		default: begin
			n_row_cnt = 0;
			n_col_cnt = 0;
			n_weight_cnt = 0;
		end
	endcase
end
always@(posedge clk) begin
	if(~srstn) begin
		row_cnt <= 0;
		col_cnt <= 0;
		row_cnt_getdata <= 0;
		row_cnt_multi <= 0;
		row_cnt_quantize <= 0;
		col_cnt_getdata <= 0;
		col_cnt_multi <= 0;
		col_cnt_quantize <= 0;
		col_cnt_output <= 0;

		weight_cnt <= 0;
		weight_cnt_getdata <= 0;
		weight_cnt_multi <= 0;
		weight_cnt_quantize <= 0;
		weight_cnt_output <= 0;
	end
	else begin
		row_cnt <= n_row_cnt;
		col_cnt <= n_col_cnt;
		row_cnt_getdata <= row_cnt;
		row_cnt_multi <= row_cnt_getdata;
		row_cnt_quantize <= row_cnt_multi;
		col_cnt_getdata <= col_cnt;
		col_cnt_multi <= col_cnt_getdata;
		col_cnt_quantize <= col_cnt_multi;
		col_cnt_output <= col_cnt_quantize;
		weight_cnt <= n_weight_cnt;
		weight_cnt_getdata <= weight_cnt;
		weight_cnt_multi <= weight_cnt_getdata;
		weight_cnt_quantize <= weight_cnt_multi;
		weight_cnt_output <= weight_cnt_quantize;
	end
end
assign sram_raddr_weight = weight_cnt;
assign sram_raddr_c0 = {{4{1'b0}},row_cnt};
assign sram_raddr_c1 = {{4{1'b0}},row_cnt};
assign sram_raddr_c2 = {{4{1'b0}},row_cnt};
assign sram_raddr_c3 = {{4{1'b0}},row_cnt};
assign sram_raddr_c4 = {{4{1'b0}},row_cnt};
assign sram_raddr_d0 = {{4{1'b0}},row_cnt};
assign sram_raddr_d1 = {{4{1'b0}},row_cnt};
assign sram_raddr_d2 = {{4{1'b0}},row_cnt};
assign sram_raddr_d3 = {{4{1'b0}},row_cnt};
assign sram_raddr_d4 = {{4{1'b0}},row_cnt};
assign sram_raddr_e0 = {{4{1'b0}},row_cnt};
assign sram_raddr_e1 = {{4{1'b0}},row_cnt};
assign sram_raddr_e2 = {{4{1'b0}},row_cnt};
assign sram_raddr_e3 = {{4{1'b0}},row_cnt};
assign sram_raddr_e4 = {{4{1'b0}},row_cnt};

//record conv_done
always@* begin
	if(busy) n_conv_done_record = (conv_done)? 1 : conv_done_record;
	else n_conv_done_record = 0;
end
always@(posedge clk) begin
	if(~srstn) conv_done_record <= 0;
	else conv_done_record <= n_conv_done_record;
end


//fetch_data_start
always@*begin
	fetch_data_start = (~busy&&(conv_done||conv_done_record))? 1:0;
end
//busy wire setting
always@*begin
	n_busy = (n_state==IDLE)? 0:1;
end
always@(posedge clk) begin
	if(~srstn)
		busy <= 0;
	else
		busy <= n_busy;
end
//FSM
always@* begin
	case(state)
		IDLE: n_state = (fetch_data_start)? PRE_FETCH : IDLE; 
		PRE_FETCH: n_state = (fetch_done)? FC_1 : PRE_FETCH;
		FC_1: n_state = (n_fc1_done)? FC_2 : FC_1;			//switch to FC_2 after the outputs of FC_1 are all stored well in e sram
		FC_2: n_state = (n_fc2_done)? DONE : FC_2;			//switch to IDLE after the outputs of FC_2 are all stored well in f sram
		DONE: n_state = IDLE;
		default: n_state = IDLE; 
	endcase
end

always@(posedge clk) begin
	if(~srstn) 
		state <= 0;
	else 
		state <= n_state;
end

endmodule