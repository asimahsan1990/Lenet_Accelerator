/**
 * Editor : Steven
 * File : fc_top.v
 */
module fc_top#(
	parameter WEIGHT_WIDTH = 4,
    parameter WEIGHT_NUM = 20,
    parameter DATA_WIDTH = 8,
    parameter DATA_NUM_PER_SRAM_ADDR = 4
    parameter WEIGHT_ADDR_WIDTH = 15
)
(
input clk,
input srstn,
input fc_start,		//connect conv_done wire from CONV module
input mem_sel,		//select SRAM c or SRAM d as the input

//Read SRAM c0~c4
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c0,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c1,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c2,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c3,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c4,
output [9:0] sram_raddr_c0,
output [9:0] sram_raddr_c1,
output [9:0] sram_raddr_c2,
output [9:0] sram_raddr_c3,
output [9:0] sram_raddr_c4,

//Read SRAM d0~d4
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d0,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d1,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d2,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d3,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d4,
output [9:0] sram_raddr_d0,
output [9:0] sram_raddr_d1,
output [9:0] sram_raddr_d2,
output [9:0] sram_raddr_d3,
output [9:0] sram_raddr_d4,

//Read SRAM e0~e4
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e0,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e1,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e2,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e3,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e4,
output [9:0] sram_raddr_e0,
output [9:0] sram_raddr_e1,
output [9:0] sram_raddr_e2,
output [9:0] sram_raddr_e3,
output [9:0] sram_raddr_e4,

//Write SRAM e0~e4
output sram_write_enable_e0,
output sram_write_enable_e1,
output sram_write_enable_e2,
output sram_write_enable_e3,
output sram_write_enable_e4,
output [3:0] sram_bytemask_e,
output [9:0] sram_waddr_e,
output [7:0] sram_wdata_e,

//FC weight
input [WEIGHT_NUM*WEIGHT_WIDTH-1:0] sram_rdata_weight,		//load fc weight
output [WEIGHT_ADDR_WIDTH-1:0] sram_raddr_weight,       //read address from SRAM weight

//FC done signal
output fc_done
);

//Wire announcement

wire [20*8-1:0] src_window,
wire [20*4-1:0] sram_rdata_weight,
wire accumulate_reset,
wire signed [31:0] data_out		//bit number > 8+4+10=22 is enough




multiplier_accumulator multiplier_accumulator(
.clk(clk),
.srstn(srstn),
.src_window(src_window),
.sram_rdata_weight(sram_rdata_weight),
.accumulate_reset(accumulate_reset),
.data_out(data_out)		//bit number > 8+4+10=22 is enough
);

endmodule