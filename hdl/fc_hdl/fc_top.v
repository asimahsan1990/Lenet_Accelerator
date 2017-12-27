/**
 * Editor : Steven
 * File : fc_top.v
 */
module fc_top#(
	parameter WEIGHT_WIDTH = 4,
    parameter WEIGHT_NUM = 20,
    parameter DATA_WIDTH = 8,
    parameter DATA_NUM_PER_SRAM_ADDR = 4,
    parameter WEIGHT_ADDR_WIDTH = 15
)
(
input clk,
input srstn,
input fc_start,		//connect conv_done wire from CONV module

input mem_sel,		//CONV selects SRAM c or SRAM d as the output SRAM
					//mem_sel = 1: c, mem_sel = 0: d
					//so fc_top must catch input data from the one which is not being written by CONV

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

//Write SRAM f
output sram_write_enable_f,
output [3:0] sram_bytemask_f,
output [9:0] sram_waddr_f,
output [7:0] sram_wdata_f,

//FC weight
input [WEIGHT_NUM*WEIGHT_WIDTH-1:0] sram_rdata_weight,		//load fc weight
output [WEIGHT_ADDR_WIDTH-1:0] sram_raddr_weight,       //read address from SRAM weight

//FC done signal
output fc_done
);

//wire announcement
wire [20*8-1:0] src_window;
wire [20*4-1:0] sram_rdata_weight;
wire accumulate_reset;
wire signed [31:0] data_out;		//bit number > 8+4+10=22 is enough
wire signed [7:0] quantized_data
wire [1:0] sram_sel;


//module
data_reg data_reg(
.clk(clk),
.srstn(srstn),
.sram_rdata_c0(sram_rdata_c0),
.sram_rdata_c1(sram_rdata_c1),
.sram_rdata_c2(sram_rdata_c2),
.sram_rdata_c3(sram_rdata_c3),
.sram_rdata_c4(sram_rdata_c4),
.sram_rdata_d0(sram_rdata_d0),
.sram_rdata_d1(sram_rdata_d1),
.sram_rdata_d2(sram_rdata_d2),
.sram_rdata_d3(sram_rdata_d3),
.sram_rdata_d4(sram_rdata_d4),
.sram_rdata_e0(sram_rdata_e0),
.sram_rdata_e1(sram_rdata_e1),
.sram_rdata_e2(sram_rdata_e2),
.sram_rdata_e3(sram_rdata_e3),
.sram_rdata_e4(sram_rdata_e4),
.sram_sel(sram_sel),						//From controller, to select c, d or e SRAM
.src_window(src_window)
);

multiplier_accumulator multiplier_accumulator(
.clk(clk),
.srstn(srstn),
.src_window(src_window),
.sram_rdata_weight(sram_rdata_weight),
.accumulate_reset(accumulate_reset),		//From controller
.data_out(data_out)							//bit number > 8+4+10=22 is enough
);

quantize quantize(
.clk(clk),
.srstn(srstn),
.fc_state(fc_state),						//From controller, fc_state = 0: fc1, fc_state = 1: fc2
.unquautized_data(data_out),
.quantized_data(quantized_data)
);
endmodule