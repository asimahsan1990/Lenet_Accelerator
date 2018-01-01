module conv_control(
input clk,
input srstn,
input [1:0] mode,
input mem_sel,

output reg conv1_done,
output reg [16:0] sram_raddr_weight,	// Current weight matrix
output reg [3:0] box_sel,				// Current data-selection type
output reg load_conv1_bias_enable,
output reg [16:0] conv1_bias_set,
// Current addresses of image data
output reg [9:0] sram_raddr_a0,
output reg [9:0] sram_raddr_a1,
output reg [9:0] sram_raddr_a2,
output reg [9:0] sram_raddr_a3,
output reg [9:0] sram_raddr_a4,
output reg [9:0] sram_raddr_a5,
output reg [9:0] sram_raddr_a6,
output reg [9:0] sram_raddr_a7,
output reg [9:0] sram_raddr_a8,
// 0: Write enable, 1: Read enable
output reg sram_write_enable_b0,
output reg sram_write_enable_b1,
output reg sram_write_enable_b2,
output reg sram_write_enable_b3,
output reg sram_write_enable_b4,
output reg sram_write_enable_b5,
output reg sram_write_enable_b6,
output reg sram_write_enable_b7,
output reg sram_write_enable_b8,

output reg [3:0] sram_bytemask_b,
output reg [9:0] sram_waddr_b,

output reg conv_done,
output reg [4:0] channel,
output reg [7:0] set,
output reg load_conv2_bias0_enable,
output reg load_conv2_bias1_enable,
// Current addresses of image data
output reg [9:0] sram_raddr_b0,
output reg [9:0] sram_raddr_b1,
output reg [9:0] sram_raddr_b2,
output reg [9:0] sram_raddr_b3,
output reg [9:0] sram_raddr_b4,
output reg [9:0] sram_raddr_b5,
output reg [9:0] sram_raddr_b6,
output reg [9:0] sram_raddr_b7,
output reg [9:0] sram_raddr_b8,
// 0: Write enable, 1: Read enable
output reg sram_write_enable_c0,
output reg sram_write_enable_c1,
output reg sram_write_enable_c2,
output reg sram_write_enable_c3,
output reg sram_write_enable_c4,

output reg [3:0] sram_bytemask_c,
output reg [9:0] sram_waddr_c,

// 0: Write enable, 1: Read enable
output reg sram_write_enable_d0,
output reg sram_write_enable_d1,
output reg sram_write_enable_d2,
output reg sram_write_enable_d3,
output reg sram_write_enable_d4,

output reg [3:0] sram_bytemask_d,
output reg [9:0] sram_waddr_d
);

localparam IDLE = 0, CONV1 = 1, CONV2 = 2, DONE = 3;
localparam CONV_IDLE = 0, LOAD_CONV1_BIAS = 1, LOAD_CONV1_WEIGHT = 2, LOAD_CONV1_WRITE_DATA = 3, CONV1_FINISH = 4,
		   LOAD_CONV2_BIAS0 = 5, LOAD_CONV2_BIAS1 = 6, CONV2_NEXT_POOLING = 7, LOAD_CONV2_WRITE_DATA = 8, CONV_FINISH = 9;
/*****/
localparam PREPARING = 10, PREPARING_CONV2_BIAS0 = 11, PREPARING_CONV2_BIAS1 = 12;
/*****/
localparam RESET_SEL_DATA = 4'b0000;
localparam SEL_DATA_TYPE1 = 4'b0001, SEL_DATA_TYPE2 = 4'b0010 , SEL_DATA_TYPE3 = 4'b0011;
localparam SEL_DATA_TYPE4 = 4'b0101, SEL_DATA_TYPE5 = 4'b0110 , SEL_DATA_TYPE6 = 4'b0111;
localparam SEL_DATA_TYPE7 = 4'b1001, SEL_DATA_TYPE8 = 4'b1010 , SEL_DATA_TYPE9 = 4'b1011;
localparam HOLD_DATA = 4'b1111;

// Each row can be seperate in to 5+5+4 = 14 (addresses), 14*2 = 28 pixels (The size of input pattern is 28x28)
localparam DATA_NUM_PER_ROW_SRAM_a0 = 5;
localparam DATA_NUM_PER_ROW_SRAM_a1 = 5;
localparam DATA_NUM_PER_ROW_SRAM_a2 = 4;
localparam DATA_NUM_PER_ROW_SRAM_a3 = 5;
localparam DATA_NUM_PER_ROW_SRAM_a4 = 5;
localparam DATA_NUM_PER_ROW_SRAM_a5 = 4;
localparam DATA_NUM_PER_ROW_SRAM_a6 = 5;
localparam DATA_NUM_PER_ROW_SRAM_a7 = 5;
localparam DATA_NUM_PER_ROW_SRAM_a8 = 4;

localparam POOL1_OUTPUT_NUM = 144;			// 12x12 = 144
localparam POOL1_ROW_NUM = 12;
localparam POOL1_COL_NUM = 12;
localparam CONV1_WEIGHT_NUM = 20;

// Each row can be seperate in to 2+2+2 = 6 (addresses), 6*2 = 12 pixels (The size of input pattern is 12x12)
localparam DATA_NUM_PER_ROW_SRAM_b0 = 2;
localparam DATA_NUM_PER_ROW_SRAM_b1 = 2;
localparam DATA_NUM_PER_ROW_SRAM_b2 = 2;
localparam DATA_NUM_PER_ROW_SRAM_b3 = 2;
localparam DATA_NUM_PER_ROW_SRAM_b4 = 2;
localparam DATA_NUM_PER_ROW_SRAM_b5 = 2;
localparam DATA_NUM_PER_ROW_SRAM_b6 = 2;
localparam DATA_NUM_PER_ROW_SRAM_b7 = 2;
localparam DATA_NUM_PER_ROW_SRAM_b8 = 2;

localparam POOL2_OUTPUT_NUM = 16;			// 4x4 = 16
localparam POOL2_ROW_NUM = 4;
localparam POOL2_COL_NUM = 4;
localparam CONV2_SET_NUM = 50;			// 20x50 = 1000

wire [1:0] bytemask_sel;
wire [3:0] data_sel;
wire n_conv1_done;

reg [3:0] state, n_state;
/*****/
reg [3:0] delay1_state, delay2_state, delay3_state;
/*****/
reg n_load_conv1_bias_enable;
reg delay_load_conv1_bias_enable;
reg n_load_conv2_bias0_enable, n_load_conv2_bias1_enable;
reg delay_load_conv2_bias0_enable, delay_load_conv2_bias1_enable;
reg write_enable, n_write_enable, delay_write_enable, delay2_write_enable, delay3_write_enable;
reg load_data_enable, n_load_data_enable;
reg [16:0] n_sram_raddr_weight;
reg [3:0] n_box_sel;

reg [3:0] row, n_row;
reg [3:0] col, n_col;
reg [1:0] addr_row_sel_cnt , n_addr_row_sel_cnt;
reg [1:0] addr_col_sel_cnt , n_addr_col_sel_cnt;
reg [3:0] data_sel_col;
reg [3:0] data_sel_row;
reg [3:0] row_delay;
reg [3:0] col_delay;
reg [3:0] write_row;
reg [3:0] write_col;
reg [3:0] row_enable;
reg [3:0] col_enable;
/*****/
reg [3:0] write_row_conv1;
reg [3:0] write_col_conv1;
/*****/

reg [7:0] weight_cnt, n_weight_cnt;
reg [7:0] delay_set;
reg [7:0] conv1_weight_cnt, conv2_weight_cnt;
reg conv1_weight_done, n_conv1_weight_done;
reg conv2_weight_done, n_conv2_weight_done;

reg [9:0] n_sram_raddr_a0;
reg [9:0] n_sram_raddr_a1;
reg [9:0] n_sram_raddr_a2;
reg [9:0] n_sram_raddr_a3;
reg [9:0] n_sram_raddr_a4;
reg [9:0] n_sram_raddr_a5;
reg [9:0] n_sram_raddr_a6;
reg [9:0] n_sram_raddr_a7;
reg [9:0] n_sram_raddr_a8;

reg [9:0] n_sram_raddr_b0;
reg [9:0] n_sram_raddr_b1;
reg [9:0] n_sram_raddr_b2;
reg [9:0] n_sram_raddr_b3;
reg [9:0] n_sram_raddr_b4;
reg [9:0] n_sram_raddr_b5;
reg [9:0] n_sram_raddr_b6;
reg [9:0] n_sram_raddr_b7;
reg [9:0] n_sram_raddr_b8;

reg [9:0] n_sram_waddr_b, delay1_sram_waddr_b/*, delay2_sram_waddr_b, delay3_sram_waddr_b*/;
reg [3:0] n_sram_bytemask_b/*, delay_sram_bytemask_b, delay2_sram_bytemask_b*/;
reg [9:0] n_sram_waddr_c, delay1_sram_waddr_c/*, delay2_sram_waddr_c, delay3_sram_waddr_c, delay4_sram_waddr_c*/;
reg [3:0] n_sram_bytemask_c/*, delay_sram_bytemask_c*/;
reg [9:0] n_sram_waddr_d, delay1_sram_waddr_d/*, delay2_sram_waddr_d, delay3_sram_waddr_d, delay4_sram_waddr_d*/;
reg [3:0] n_sram_bytemask_d/*, delay_sram_bytemask_d*/;

reg n_sram_write_enable_b0;
reg n_sram_write_enable_b1;
reg n_sram_write_enable_b2;
reg n_sram_write_enable_b3;
reg n_sram_write_enable_b4;
reg n_sram_write_enable_b5;
reg n_sram_write_enable_b6;
reg n_sram_write_enable_b7;
reg n_sram_write_enable_b8;
/*
reg delay_sram_write_enable_b0;
reg delay_sram_write_enable_b1;
reg delay_sram_write_enable_b2;
reg delay_sram_write_enable_b3;
reg delay_sram_write_enable_b4;
reg delay_sram_write_enable_b5;
reg delay_sram_write_enable_b6;
reg delay_sram_write_enable_b7;
reg delay_sram_write_enable_b8;

reg delay2_sram_write_enable_b0;
reg delay2_sram_write_enable_b1;
reg delay2_sram_write_enable_b2;
reg delay2_sram_write_enable_b3;
reg delay2_sram_write_enable_b4;
reg delay2_sram_write_enable_b5;
reg delay2_sram_write_enable_b6;
reg delay2_sram_write_enable_b7;
reg delay2_sram_write_enable_b8;
*/
reg n_sram_write_enable_c0;
reg n_sram_write_enable_c1;
reg n_sram_write_enable_c2;
reg n_sram_write_enable_c3;
reg n_sram_write_enable_c4;

reg n_sram_write_enable_d0;
reg n_sram_write_enable_d1;
reg n_sram_write_enable_d2;
reg n_sram_write_enable_d3;
reg n_sram_write_enable_d4;
/*
reg delay_sram_write_enable_c0;
reg delay_sram_write_enable_c1;
reg delay_sram_write_enable_c2;
reg delay_sram_write_enable_c3;
reg delay_sram_write_enable_c4;

reg delay_sram_write_enable_d0;
reg delay_sram_write_enable_d1;
reg delay_sram_write_enable_d2;
reg delay_sram_write_enable_d3;
reg delay_sram_write_enable_d4;
*/
reg [4:0] addr_change, n_addr_change, delay_addr_change, delay2_addr_change, delay3_addr_change;

reg [4:0] channel_cnt, n_channel_cnt, delay_channel, delay2_channel;

//reg delay1_conv1_done, delay2_conv1_done, delay3_conv1_done, delay4_conv1_done;
//reg delay_conv_done, delay2_conv_done, delay3_conv_done;

//assign n_conv1_done = (conv1_done)? 0: (weight_cnt == CONV1_WEIGHT_NUM)? 1 : 0;
//assign n_conv_done = (conv_done)? 0 : (weight_cnt == CONV2_SET_NUM)? 1 : 0;
assign n_conv1_done = (conv1_done)? 0: (conv1_weight_cnt == CONV1_WEIGHT_NUM && mode == CONV1)? 1 : 0;
assign n_conv_done = (conv_done)? 0 : (conv2_weight_cnt == CONV2_SET_NUM && mode == CONV2)? 1 : 0;

always@(posedge clk) begin
    if(~srstn) begin
		state <= CONV_IDLE;
    end
    else begin 
		state <= n_state;
    end
end

always@* begin
	case(state)
		/*CONV_IDLE : begin
			if(mode == CONV1) n_state = LOAD_CONV1_BIAS;
			else n_state = CONV_IDLE;
		end*/
		/*****/
		CONV_IDLE : begin
			if(mode == CONV1) n_state = PREPARING;
			else n_state = CONV_IDLE;
		end
		PREPARING : n_state = LOAD_CONV1_BIAS;
		/*****/
		LOAD_CONV1_BIAS : n_state = LOAD_CONV1_WRITE_DATA;
		LOAD_CONV1_WEIGHT : n_state = LOAD_CONV1_WRITE_DATA;
		LOAD_CONV1_WRITE_DATA : begin
			if(conv1_done) n_state = CONV1_FINISH; 
			else n_state = (conv1_weight_done)? LOAD_CONV1_WEIGHT : LOAD_CONV1_WRITE_DATA;
		end
		/*CONV1_FINISH : n_state = LOAD_CONV2_BIAS0;
		LOAD_CONV2_BIAS0 : n_state = LOAD_CONV2_BIAS1;*/
		/*****/
		CONV1_FINISH : n_state = PREPARING_CONV2_BIAS0;
		PREPARING_CONV2_BIAS0 : n_state = LOAD_CONV2_BIAS0;
		LOAD_CONV2_BIAS0 : n_state = PREPARING_CONV2_BIAS1;
		PREPARING_CONV2_BIAS1 : n_state = LOAD_CONV2_BIAS1;
		/*****/		
		LOAD_CONV2_BIAS1 : n_state = LOAD_CONV2_WRITE_DATA;
		CONV2_NEXT_POOLING : n_state = LOAD_CONV2_WRITE_DATA;
		LOAD_CONV2_WRITE_DATA : begin
			if(conv_done) n_state = CONV_FINISH; 
			else n_state = (channel_cnt == 19)? CONV2_NEXT_POOLING : LOAD_CONV2_WRITE_DATA;
		end
		CONV_FINISH : n_state = CONV_IDLE;
		default : n_state = CONV_IDLE;
	endcase
end

always@(posedge clk) begin
    if(~srstn) begin
        row <= 0;
        col <= 0;
		conv1_weight_done <= 0;
		conv2_weight_done <= 0;
		write_enable <= 0;
		delay_write_enable <= 0;
		delay2_write_enable <= 0;
		/*****/
		delay3_write_enable <= 0;
		/*****/
		load_conv1_bias_enable <= 0;
		//delay_load_conv1_bias_enable <= 0;
		load_conv2_bias0_enable <= 0;
		load_conv2_bias1_enable <= 0;
		/*delay_load_conv2_bias0_enable <= 0;
		delay_load_conv2_bias1_enable <= 0;*/
		load_data_enable <= 0;
		weight_cnt <= 0;
		delay_set <= 0;
		set <= 0;
		/*******/
		conv2_weight_cnt <= 0;
		conv1_weight_cnt <= 0;
		/*******/
		sram_raddr_weight <= 0;
		conv1_bias_set <= 0;
		box_sel <= 0;
		addr_col_sel_cnt <= 0;
		addr_row_sel_cnt <= 0;
		data_sel_col <= 0;
		data_sel_row <= 0;
		conv1_done <= 0;
		sram_waddr_b <= 0;
		delay1_sram_waddr_b <= 0;
		/*delay2_sram_waddr_b <= 0;
		delay3_sram_waddr_b <= 0;*/
		sram_bytemask_b <= 0;
		/*delay_sram_bytemask_b <= 0;
		delay2_sram_bytemask_b <= 0;*/
		row_enable <= 0;
		col_enable <= 0;
		write_row <= 0;
		write_col <= 0;
		row_delay <= 0;
		col_delay <= 0;
		/*****/
		write_row_conv1 <= 0;
		write_col_conv1 <= 0;
		/*****/
		/*delay1_conv1_done <= 0;
		delay2_conv1_done <= 0;
		delay3_conv1_done <= 0;
		delay4_conv1_done <= 0;*/
		conv_done <= 0;
		delay1_sram_waddr_c <= 0;
		delay1_sram_waddr_d <= 0;
		/*delay2_sram_waddr_c <= 0;
		delay2_sram_waddr_d <= 0;
		delay3_sram_waddr_c <= 0;
		delay3_sram_waddr_d <= 0;
		delay4_sram_waddr_c <= 0;
		delay4_sram_waddr_d <= 0;*/
		sram_waddr_c <= 0;
		sram_waddr_d <= 0;
		sram_bytemask_c <= 0;
		//delay_sram_bytemask_c <= 0;
		sram_bytemask_d <= 0;
		//delay_sram_bytemask_d <= 0;
		/*delay_conv_done <= 0;
		delay2_conv_done <= 0;
		delay3_conv_done <= 0;*/
		channel_cnt <= 0;
		addr_change <= 0;
		delay_addr_change <= 0;
		delay2_addr_change <= 0;
		/*****/
		delay3_addr_change <= 0;
		/*****/
		delay_channel <= 0;
		delay2_channel <= 0;
		channel <= 0;
		/*****/
		delay1_state <= 0;
		delay2_state <= 0;
		delay3_state <= 0;
		/*****/
    end
    else begin
        row <= n_row;
        col <= n_col;
		conv1_weight_done <= n_conv1_weight_done;
		conv2_weight_done <= n_conv2_weight_done;
		write_enable <= n_write_enable;
		delay_write_enable <= write_enable;
		delay2_write_enable <= delay_write_enable;
		/*****/
		delay3_write_enable <= delay2_write_enable;
		/*****/
		/*load_conv1_bias_enable <= delay_load_conv1_bias_enable;
		delay_load_conv1_bias_enable <= n_load_conv1_bias_enable;*/
		/*****/
		load_conv1_bias_enable <= n_load_conv1_bias_enable;
		/*****/
		/*load_conv2_bias0_enable <= delay_load_conv2_bias0_enable;
		load_conv2_bias1_enable <= delay_load_conv2_bias1_enable;
		delay_load_conv2_bias0_enable <= n_load_conv2_bias0_enable;
		delay_load_conv2_bias1_enable <= n_load_conv2_bias1_enable;*/
		/*****/
		load_conv2_bias0_enable <= n_load_conv2_bias0_enable;
		load_conv2_bias1_enable <= n_load_conv2_bias1_enable;
		/*****/
		load_data_enable <= n_load_data_enable;
		weight_cnt <= n_weight_cnt;
		delay_set <= weight_cnt;
		set <= delay_set;
		/*****/
		conv2_weight_cnt <= set;
		conv1_weight_cnt <= conv2_weight_cnt;
		/*****/
		sram_raddr_weight <= n_sram_raddr_weight;
		conv1_bias_set <= sram_raddr_weight;
		box_sel <= n_box_sel;
		addr_col_sel_cnt <= n_addr_col_sel_cnt;
		addr_row_sel_cnt <= n_addr_row_sel_cnt;
		data_sel_col <= addr_col_sel_cnt;
		data_sel_row <= addr_row_sel_cnt;
		conv1_done <= n_conv1_done;
		//conv1_done <= delay4_conv1_done;
		/*sram_waddr_b <= delay3_sram_waddr_b;
		delay1_sram_waddr_b <= n_sram_waddr_b;
		delay2_sram_waddr_b <= delay1_sram_waddr_b;
		delay3_sram_waddr_b <= delay2_sram_waddr_b;*/
		/*****/
		sram_waddr_b <= delay1_sram_waddr_b;
		delay1_sram_waddr_b <= n_sram_waddr_b;
		/*****/
		/*sram_bytemask_b <= delay2_sram_bytemask_b;
		delay2_sram_bytemask_b <= delay_sram_bytemask_b;
		delay_sram_bytemask_b <= n_sram_bytemask_b;*/
		/*****/
		sram_bytemask_b <= n_sram_bytemask_b;
		/*****/
		row_delay <= row;
		col_delay <= col;
		write_row <= row_delay;
		write_col <= col_delay;
		row_enable <= write_row;
		col_enable <= write_col;
		/*****/
		write_row_conv1 <= row_enable;
		write_col_conv1 <= col_enable;
		/*****/
		/*delay1_conv1_done <= n_conv1_done;
		delay2_conv1_done <= delay1_conv1_done;
		delay3_conv1_done <= delay2_conv1_done;
		delay4_conv1_done <= delay3_conv1_done;*/
		conv_done <= n_conv_done;
		//conv_done <= delay3_conv_done;
		delay1_sram_waddr_c <= n_sram_waddr_c;
		delay1_sram_waddr_d <= n_sram_waddr_d;
		/*delay2_sram_waddr_c <= delay1_sram_waddr_c;
		delay2_sram_waddr_d <= delay1_sram_waddr_d;
		delay3_sram_waddr_c <= delay2_sram_waddr_c;
		delay3_sram_waddr_d <= delay2_sram_waddr_d;
		delay4_sram_waddr_c <= delay3_sram_waddr_c;
		delay4_sram_waddr_d <= delay3_sram_waddr_d;
		sram_waddr_c <= delay4_sram_waddr_c;
		sram_waddr_d <= delay4_sram_waddr_d;*/
		/*****/
		sram_waddr_c <= delay1_sram_waddr_c;
		sram_waddr_d <= delay1_sram_waddr_d;
		/*****/
		/*sram_bytemask_c <= delay_sram_bytemask_c;
		delay_sram_bytemask_c <= n_sram_bytemask_c;
		sram_bytemask_d <= delay_sram_bytemask_d;
		delay_sram_bytemask_d <= n_sram_bytemask_d;*/
		/*****/
		sram_bytemask_c <= n_sram_bytemask_c;
		sram_bytemask_d <= n_sram_bytemask_d;
		/*****/
		/*delay_conv_done <= n_conv_done;
		delay2_conv_done <= delay_conv_done;
		delay3_conv_done <= delay2_conv_done;*/
		addr_change <= n_addr_change;
		delay_addr_change <= addr_change;
		delay2_addr_change <= delay_addr_change;
		/*****/
		delay3_addr_change <= delay2_addr_change;
		/*****/
		channel_cnt <= n_channel_cnt;		
		delay_channel <= channel_cnt;
		delay2_channel <= delay_channel;
		channel <= delay2_channel;
		/*****/
		delay1_state <= state;
		delay2_state <= delay1_state;
		delay3_state <= delay2_state;
		/*****/
    end
end
/*
always@(posedge clk) begin
	if(~srstn) begin
		load_data_enable <= 0;
		load_conv1_bias_enable <= 0;
		load_conv2_bias0_enable <= 0;
		load_conv2_bias1_enable <= 0;
		sram_raddr_weight <= 0;
		write_enable <= 0;
	end
	else begin
		load_data_enable <= n_load_data_enable;
		load_conv1_bias_enable <= n_load_conv1_bias_enable;
		load_conv2_bias0_enable <= n_load_conv2_bias0_enable;
		load_conv2_bias1_enable <= n_load_conv2_bias1_enable;
		sram_raddr_weight <= n_sram_raddr_weight;
		write_enable <= n_write_enable;
	end
end
*/
always@* begin
    case(state)
		CONV_IDLE : begin
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = 20;
		end
		/*****/
		PREPARING : begin
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = 20;
		end
		/*****/
		LOAD_CONV1_BIAS : begin
			n_load_conv1_bias_enable = 1;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = 0;
		end
		LOAD_CONV1_WEIGHT : begin
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = sram_raddr_weight + 1;
		end
		LOAD_CONV1_WRITE_DATA : begin
			n_sram_raddr_weight = sram_raddr_weight;
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			if(conv1_weight_done) begin 
				n_load_data_enable = 0;
				n_write_enable = 1;
			end
			else begin 
				n_write_enable = (load_data_enable)? 1 : write_enable;
				if(col == 0) n_load_data_enable = 1;
				else n_load_data_enable = 0;
			end
		end
		CONV1_FINISH : begin			
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = 1021;
		end
		/*****/
		PREPARING_CONV2_BIAS0 : begin
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = 1021;
		end
		/*****/
		LOAD_CONV2_BIAS0 : begin
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 1;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = 1022;
		end
		/*****/
		PREPARING_CONV2_BIAS1 : begin
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = 1022;
		end
		/*****/
		LOAD_CONV2_BIAS1 : begin
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 1;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = 21;
		end
		CONV2_NEXT_POOLING : begin
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0; 
			if((row*POOL2_ROW_NUM + col) >= POOL2_OUTPUT_NUM - 1) begin
				n_sram_raddr_weight = sram_raddr_weight;
			end
			else begin
				n_sram_raddr_weight = sram_raddr_weight - 20;
			end
		end
		LOAD_CONV2_WRITE_DATA : begin			
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_sram_raddr_weight = sram_raddr_weight + 1;
			if(conv2_weight_done) begin 
				n_load_data_enable = 0;
				n_write_enable = 1;
			end
			else begin 
				n_write_enable = (load_data_enable)? 1 : write_enable;
				if(channel_cnt == 0) n_load_data_enable = 1;
				else n_load_data_enable = 0;
			end
		end
		CONV_FINISH : begin			
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = sram_raddr_weight;
			/*****/
			//n_sram_raddr_weight = 20;
			/*****/
		end
		default : begin			
			n_load_conv1_bias_enable = 0;
			n_load_conv2_bias0_enable = 0;
			n_load_conv2_bias1_enable = 0;
			n_load_data_enable = 0;
			n_write_enable = 0;
			n_sram_raddr_weight = 0;
		end
	endcase
end

always@* begin
	if(state == LOAD_CONV1_WRITE_DATA) begin
		if((row*POOL1_ROW_NUM + col) >= POOL1_OUTPUT_NUM - 1) begin
			n_row = 0;
    		n_col = 0;
			n_conv1_weight_done = 1;
			n_conv2_weight_done = 0;
			n_weight_cnt = weight_cnt + 1;
		end
		else begin
			n_conv1_weight_done = 0;
			n_conv2_weight_done = 0;
			n_weight_cnt = weight_cnt;
    		if(col == POOL1_COL_NUM-1) begin
    		    n_col = 0;
    		    n_row = row + 1;
    		end
    		else begin
    		    n_col = col + 1;
				n_row = row;
    		end
		end
	end
	else if(state == CONV2_NEXT_POOLING) begin
		if((row*POOL2_ROW_NUM + col) >= POOL2_OUTPUT_NUM - 1) begin
			n_row = 0;
    		n_col = 0;
    		n_conv1_weight_done = 0;
			n_conv2_weight_done = 1;
			n_weight_cnt = weight_cnt + 1;			// Count to 50 and it's over
		end
		else begin
			n_conv1_weight_done = 0;
			n_conv2_weight_done = 0;
			n_weight_cnt = weight_cnt;
    		if(col == POOL2_COL_NUM-1) begin
    		    n_col = 0;
    		    n_row = row + 1;
    		end
    		else begin
    		    n_col = col + 1;
				n_row = row;
    		end
		end
	end/*
	else if((state == CONV_IDLE) | (state == CONV1_DONE)) begin
		n_row = 0;
		n_col = 0;
		n_weight_cnt = 0;
		n_conv1_weight_done = 0;
	end*/
	else if(state == LOAD_CONV1_WEIGHT) begin
		n_row = row;
		n_col = 0;		
		n_conv1_weight_done = conv1_weight_done;
		n_conv2_weight_done = 0;
		n_weight_cnt = weight_cnt;
	end
	else if(state == LOAD_CONV2_WRITE_DATA) begin
		n_row = row;
		n_col = col;
		n_conv1_weight_done = 0;
		n_conv2_weight_done = conv2_weight_done;
		n_weight_cnt = weight_cnt;
	end
	else begin
		n_row = 0;
		n_col = 0;		
		n_conv1_weight_done = 0;
		n_conv2_weight_done = 0;
		n_weight_cnt = 0;
	end
end

// Current channel
always@* begin
	if (state == LOAD_CONV2_WRITE_DATA) begin
		if (channel_cnt == 19) n_channel_cnt = channel_cnt;
		else n_channel_cnt = channel_cnt + 1;
	end
	else begin
		n_channel_cnt = 0;
	end
end 

always@* begin
	if(state == LOAD_CONV1_WRITE_DATA) begin
		n_addr_col_sel_cnt = (col == 11)? 0 : (addr_col_sel_cnt == 2)? 0 : addr_col_sel_cnt + 1;
		n_addr_row_sel_cnt = (col == 11 && addr_row_sel_cnt == 2)? 0 : (col == 11)? addr_row_sel_cnt + 1 : addr_row_sel_cnt;
	end
	else begin
		n_addr_col_sel_cnt = 0;
		n_addr_row_sel_cnt = 0;
	end
end

always@(posedge clk) begin
    if(~srstn) begin
        sram_raddr_a0 <= 0;
        sram_raddr_a1 <= 0;
        sram_raddr_a2 <= 0;
        sram_raddr_a3 <= 0;
        sram_raddr_a4 <= 0;
        sram_raddr_a5 <= 0;
        sram_raddr_a6 <= 0;
        sram_raddr_a7 <= 0;
        sram_raddr_a8 <= 0;
	end else begin
        sram_raddr_a0 <= n_sram_raddr_a0;
        sram_raddr_a1 <= n_sram_raddr_a1;
        sram_raddr_a2 <= n_sram_raddr_a2;
        sram_raddr_a3 <= n_sram_raddr_a3;
        sram_raddr_a4 <= n_sram_raddr_a4;
        sram_raddr_a5 <= n_sram_raddr_a5;
        sram_raddr_a6 <= n_sram_raddr_a6;
        sram_raddr_a7 <= n_sram_raddr_a7;
        sram_raddr_a8 <= n_sram_raddr_a8;
	end
end

always@* begin
	case (state)
		CONV_IDLE : begin
        	n_sram_raddr_a0 = 0;
        	n_sram_raddr_a1 = 0;
        	n_sram_raddr_a2 = 0;
        	n_sram_raddr_a3 = 0;
        	n_sram_raddr_a4 = 0;
        	n_sram_raddr_a5 = 0;
        	n_sram_raddr_a6 = 0;
        	n_sram_raddr_a7 = 0;
        	n_sram_raddr_a8 = 0;
		end
		LOAD_CONV1_WRITE_DATA : begin
			if(conv1_weight_done) begin
				n_sram_raddr_a0 = 0;
        		n_sram_raddr_a1 = 0;
        		n_sram_raddr_a2 = 0;
        		n_sram_raddr_a3 = 0;
        		n_sram_raddr_a4 = 0;
        		n_sram_raddr_a5 = 0;
        		n_sram_raddr_a6 = 0;
        		n_sram_raddr_a7 = 0;
        		n_sram_raddr_a8 = 0;
			end
			else begin
				if(col == POOL1_COL_NUM - 1) begin  // change row
					case (addr_row_sel_cnt)
						0 : begin
							n_sram_raddr_a0 = sram_raddr_a0 + 1;
                    		n_sram_raddr_a1 = sram_raddr_a1 + 1;
                    		n_sram_raddr_a2 = sram_raddr_a2 + 1;
                    		n_sram_raddr_a3 = sram_raddr_a0 + 1 - DATA_NUM_PER_ROW_SRAM_a0;
                    		n_sram_raddr_a4 = sram_raddr_a1 + 1 - DATA_NUM_PER_ROW_SRAM_a1;
                    		n_sram_raddr_a5 = sram_raddr_a2 + 1 - DATA_NUM_PER_ROW_SRAM_a2;
                    		n_sram_raddr_a6 = sram_raddr_a0 + 1 - DATA_NUM_PER_ROW_SRAM_a0;
                    		n_sram_raddr_a7 = sram_raddr_a1 + 1 - DATA_NUM_PER_ROW_SRAM_a1;
                    		n_sram_raddr_a8 = sram_raddr_a2 + 1 - DATA_NUM_PER_ROW_SRAM_a2;
						end
						1 : begin
							n_sram_raddr_a0 = sram_raddr_a3 + 1;
                    		n_sram_raddr_a1 = sram_raddr_a4 + 1;
                    		n_sram_raddr_a2 = sram_raddr_a5 + 1;
                    		n_sram_raddr_a3 = sram_raddr_a3 + 1;
                    		n_sram_raddr_a4 = sram_raddr_a4 + 1;
                    		n_sram_raddr_a5 = sram_raddr_a5 + 1;
                    		n_sram_raddr_a6 = sram_raddr_a3 + 1 - DATA_NUM_PER_ROW_SRAM_a3;
                    		n_sram_raddr_a7 = sram_raddr_a4 + 1 - DATA_NUM_PER_ROW_SRAM_a4;
                    		n_sram_raddr_a8 = sram_raddr_a5 + 1 - DATA_NUM_PER_ROW_SRAM_a5;
						end
						2 : begin
							if(row == 11) begin
								n_sram_raddr_a0 = 0;
                    			n_sram_raddr_a1 = 0;
                    			n_sram_raddr_a2 = 0;
                    			n_sram_raddr_a3 = 0;
                    			n_sram_raddr_a4 = 0;
                    			n_sram_raddr_a5 = 0;
                    			n_sram_raddr_a6 = 0;
                    			n_sram_raddr_a7 = 0;
                    			n_sram_raddr_a8 = 0;
							end
							else begin
								n_sram_raddr_a0 = sram_raddr_a6 + 1;
                    			n_sram_raddr_a1 = sram_raddr_a7 + 1;
                    			n_sram_raddr_a2 = sram_raddr_a8 + 1;
                    			n_sram_raddr_a3 = sram_raddr_a6 + 1;
                    			n_sram_raddr_a4 = sram_raddr_a7 + 1;
                    			n_sram_raddr_a5 = sram_raddr_a8 + 1;
                    			n_sram_raddr_a6 = sram_raddr_a6 + 1;
                    			n_sram_raddr_a7 = sram_raddr_a7 + 1;
                    			n_sram_raddr_a8 = sram_raddr_a8 + 1;
							end
						end 
						default: begin
							n_sram_raddr_a0 = sram_raddr_a0;
                    		n_sram_raddr_a1 = sram_raddr_a1;
                    		n_sram_raddr_a2 = sram_raddr_a2;
                    		n_sram_raddr_a3 = sram_raddr_a3;
                    		n_sram_raddr_a4 = sram_raddr_a4;
                    		n_sram_raddr_a5 = sram_raddr_a5;
                    		n_sram_raddr_a6 = sram_raddr_a6;
                    		n_sram_raddr_a7 = sram_raddr_a7;
                    		n_sram_raddr_a8 = sram_raddr_a8;
						end
					endcase
				end
				else begin
					case (addr_col_sel_cnt) 
					  	0 : begin
							n_sram_raddr_a0 = sram_raddr_a0 + 1;
                    		n_sram_raddr_a1 = sram_raddr_a1;
                    		n_sram_raddr_a2 = sram_raddr_a2;
                    		n_sram_raddr_a3 = sram_raddr_a3 + 1;
                    		n_sram_raddr_a4 = sram_raddr_a4;
                    		n_sram_raddr_a5 = sram_raddr_a5;
                    		n_sram_raddr_a6 = sram_raddr_a6 + 1;
                    		n_sram_raddr_a7 = sram_raddr_a7;
                    		n_sram_raddr_a8 = sram_raddr_a8;
						end
						1 : begin
							n_sram_raddr_a0 = sram_raddr_a0;
                    		n_sram_raddr_a1 = sram_raddr_a1 + 1;
                    		n_sram_raddr_a2 = sram_raddr_a2;
                    		n_sram_raddr_a3 = sram_raddr_a3;
                    		n_sram_raddr_a4 = sram_raddr_a4 + 1;
                    		n_sram_raddr_a5 = sram_raddr_a5;
                    		n_sram_raddr_a6 = sram_raddr_a6;
                    		n_sram_raddr_a7 = sram_raddr_a7 + 1;
                    		n_sram_raddr_a8 = sram_raddr_a8;
						end
						2 : begin
							n_sram_raddr_a0 = sram_raddr_a0;
                    		n_sram_raddr_a1 = sram_raddr_a1;
                    		n_sram_raddr_a2 = sram_raddr_a2 + 1;
                    		n_sram_raddr_a3 = sram_raddr_a3;
                    		n_sram_raddr_a4 = sram_raddr_a4;
                    		n_sram_raddr_a5 = sram_raddr_a5 + 1;
                    		n_sram_raddr_a6 = sram_raddr_a6;
                    		n_sram_raddr_a7 = sram_raddr_a7;
                    		n_sram_raddr_a8 = sram_raddr_a8 + 1;
						end 
					  	default: begin
							n_sram_raddr_a0 = sram_raddr_a0;
                    		n_sram_raddr_a1 = sram_raddr_a1;
                    		n_sram_raddr_a2 = sram_raddr_a2;
                    		n_sram_raddr_a3 = sram_raddr_a3;
                    		n_sram_raddr_a4 = sram_raddr_a4;
                    		n_sram_raddr_a5 = sram_raddr_a5;
                    		n_sram_raddr_a6 = sram_raddr_a6;
                    		n_sram_raddr_a7 = sram_raddr_a7;
                    		n_sram_raddr_a8 = sram_raddr_a8;
						end
					endcase
				end
			end
		end
	  	default: begin
			n_sram_raddr_a0 = 0;
        	n_sram_raddr_a1 = 0;
        	n_sram_raddr_a2 = 0;
        	n_sram_raddr_a3 = 0;
        	n_sram_raddr_a4 = 0;
        	n_sram_raddr_a5 = 0;
        	n_sram_raddr_a6 = 0;
        	n_sram_raddr_a7 = 0;
        	n_sram_raddr_a8 = 0;
		end
	endcase
end

always@(posedge clk) begin
    if(~srstn) begin
        sram_raddr_b0 <= 0;
        sram_raddr_b1 <= 0;
        sram_raddr_b2 <= 0;
        sram_raddr_b3 <= 0;
        sram_raddr_b4 <= 0;
        sram_raddr_b5 <= 0;
        sram_raddr_b6 <= 0;
        sram_raddr_b7 <= 0;
        sram_raddr_b8 <= 0;
	end else begin
        sram_raddr_b0 <= n_sram_raddr_b0;
        sram_raddr_b1 <= n_sram_raddr_b1;
        sram_raddr_b2 <= n_sram_raddr_b2;
        sram_raddr_b3 <= n_sram_raddr_b3;
        sram_raddr_b4 <= n_sram_raddr_b4;
        sram_raddr_b5 <= n_sram_raddr_b5;
        sram_raddr_b6 <= n_sram_raddr_b6;
        sram_raddr_b7 <= n_sram_raddr_b7;
        sram_raddr_b8 <= n_sram_raddr_b8;
	end
end

always@* begin
	case (state)
		CONV_IDLE : begin
        	n_sram_raddr_b0 = 0;
        	n_sram_raddr_b1 = 0;
        	n_sram_raddr_b2 = 0;
        	n_sram_raddr_b3 = 0;
        	n_sram_raddr_b4 = 0;
        	n_sram_raddr_b5 = 0;
        	n_sram_raddr_b6 = 0;
        	n_sram_raddr_b7 = 0;
        	n_sram_raddr_b8 = 0;
		end
		LOAD_CONV2_WRITE_DATA : begin
			if(channel_cnt==19) begin
				if ((row==3)&(col==3)) begin
					n_sram_raddr_b0 = 0;
        			n_sram_raddr_b1 = 0;
        			n_sram_raddr_b2 = 0;
        			n_sram_raddr_b3 = 0;
        			n_sram_raddr_b4 = 0;
        			n_sram_raddr_b5 = 0;
        			n_sram_raddr_b6 = 0;
        			n_sram_raddr_b7 = 0;
        			n_sram_raddr_b8 = 0;
				end
				else begin
					n_sram_raddr_b0 = sram_raddr_b0;
	                n_sram_raddr_b1 = sram_raddr_b1;
	                n_sram_raddr_b2 = sram_raddr_b2;
	                n_sram_raddr_b3 = sram_raddr_b3;
	                n_sram_raddr_b4 = sram_raddr_b4;
	                n_sram_raddr_b5 = sram_raddr_b5;
	                n_sram_raddr_b6 = sram_raddr_b6;
	                n_sram_raddr_b7 = sram_raddr_b7;
	                n_sram_raddr_b8 = sram_raddr_b8;
                end
			end
			else begin
				n_sram_raddr_b0 = sram_raddr_b0 + 4;
	            n_sram_raddr_b1 = sram_raddr_b1 + 4;
	            n_sram_raddr_b2 = sram_raddr_b2 + 4;
	            n_sram_raddr_b3 = sram_raddr_b3 + 4;
	            n_sram_raddr_b4 = sram_raddr_b4 + 4;
	            n_sram_raddr_b5 = sram_raddr_b5 + 4;
	            n_sram_raddr_b6 = sram_raddr_b6 + 4;
	            n_sram_raddr_b7 = sram_raddr_b7 + 4;
	            n_sram_raddr_b8 = sram_raddr_b8 + 4;
            end
		end
		CONV2_NEXT_POOLING : begin
				if ((row==3)&(col==3)) begin
					n_sram_raddr_b0 = 0;
        			n_sram_raddr_b1 = 0;
        			n_sram_raddr_b2 = 0;
        			n_sram_raddr_b3 = 0;
        			n_sram_raddr_b4 = 0;
        			n_sram_raddr_b5 = 0;
        			n_sram_raddr_b6 = 0;
        			n_sram_raddr_b7 = 0;
        			n_sram_raddr_b8 = 0;
				end
				else if(col == POOL2_COL_NUM - 1) begin  // change row
					case (row)
						0 : begin
							n_sram_raddr_b0 = sram_raddr_b0 + 1 - 76;
                    		n_sram_raddr_b1 = sram_raddr_b1 + 1 - 76;
                    		n_sram_raddr_b2 = sram_raddr_b2 + 1 - 76;
                    		n_sram_raddr_b3 = sram_raddr_b0 + 1 - DATA_NUM_PER_ROW_SRAM_b0 - 76;
                    		n_sram_raddr_b4 = sram_raddr_b1 + 1 - DATA_NUM_PER_ROW_SRAM_b1 - 76;
                    		n_sram_raddr_b5 = sram_raddr_b2 + 1 - DATA_NUM_PER_ROW_SRAM_b2 - 76;
                    		n_sram_raddr_b6 = sram_raddr_b0 + 1 - DATA_NUM_PER_ROW_SRAM_b0 - 76;
                    		n_sram_raddr_b7 = sram_raddr_b1 + 1 - DATA_NUM_PER_ROW_SRAM_b1 - 76;
                    		n_sram_raddr_b8 = sram_raddr_b2 + 1 - DATA_NUM_PER_ROW_SRAM_b2 - 76;
						end
						1 : begin
							n_sram_raddr_b0 = sram_raddr_b3 + 1 - 76;
                    		n_sram_raddr_b1 = sram_raddr_b4 + 1 - 76;
                    		n_sram_raddr_b2 = sram_raddr_b5 + 1 - 76;
                    		n_sram_raddr_b3 = sram_raddr_b3 + 1 - 76;
                    		n_sram_raddr_b4 = sram_raddr_b4 + 1 - 76;
                    		n_sram_raddr_b5 = sram_raddr_b5 + 1 - 76;
                    		n_sram_raddr_b6 = sram_raddr_b3 + 1 - DATA_NUM_PER_ROW_SRAM_b3 - 76;
                    		n_sram_raddr_b7 = sram_raddr_b4 + 1 - DATA_NUM_PER_ROW_SRAM_b4 - 76;
                    		n_sram_raddr_b8 = sram_raddr_b5 + 1 - DATA_NUM_PER_ROW_SRAM_b5 - 76;
						end
						2 : begin
							n_sram_raddr_b0 = sram_raddr_b6 + 1 - 76;
                			n_sram_raddr_b1 = sram_raddr_b7 + 1 - 76;
				            n_sram_raddr_b2 = sram_raddr_b8 + 1 - 76;
				            n_sram_raddr_b3 = sram_raddr_b6 + 1 - 76;
				            n_sram_raddr_b4 = sram_raddr_b7 + 1 - 76;
				            n_sram_raddr_b5 = sram_raddr_b8 + 1 - 76;
				            n_sram_raddr_b6 = sram_raddr_b6 + 1 - 76;
				            n_sram_raddr_b7 = sram_raddr_b7 + 1 - 76;
				            n_sram_raddr_b8 = sram_raddr_b8 + 1 - 76;
						end 
						3 : begin
							n_sram_raddr_b0 = 0;
        					n_sram_raddr_b1 = 0;
        					n_sram_raddr_b2 = 0;
		        			n_sram_raddr_b3 = 0;
		        			n_sram_raddr_b4 = 0;
		        			n_sram_raddr_b5 = 0;
		        			n_sram_raddr_b6 = 0;
		        			n_sram_raddr_b7 = 0;
		        			n_sram_raddr_b8 = 0;
						end
						default: begin
							n_sram_raddr_b0 = sram_raddr_b0;
                    		n_sram_raddr_b1 = sram_raddr_b1;
                    		n_sram_raddr_b2 = sram_raddr_b2;
                    		n_sram_raddr_b3 = sram_raddr_b3;
                    		n_sram_raddr_b4 = sram_raddr_b4;
                    		n_sram_raddr_b5 = sram_raddr_b5;
                    		n_sram_raddr_b6 = sram_raddr_b6;
                    		n_sram_raddr_b7 = sram_raddr_b7;
                    		n_sram_raddr_b8 = sram_raddr_b8;
						end
					endcase
				end				
				else begin
					case (col) 
					  	0 : begin
							n_sram_raddr_b0 = sram_raddr_b0 + 1 - 76; 
                    		n_sram_raddr_b1 = sram_raddr_b1 - 76;
                    		n_sram_raddr_b2 = sram_raddr_b2 - 76;
                    		n_sram_raddr_b3 = sram_raddr_b3 + 1 - 76;
                    		n_sram_raddr_b4 = sram_raddr_b4 - 76;
                    		n_sram_raddr_b5 = sram_raddr_b5 - 76;
                    		n_sram_raddr_b6 = sram_raddr_b6 + 1 - 76;
                    		n_sram_raddr_b7 = sram_raddr_b7 - 76;
                    		n_sram_raddr_b8 = sram_raddr_b8 - 76;
						end
						1 : begin
							n_sram_raddr_b0 = sram_raddr_b0 - 76;
                    		n_sram_raddr_b1 = sram_raddr_b1 + 1 - 76;
                    		n_sram_raddr_b2 = sram_raddr_b2 - 76;
                    		n_sram_raddr_b3 = sram_raddr_b3 - 76;
                    		n_sram_raddr_b4 = sram_raddr_b4 + 1 - 76;
                    		n_sram_raddr_b5 = sram_raddr_b5 - 76;
                    		n_sram_raddr_b6 = sram_raddr_b6 - 76;
                    		n_sram_raddr_b7 = sram_raddr_b7 + 1 - 76;
                    		n_sram_raddr_b8 = sram_raddr_b8 - 76;
						end
						2 : begin
							n_sram_raddr_b0 = sram_raddr_b0 - 76;
                    		n_sram_raddr_b1 = sram_raddr_b1 - 76;
                    		n_sram_raddr_b2 = sram_raddr_b2 + 1 - 76;
                    		n_sram_raddr_b3 = sram_raddr_b3 - 76;
                    		n_sram_raddr_b4 = sram_raddr_b4 - 76;
                    		n_sram_raddr_b5 = sram_raddr_b5 + 1 - 76;
                    		n_sram_raddr_b6 = sram_raddr_b6 - 76;
                    		n_sram_raddr_b7 = sram_raddr_b7 - 76;
                    		n_sram_raddr_b8 = sram_raddr_b8 + 1 - 76; 
						end 
					  	default: begin
							n_sram_raddr_b0 = sram_raddr_b0;
                    		n_sram_raddr_b1 = sram_raddr_b1;
                    		n_sram_raddr_b2 = sram_raddr_b2;
                    		n_sram_raddr_b3 = sram_raddr_b3;
                    		n_sram_raddr_b4 = sram_raddr_b4;
                    		n_sram_raddr_b5 = sram_raddr_b5;
                    		n_sram_raddr_b6 = sram_raddr_b6;
                    		n_sram_raddr_b7 = sram_raddr_b7;
                    		n_sram_raddr_b8 = sram_raddr_b8;
						end
					endcase
				end
			end
	  	default: begin
			n_sram_raddr_b0 = 0;
        	n_sram_raddr_b1 = 0;
        	n_sram_raddr_b2 = 0;
        	n_sram_raddr_b3 = 0;
        	n_sram_raddr_b4 = 0;
        	n_sram_raddr_b5 = 0;
        	n_sram_raddr_b6 = 0;
        	n_sram_raddr_b7 = 0;
        	n_sram_raddr_b8 = 0;
		end
	endcase
end

//assign data_sel = {data_sel_row[1:0] , data_sel_col[1:0]};
//assign data_sel = (mode == CONV1)? {data_sel_row[1:0] , data_sel_col[1:0]} : (mode == CONV2)? {row_delay[1:0], col_delay[1:0]} : 0;
assign data_sel = (mode == CONV1)? {data_sel_row[1:0] , data_sel_col[1:0]} : (mode == CONV2)? {row[1:0], col[1:0]} : 0;

always@* begin
	case (state)
		CONV_IDLE : n_box_sel = RESET_SEL_DATA;
		LOAD_CONV1_WRITE_DATA : begin
			case (data_sel)
				4'b0000: begin
					n_box_sel = SEL_DATA_TYPE1;
				end
				4'b0001: begin
				  	n_box_sel = SEL_DATA_TYPE2;
				end
				4'b0010: begin
				  	n_box_sel = SEL_DATA_TYPE3;
				end 
				4'b0100: begin
				  	n_box_sel = SEL_DATA_TYPE4;
				end
				4'b0101: begin
				  	n_box_sel = SEL_DATA_TYPE5;
				end
				4'b0110: begin
				  	n_box_sel = SEL_DATA_TYPE6;
				end
				4'b1000: begin
				  	n_box_sel = SEL_DATA_TYPE7;
				end
				4'b1001: begin
				  	n_box_sel = SEL_DATA_TYPE8;
				end
				4'b1010: begin
				  	n_box_sel = SEL_DATA_TYPE9;
				end 
			  default: n_box_sel = HOLD_DATA;
			endcase
		end
		LOAD_CONV2_WRITE_DATA, CONV2_NEXT_POOLING : begin
			case (data_sel)
				4'b0000: begin
					n_box_sel = SEL_DATA_TYPE1;
				end
				4'b0001: begin
				  	n_box_sel = SEL_DATA_TYPE2;
				end
				4'b0010: begin
				  	n_box_sel = SEL_DATA_TYPE3;
				end 
				4'b0011: begin
				  	n_box_sel = SEL_DATA_TYPE1;
				end 
				4'b0100: begin
				  	n_box_sel = SEL_DATA_TYPE4;
				end
				4'b0101: begin
				  	n_box_sel = SEL_DATA_TYPE5;
				end
				4'b0110: begin
				  	n_box_sel = SEL_DATA_TYPE6;
				end
				4'b0111: begin
				  	n_box_sel = SEL_DATA_TYPE4;
				end
				4'b1000: begin
				  	n_box_sel = SEL_DATA_TYPE7;
				end
				4'b1001: begin
				  	n_box_sel = SEL_DATA_TYPE8;
				end
				4'b1010: begin
				  	n_box_sel = SEL_DATA_TYPE9;
				end
				4'b1011: begin
				  	n_box_sel = SEL_DATA_TYPE7;
				end 
				4'b1100: begin
				  	n_box_sel = SEL_DATA_TYPE1;
				end
				4'b1101: begin
				  	n_box_sel = SEL_DATA_TYPE2;
				end
				4'b1110: begin
				  	n_box_sel = SEL_DATA_TYPE3;
				end
				4'b1111: begin
				  	n_box_sel = SEL_DATA_TYPE1;
				end 
			  default: n_box_sel = HOLD_DATA;
			endcase
		end
		default: n_box_sel = RESET_SEL_DATA;
	endcase
end
/*
always@* begin
	if((write_enable)&(mode == CONV1)) begin
	    if(write_col == 5) n_sram_waddr_b = delay1_sram_waddr_b + 1;
	    else if(write_col == 11) begin
	        if(write_row == 5 || write_row == 11) n_sram_waddr_b = delay1_sram_waddr_b + 1;                    
	        else n_sram_waddr_b = delay1_sram_waddr_b - 1;
	    end
	    else begin
	        n_sram_waddr_b = delay1_sram_waddr_b;
	    end
	end
	else if(mode == IDLE) begin
		n_sram_waddr_b = 0;
	end
	else begin
	    n_sram_waddr_b = delay1_sram_waddr_b;
	end
end*/
/*****/
always@* begin
	if((delay2_write_enable)&(mode == CONV1)) begin
	    if(write_col_conv1 == 5) n_sram_waddr_b = delay1_sram_waddr_b + 1;
	    else if(write_col_conv1 == 11) begin
	        if(write_row_conv1 == 5 || write_row_conv1 == 11) n_sram_waddr_b = delay1_sram_waddr_b + 1;                    
	        else n_sram_waddr_b = delay1_sram_waddr_b - 1;
	    end
	    else begin
	        n_sram_waddr_b = delay1_sram_waddr_b;
	    end
	end
	else if(mode == IDLE) begin
		n_sram_waddr_b = 0;
	end
	else begin
	    n_sram_waddr_b = delay1_sram_waddr_b;
	end
end
/*****/
always@(posedge clk) begin
	if(~srstn) begin
		sram_write_enable_b0 <= 1;
		sram_write_enable_b1 <= 1;
		sram_write_enable_b2 <= 1;
		sram_write_enable_b3 <= 1;
		sram_write_enable_b4 <= 1;
		sram_write_enable_b5 <= 1;
		sram_write_enable_b6 <= 1;
		sram_write_enable_b7 <= 1;
		sram_write_enable_b8 <= 1;

		/*delay_sram_write_enable_b0 <= 1;
		delay_sram_write_enable_b1 <= 1;
		delay_sram_write_enable_b2 <= 1;
		delay_sram_write_enable_b3 <= 1;
		delay_sram_write_enable_b4 <= 1;
		delay_sram_write_enable_b5 <= 1;
		delay_sram_write_enable_b6 <= 1;
		delay_sram_write_enable_b7 <= 1;
		delay_sram_write_enable_b8 <= 1;

		delay2_sram_write_enable_b0 <= 1;
		delay2_sram_write_enable_b1 <= 1;
		delay2_sram_write_enable_b2 <= 1;
		delay2_sram_write_enable_b3 <= 1;
		delay2_sram_write_enable_b4 <= 1;
		delay2_sram_write_enable_b5 <= 1;
		delay2_sram_write_enable_b6 <= 1;
		delay2_sram_write_enable_b7 <= 1;
		delay2_sram_write_enable_b8 <= 1;*/
	end
	else begin
		sram_write_enable_b0 <= n_sram_write_enable_b0;
		sram_write_enable_b1 <= n_sram_write_enable_b1;
		sram_write_enable_b2 <= n_sram_write_enable_b2;
		sram_write_enable_b3 <= n_sram_write_enable_b3;
		sram_write_enable_b4 <= n_sram_write_enable_b4;
		sram_write_enable_b5 <= n_sram_write_enable_b5;
		sram_write_enable_b6 <= n_sram_write_enable_b6;
		sram_write_enable_b7 <= n_sram_write_enable_b7;
		sram_write_enable_b8 <= n_sram_write_enable_b8;
		/*sram_write_enable_b0 <= delay2_sram_write_enable_b0;
		sram_write_enable_b1 <= delay2_sram_write_enable_b1;
		sram_write_enable_b2 <= delay2_sram_write_enable_b2;
		sram_write_enable_b3 <= delay2_sram_write_enable_b3;
		sram_write_enable_b4 <= delay2_sram_write_enable_b4;
		sram_write_enable_b5 <= delay2_sram_write_enable_b5;
		sram_write_enable_b6 <= delay2_sram_write_enable_b6;
		sram_write_enable_b7 <= delay2_sram_write_enable_b7;
		sram_write_enable_b8 <= delay2_sram_write_enable_b8;

		delay2_sram_write_enable_b0 <= delay_sram_write_enable_b0;
		delay2_sram_write_enable_b1 <= delay_sram_write_enable_b1;
		delay2_sram_write_enable_b2 <= delay_sram_write_enable_b2;
		delay2_sram_write_enable_b3 <= delay_sram_write_enable_b3;
		delay2_sram_write_enable_b4 <= delay_sram_write_enable_b4;
		delay2_sram_write_enable_b5 <= delay_sram_write_enable_b5;
		delay2_sram_write_enable_b6 <= delay_sram_write_enable_b6;
		delay2_sram_write_enable_b7 <= delay_sram_write_enable_b7;
		delay2_sram_write_enable_b8 <= delay_sram_write_enable_b8;

		delay_sram_write_enable_b0 <= n_sram_write_enable_b0;
		delay_sram_write_enable_b1 <= n_sram_write_enable_b1;
		delay_sram_write_enable_b2 <= n_sram_write_enable_b2;
		delay_sram_write_enable_b3 <= n_sram_write_enable_b3;
		delay_sram_write_enable_b4 <= n_sram_write_enable_b4;
		delay_sram_write_enable_b5 <= n_sram_write_enable_b5;
		delay_sram_write_enable_b6 <= n_sram_write_enable_b6;
		delay_sram_write_enable_b7 <= n_sram_write_enable_b7;
		delay_sram_write_enable_b8 <= n_sram_write_enable_b8;*/
	end
end

always@* begin
	if((delay2_write_enable)&(mode == CONV1)) begin
		case (write_row_conv1)
    /*if((write_enable)&(mode == CONV1)) begin
		case (write_row)*/
        	4'd0 ,4'd1,4'd6,4'd7: begin
        	    //case (write_col)
        	    case (write_col_conv1)
        	        4'd0 ,4'd1 ,4'd6 ,4'd7  : begin
        	            n_sram_write_enable_b0 = 0;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	        4'd2 ,4'd3 ,4'd8 ,4'd9  : begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 0;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	        4'd4 ,4'd5 ,4'd10,4'd11 : begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 0;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	        default: begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	    endcase
        	end
        	4'd2,4'd3,4'd8,4'd9 : begin
        	    //case (write_col)
        	    case (write_col_conv1)
        	        4'd0 ,4'd1 ,4'd6 ,4'd7  : begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 0;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	        4'd2 ,4'd3 ,4'd8 ,4'd9  : begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 0;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	        4'd4 ,4'd5 ,4'd10,4'd11 : begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 0;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	        default: begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	    endcase
	
        	end
        	4'd4,4'd5,4'd10,4'd11 : begin
        	    //case (write_col)
        	    case (write_col_conv1)
        	        4'd0 ,4'd1 ,4'd6 ,4'd7  : begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 0;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	        4'd2 ,4'd3 ,4'd8 ,4'd9  : begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 0;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	        4'd4 ,4'd5 ,4'd10,4'd11 : begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 0;
        	        end
        	        default: begin
        	            n_sram_write_enable_b0 = 1;
        	            n_sram_write_enable_b1 = 1;
        	            n_sram_write_enable_b2 = 1;
        	            n_sram_write_enable_b3 = 1;
        	            n_sram_write_enable_b4 = 1;
        	            n_sram_write_enable_b5 = 1;
        	            n_sram_write_enable_b6 = 1;
        	            n_sram_write_enable_b7 = 1;
        	            n_sram_write_enable_b8 = 1;
        	        end
        	    endcase
        	end
			default: begin
				n_sram_write_enable_b0 = 1;
        	    n_sram_write_enable_b1 = 1;
        	    n_sram_write_enable_b2 = 1;
        	    n_sram_write_enable_b3 = 1;
        	    n_sram_write_enable_b4 = 1;
        	    n_sram_write_enable_b5 = 1;
        	    n_sram_write_enable_b6 = 1;
        	    n_sram_write_enable_b7 = 1;
        	    n_sram_write_enable_b8 = 1;
			end
		endcase
    end
	else begin
		n_sram_write_enable_b0 = 1;
        n_sram_write_enable_b1 = 1;
        n_sram_write_enable_b2 = 1;
        n_sram_write_enable_b3 = 1;
        n_sram_write_enable_b4 = 1;
        n_sram_write_enable_b5 = 1;
        n_sram_write_enable_b6 = 1;
        n_sram_write_enable_b7 = 1;
        n_sram_write_enable_b8 = 1;
	end
end

always@* begin
	if(state == CONV2_NEXT_POOLING) begin
		if (addr_change == 19) n_addr_change = 0;
		else n_addr_change = addr_change + 1;
	end
	else if(state == CONV_IDLE) begin
		n_addr_change = 0;
	end
	else begin
		n_addr_change = addr_change;
	end
end
/*
always@* begin
	if(state == CONV2_NEXT_POOLING) begin
		if(addr_change == 19) begin
			if (mem_sel == 0) begin
				n_sram_waddr_c = delay1_sram_waddr_c + 1;
				n_sram_waddr_d = 0;
			end
			else begin
				n_sram_waddr_c = 0;
				n_sram_waddr_d = delay1_sram_waddr_d + 1;
			end
		end
		else begin
	        n_sram_waddr_c = delay1_sram_waddr_c;
	        n_sram_waddr_d = delay1_sram_waddr_d;
	    end
	end
	else if(state == CONV1_DONE) begin
		n_sram_waddr_c = 0;
	    n_sram_waddr_d = 0;
	end
	else begin
	    n_sram_waddr_c = delay1_sram_waddr_c;
	    n_sram_waddr_d = delay1_sram_waddr_d;
	end
end
*/
/*****/
always@* begin
	if(delay3_state == CONV2_NEXT_POOLING) begin
		if(delay3_addr_change == 19) begin
			if (mem_sel == 0) begin
				n_sram_waddr_c = delay1_sram_waddr_c + 1;
				n_sram_waddr_d = 0;
			end
			else begin
				n_sram_waddr_c = 0;
				n_sram_waddr_d = delay1_sram_waddr_d + 1;
			end
		end
		else begin
	        n_sram_waddr_c = delay1_sram_waddr_c;
	        n_sram_waddr_d = delay1_sram_waddr_d;
	    end
	end
	else if(delay3_state == CONV1_FINISH) begin
		n_sram_waddr_c = 0;
	    n_sram_waddr_d = 0;
	end
	else begin
	    n_sram_waddr_c = delay1_sram_waddr_c;
	    n_sram_waddr_d = delay1_sram_waddr_d;
	end
end
/*****/

always@(posedge clk) begin
	if(~srstn) begin
		sram_write_enable_c0 <= 1;
		sram_write_enable_c1 <= 1;
		sram_write_enable_c2 <= 1;
		sram_write_enable_c3 <= 1;
		sram_write_enable_c4 <= 1;
		
		sram_write_enable_d0 <= 1;
		sram_write_enable_d1 <= 1;
		sram_write_enable_d2 <= 1;
		sram_write_enable_d3 <= 1;
		sram_write_enable_d4 <= 1;

		/*delay_sram_write_enable_c0 <= 1;
		delay_sram_write_enable_c1 <= 1;
		delay_sram_write_enable_c2 <= 1;
		delay_sram_write_enable_c3 <= 1;
		delay_sram_write_enable_c4 <= 1;
		
		delay_sram_write_enable_d0 <= 1;
		delay_sram_write_enable_d1 <= 1;
		delay_sram_write_enable_d2 <= 1;
		delay_sram_write_enable_d3 <= 1;
		delay_sram_write_enable_d4 <= 1;*/
	end
	else begin
		sram_write_enable_c0 <= n_sram_write_enable_c0;
		sram_write_enable_c1 <= n_sram_write_enable_c1;
		sram_write_enable_c2 <= n_sram_write_enable_c2;
		sram_write_enable_c3 <= n_sram_write_enable_c3;
		sram_write_enable_c4 <= n_sram_write_enable_c4;
		
		sram_write_enable_d0 <= n_sram_write_enable_d0;
		sram_write_enable_d1 <= n_sram_write_enable_d1;
		sram_write_enable_d2 <= n_sram_write_enable_d2;
		sram_write_enable_d3 <= n_sram_write_enable_d3;
		sram_write_enable_d4 <= n_sram_write_enable_d4;

		/*sram_write_enable_c0 <= delay_sram_write_enable_c0;
		sram_write_enable_c1 <= delay_sram_write_enable_c1;
		sram_write_enable_c2 <= delay_sram_write_enable_c2;
		sram_write_enable_c3 <= delay_sram_write_enable_c3;
		sram_write_enable_c4 <= delay_sram_write_enable_c4;
		
		sram_write_enable_d0 <= delay_sram_write_enable_d0;
		sram_write_enable_d1 <= delay_sram_write_enable_d1;
		sram_write_enable_d2 <= delay_sram_write_enable_d2;
		sram_write_enable_d3 <= delay_sram_write_enable_d3;
		sram_write_enable_d4 <= delay_sram_write_enable_d4;

		delay_sram_write_enable_c0 <= n_sram_write_enable_c0;
		delay_sram_write_enable_c1 <= n_sram_write_enable_c1;
		delay_sram_write_enable_c2 <= n_sram_write_enable_c2;
		delay_sram_write_enable_c3 <= n_sram_write_enable_c3;
		delay_sram_write_enable_c4 <= n_sram_write_enable_c4;
		
		delay_sram_write_enable_d0 <= n_sram_write_enable_d0;
		delay_sram_write_enable_d1 <= n_sram_write_enable_d1;
		delay_sram_write_enable_d2 <= n_sram_write_enable_d2;
		delay_sram_write_enable_d3 <= n_sram_write_enable_d3;
		delay_sram_write_enable_d4 <= n_sram_write_enable_d4;*/
	end
end

always@* begin
	if((delay3_write_enable)&(mode == CONV2))begin
		case(delay3_addr_change)
	/*if((write_enable)&(mode == CONV2))begin
		case(addr_change)*/
	/*if((delay2_write_enable)&(mode == CONV2))begin
		case(delay2_addr_change)*/
			5'd0, 5'd1, 5'd2, 5'd3: begin
				if(mem_sel == 0) begin
					n_sram_write_enable_c0 = 0;
        	        n_sram_write_enable_c1 = 1;
        	        n_sram_write_enable_c2 = 1;
        	        n_sram_write_enable_c3 = 1;
        	        n_sram_write_enable_c4 = 1;

        	        n_sram_write_enable_d0 = 1;
        	        n_sram_write_enable_d1 = 1;
        	        n_sram_write_enable_d2 = 1;
        	        n_sram_write_enable_d3 = 1;
        	        n_sram_write_enable_d4 = 1;
				end
				else begin
					n_sram_write_enable_c0 = 1;
        	        n_sram_write_enable_c1 = 1;
        	        n_sram_write_enable_c2 = 1;
        	        n_sram_write_enable_c3 = 1;
        	        n_sram_write_enable_c4 = 1;

        	        n_sram_write_enable_d0 = 0;
        	        n_sram_write_enable_d1 = 1;
        	        n_sram_write_enable_d2 = 1;
        	        n_sram_write_enable_d3 = 1;
        	        n_sram_write_enable_d4 = 1;
				end
			end
			5'd4, 5'd5, 5'd6, 5'd7: begin
				if(mem_sel == 0) begin
					n_sram_write_enable_c0 = 1;
        	        n_sram_write_enable_c1 = 0;
        	        n_sram_write_enable_c2 = 1;
        	        n_sram_write_enable_c3 = 1;
        	        n_sram_write_enable_c4 = 1;

        	        n_sram_write_enable_d0 = 1;
        	        n_sram_write_enable_d1 = 1;
        	        n_sram_write_enable_d2 = 1;
        	        n_sram_write_enable_d3 = 1;
        	        n_sram_write_enable_d4 = 1;
				end
				else begin
					n_sram_write_enable_c0 = 1;
        	        n_sram_write_enable_c1 = 1;
        	        n_sram_write_enable_c2 = 1;
        	        n_sram_write_enable_c3 = 1;
        	        n_sram_write_enable_c4 = 1;

        	        n_sram_write_enable_d0 = 1;
        	        n_sram_write_enable_d1 = 0;
        	        n_sram_write_enable_d2 = 1;
        	        n_sram_write_enable_d3 = 1;
        	        n_sram_write_enable_d4 = 1;
				end
			end
			5'd8, 5'd9, 5'd10, 5'd11: begin
				if(mem_sel == 0) begin
					n_sram_write_enable_c0 = 1;
        	        n_sram_write_enable_c1 = 1;
        	        n_sram_write_enable_c2 = 0;
        	        n_sram_write_enable_c3 = 1;
        	        n_sram_write_enable_c4 = 1;

        	        n_sram_write_enable_d0 = 1;
        	        n_sram_write_enable_d1 = 1;
        	        n_sram_write_enable_d2 = 1;
        	        n_sram_write_enable_d3 = 1;
        	        n_sram_write_enable_d4 = 1;
				end
				else begin
					n_sram_write_enable_c0 = 1;
        	        n_sram_write_enable_c1 = 1;
        	        n_sram_write_enable_c2 = 1;
        	        n_sram_write_enable_c3 = 1;
        	        n_sram_write_enable_c4 = 1;

        	        n_sram_write_enable_d0 = 1;
        	        n_sram_write_enable_d1 = 1;
        	        n_sram_write_enable_d2 = 0;
        	        n_sram_write_enable_d3 = 1;
        	        n_sram_write_enable_d4 = 1;
				end
			end
			5'd12, 5'd13, 5'd14, 5'd15: begin
				if(mem_sel == 0) begin
					n_sram_write_enable_c0 = 1;
        	        n_sram_write_enable_c1 = 1;
        	        n_sram_write_enable_c2 = 1;
        	        n_sram_write_enable_c3 = 0;
        	        n_sram_write_enable_c4 = 1;

        	        n_sram_write_enable_d0 = 1;
        	        n_sram_write_enable_d1 = 1;
        	        n_sram_write_enable_d2 = 1;
        	        n_sram_write_enable_d3 = 1;
        	        n_sram_write_enable_d4 = 1;
				end
				else begin
					n_sram_write_enable_c0 = 1;
        	        n_sram_write_enable_c1 = 1;
        	        n_sram_write_enable_c2 = 1;
        	        n_sram_write_enable_c3 = 1;
        	        n_sram_write_enable_c4 = 1;

        	        n_sram_write_enable_d0 = 1;
        	        n_sram_write_enable_d1 = 1;
        	        n_sram_write_enable_d2 = 1;
        	        n_sram_write_enable_d3 = 0;
        	        n_sram_write_enable_d4 = 1;
				end
			end
			5'd16, 5'd17, 5'd18, 5'd19: begin
				if(mem_sel == 0) begin
					n_sram_write_enable_c0 = 1;
        	        n_sram_write_enable_c1 = 1;
        	        n_sram_write_enable_c2 = 1;
        	        n_sram_write_enable_c3 = 1;
        	        n_sram_write_enable_c4 = 0;

        	        n_sram_write_enable_d0 = 1;
        	        n_sram_write_enable_d1 = 1;
        	        n_sram_write_enable_d2 = 1;
        	        n_sram_write_enable_d3 = 1;
        	        n_sram_write_enable_d4 = 1;
				end
				else begin
					n_sram_write_enable_c0 = 1;
        	        n_sram_write_enable_c1 = 1;
        	        n_sram_write_enable_c2 = 1;
        	        n_sram_write_enable_c3 = 1;
        	        n_sram_write_enable_c4 = 1;

        	        n_sram_write_enable_d0 = 1;
        	        n_sram_write_enable_d1 = 1;
        	        n_sram_write_enable_d2 = 1;
        	        n_sram_write_enable_d3 = 1;
        	        n_sram_write_enable_d4 = 0;
				end
			end
			default: begin
				n_sram_write_enable_c0 = 1;
        	    n_sram_write_enable_c1 = 1;
        	    n_sram_write_enable_c2 = 1;
        	    n_sram_write_enable_c3 = 1;
        	    n_sram_write_enable_c4 = 1;

        	    n_sram_write_enable_d0 = 1;
        	    n_sram_write_enable_d1 = 1;
        	    n_sram_write_enable_d2 = 1;
        	    n_sram_write_enable_d3 = 1;
        	    n_sram_write_enable_d4 = 1;
			end
		endcase
	end
	else begin
		n_sram_write_enable_c0 = 1;
        n_sram_write_enable_c1 = 1;
        n_sram_write_enable_c2 = 1;
        n_sram_write_enable_c3 = 1;
        n_sram_write_enable_c4 = 1;

        n_sram_write_enable_d0 = 1;
        n_sram_write_enable_d1 = 1;
        n_sram_write_enable_d2 = 1;
        n_sram_write_enable_d3 = 1;
        n_sram_write_enable_d4 = 1;
	end
end

// Based on write_row and write_col are odd or even?
//assign bytemask_sel = (mode == CONV1)? {write_row[0],write_col[0]} : (mode == CONV2)? write_col[1:0] : 0;
//assign bytemask_sel = (mode == CONV1)? {write_row_conv1[0],write_col_conv1[0]} : (mode == CONV2)? write_col[1:0] : 0;
assign bytemask_sel = (mode == CONV1)? {write_row_conv1[0],write_col_conv1[0]} : (mode == CONV2)? col_enable[1:0] : 0;
/*
always@* begin
	if((write_enable)&(mode == CONV1)) begin
		case (bytemask_sel)
			2'b00 : n_sram_bytemask_b = 4'b1000;
    		2'b01 : n_sram_bytemask_b = 4'b0100;
    		2'b10 : n_sram_bytemask_b = 4'b0010;
    		2'b11 : n_sram_bytemask_b = 4'b0001;
		  	default: n_sram_bytemask_b = 4'b0000;
		endcase
    end
    else begin
		n_sram_bytemask_b = 4'b0000;
	end
end
*/
/*****/
always@* begin
	if((delay2_write_enable)&(mode == CONV1)) begin
		case (bytemask_sel)
			2'b00 : n_sram_bytemask_b = 4'b1000;
    		2'b01 : n_sram_bytemask_b = 4'b0100;
    		2'b10 : n_sram_bytemask_b = 4'b0010;
    		2'b11 : n_sram_bytemask_b = 4'b0001;
		  	default: n_sram_bytemask_b = 4'b0000;
		endcase
    end
    else begin
		n_sram_bytemask_b = 4'b0000;
	end
end
/*****/
always@* begin
	//if((write_enable)&(mode == CONV2)) begin
	if(mode == CONV2) begin
		if (mem_sel == 0) begin
			n_sram_bytemask_d = 4'b0000;
			case (bytemask_sel)
				2'b00 : n_sram_bytemask_c = 4'b1000;
	    		2'b01 : n_sram_bytemask_c = 4'b0100;
	    		2'b10 : n_sram_bytemask_c = 4'b0010;
	    		2'b11 : n_sram_bytemask_c = 4'b0001;
			  	default: n_sram_bytemask_c = 4'b0000;
			endcase
		end
		else begin
			n_sram_bytemask_c = 4'b0000;
			case (bytemask_sel)
				2'b00 : n_sram_bytemask_d = 4'b1000;
	    		2'b01 : n_sram_bytemask_d = 4'b0100;
	    		2'b10 : n_sram_bytemask_d = 4'b0010;
	    		2'b11 : n_sram_bytemask_d = 4'b0001;
			  	default: n_sram_bytemask_d = 4'b0000;
			endcase
		end
	end
	else begin
		n_sram_bytemask_c = 4'b0000;
		n_sram_bytemask_d = 4'b0000;
	end
end

endmodule