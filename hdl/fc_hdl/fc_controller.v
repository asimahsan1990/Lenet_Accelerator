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

output reg accumulate_reset,	//connect to multiplier_accumulator
output reg fc_state,
output reg [1:0] sram_sel,			//select to read sram c, sram d or sram e

//Read c/d sram addr
output reg [9:0] sram_raddr_c0,
output reg [9:0] sram_raddr_c1,
output reg [9:0] sram_raddr_c2,
output reg [9:0] sram_raddr_c3,
output reg [9:0] sram_raddr_c4,
output reg [9:0] sram_raddr_d0,
output reg [9:0] sram_raddr_d1,
output reg [9:0] sram_raddr_d2,
output reg [9:0] sram_raddr_d3,
output reg [9:0] sram_raddr_d4,

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
output reg[WEIGHT_ADDR_WIDTH-1:0] sram_raddr_weight,

//fc_done signal
output reg fc1_done,
output reg fc2_done
);

localparam IDLE = 0, PRE_FETCH = 1, FC_1 = 2, FC_2 = 3; DONE = 4;

reg [1:0] state, n_state;

//switch signal
reg fetch_data_start;
reg fetch_done, n_fetch_done;
reg n_fc1_done;
reg n_fc2_done;

reg busy, n_busy;


//FSM
always@* begin
	case(state)
		IDLE: n_state = (fetch_data_start)? PRE_FETCH : IDLE; 
		PRE_FETCH: n_state = (fetch_done)? FC_1 : PRE_FETCH;
		FC_1: n_state = (fc1_done)? FC_2 : FC_1;			//switch to FC_2 after the outputs of FC_1 are all stored well in e sram
		FC_2: n_state = (fc2_done)? IDLE : FC_2;			//switch to IDLE after the outputs of FC_2 are all stored well in f sram
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
