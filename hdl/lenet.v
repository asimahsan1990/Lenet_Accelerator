/**
 * Editor : Steven
 * File : lenet.v
 */

module lenet#(
    parameter WEIGHT_WIDTH = 4,
    parameter WEIGHT_NUM = 25,
    parameter DATA_WIDTH = 8,
    parameter DATA_NUM_PER_SRAM_ADDR = 4
)
(
input clk,
input srstn,
/***** conv_top *****/
input conv_start,
// Derive data from SRAM_a
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_a0,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_a1,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_a2,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_a3,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_a4,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_a5,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_a6,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_a7,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_a8,
// Derive data from SRAM_b
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_b0,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_b1,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_b2,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_b3,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_b4,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_b5,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_b6,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_b7,
input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_b8,
// Derive weight and bias
input [WEIGHT_NUM*WEIGHT_WIDTH-1:0] conv_sram_rdata_weight,
output [16:0] conv_sram_raddr_weight,
// Read address for SRAM_a
output [9:0] sram_raddr_a0,
output [9:0] sram_raddr_a1,
output [9:0] sram_raddr_a2,
output [9:0] sram_raddr_a3,
output [9:0] sram_raddr_a4,
output [9:0] sram_raddr_a5,
output [9:0] sram_raddr_a6,
output [9:0] sram_raddr_a7,
output [9:0] sram_raddr_a8,
// Write_enable for SRAM_b
output sram_write_enable_b0,
output sram_write_enable_b1,
output sram_write_enable_b2,
output sram_write_enable_b3,
output sram_write_enable_b4,
output sram_write_enable_b5,
output sram_write_enable_b6,
output sram_write_enable_b7,
output sram_write_enable_b8,

output [3:0] sram_bytemask_b,
output [9:0] sram_waddr_b,
output [7:0] sram_wdata_b,

// Read address for SRAM_b
output [9:0] sram_raddr_b0,
output [9:0] sram_raddr_b1,
output [9:0] sram_raddr_b2,
output [9:0] sram_raddr_b3,
output [9:0] sram_raddr_b4,
output [9:0] sram_raddr_b5,
output [9:0] sram_raddr_b6,
output [9:0] sram_raddr_b7,
output [9:0] sram_raddr_b8,
// Write_enable for SRAM_c
output sram_write_enable_c0,
output sram_write_enable_c1,
output sram_write_enable_c2,
output sram_write_enable_c3,
output sram_write_enable_c4,

output [3:0] sram_bytemask_c,
output [9:0] sram_waddr_c,
output [7:0] sram_wdata_c,

// Write_enable for SRAM_d
output sram_write_enable_d0,
output sram_write_enable_d1,
output sram_write_enable_d2,
output sram_write_enable_d3,
output sram_write_enable_d4,

output [3:0] sram_bytemask_d,
output [9:0] sram_waddr_d,
output [7:0] sram_wdata_d,

output conv_done,
output mem_sel,	

input [31:0] sram_rdata_c0,
input [31:0] sram_rdata_c1,
input [31:0] sram_rdata_c2,
input [31:0] sram_rdata_c3,
input [31:0] sram_rdata_c4,

output [5:0] sram_raddr_c0,
output [5:0] sram_raddr_c1,
output [5:0] sram_raddr_c2,
output [5:0] sram_raddr_c3,
output [5:0] sram_raddr_c4,

input [31:0] sram_rdata_d0,
input [31:0] sram_rdata_d1,
input [31:0] sram_rdata_d2,
input [31:0] sram_rdata_d3,
input [31:0] sram_rdata_d4,

output [5:0] sram_raddr_d0,
output [5:0] sram_raddr_d1,
output [5:0] sram_raddr_d2,
output [5:0] sram_raddr_d3,
output [5:0] sram_raddr_d4,

input [31:0] sram_rdata_e0,
input [31:0] sram_rdata_e1,
input [31:0] sram_rdata_e2,
input [31:0] sram_rdata_e3,
input [31:0] sram_rdata_e4,

output [4:0] sram_raddr_e0,
output [4:0] sram_raddr_e1,
output [4:0] sram_raddr_e2,
output [4:0] sram_raddr_e3,
output [4:0] sram_raddr_e4,

output sram_write_enable_e0,
output sram_write_enable_e1,
output sram_write_enable_e2,
output sram_write_enable_e3,
output sram_write_enable_e4,
output [3:0] sram_bytemask_e,
output [4:0] sram_waddr_e,
output [7:0] sram_wdata_e,

output sram_write_enable_f,
output [3:0] sram_bytemask_f,
output [1:0] sram_waddr_f,
output [7:0] sram_wdata_f,

input [79:0] fc_sram_rdata_weight,
output [14:0] fc_sram_raddr_weight,
output fc1_done,
output fc2_done
);

conv_top conv_top
(
.clk(clk),
.srstn(srstn),
.conv_start(conv_start),
.sram_raddr_weight(conv_sram_raddr_weight),
.sram_rdata_weight(conv_sram_rdata_weight),
.sram_raddr_a0(sram_raddr_a0),
.sram_raddr_a1(sram_raddr_a1),
.sram_raddr_a2(sram_raddr_a2),
.sram_raddr_a3(sram_raddr_a3),
.sram_raddr_a4(sram_raddr_a4),
.sram_raddr_a5(sram_raddr_a5),
.sram_raddr_a6(sram_raddr_a6),
.sram_raddr_a7(sram_raddr_a7),
.sram_raddr_a8(sram_raddr_a8),
.sram_rdata_a0(sram_rdata_a0),
.sram_rdata_a1(sram_rdata_a1),
.sram_rdata_a2(sram_rdata_a2),
.sram_rdata_a3(sram_rdata_a3),
.sram_rdata_a4(sram_rdata_a4),
.sram_rdata_a5(sram_rdata_a5),
.sram_rdata_a6(sram_rdata_a6),
.sram_rdata_a7(sram_rdata_a7),
.sram_rdata_a8(sram_rdata_a8),
.sram_write_enable_b0(sram_write_enable_b0),
.sram_write_enable_b1(sram_write_enable_b1),
.sram_write_enable_b2(sram_write_enable_b2),
.sram_write_enable_b3(sram_write_enable_b3),
.sram_write_enable_b4(sram_write_enable_b4),
.sram_write_enable_b5(sram_write_enable_b5),
.sram_write_enable_b6(sram_write_enable_b6),
.sram_write_enable_b7(sram_write_enable_b7),
.sram_write_enable_b8(sram_write_enable_b8),
.sram_raddr_b0(sram_raddr_b0),
.sram_raddr_b1(sram_raddr_b1),
.sram_raddr_b2(sram_raddr_b2),
.sram_raddr_b3(sram_raddr_b3),
.sram_raddr_b4(sram_raddr_b4),
.sram_raddr_b5(sram_raddr_b5),
.sram_raddr_b6(sram_raddr_b6),
.sram_raddr_b7(sram_raddr_b7),
.sram_raddr_b8(sram_raddr_b8),
.sram_bytemask_b(sram_bytemask_b),
.sram_waddr_b(sram_waddr_b),
.sram_wdata_b(sram_wdata_b),
.sram_rdata_b0(sram_rdata_b0),
.sram_rdata_b1(sram_rdata_b1),
.sram_rdata_b2(sram_rdata_b2),
.sram_rdata_b3(sram_rdata_b3),
.sram_rdata_b4(sram_rdata_b4),
.sram_rdata_b5(sram_rdata_b5),
.sram_rdata_b6(sram_rdata_b6),
.sram_rdata_b7(sram_rdata_b7),
.sram_rdata_b8(sram_rdata_b8),
.sram_write_enable_c0(sram_write_enable_c0),
.sram_write_enable_c1(sram_write_enable_c1),
.sram_write_enable_c2(sram_write_enable_c2),
.sram_write_enable_c3(sram_write_enable_c3),
.sram_write_enable_c4(sram_write_enable_c4),
.sram_bytemask_c(sram_bytemask_c),
.sram_waddr_c(sram_waddr_c),
.sram_wdata_c(sram_wdata_c),
.sram_write_enable_d0(sram_write_enable_d0),
.sram_write_enable_d1(sram_write_enable_d1),
.sram_write_enable_d2(sram_write_enable_d2),
.sram_write_enable_d3(sram_write_enable_d3),
.sram_write_enable_d4(sram_write_enable_d4),
.sram_bytemask_d(sram_bytemask_d),
.sram_waddr_d(sram_waddr_d),
.sram_wdata_d(sram_wdata_d),
.conv_done(conv_done),
.mem_sel(mem_sel)
);

fc_top fc_top
(
.clk(clk),
.srstn(srstn),
.conv_done(conv_done),
.mem_sel(mem_sel),

//Read SRAM c0~c4
.sram_rdata_c0(sram_rdata_c0),
.sram_rdata_c1(sram_rdata_c1),
.sram_rdata_c2(sram_rdata_c2),
.sram_rdata_c3(sram_rdata_c3),
.sram_rdata_c4(sram_rdata_c4),

.sram_raddr_c0(sram_raddr_c0),
.sram_raddr_c1(sram_raddr_c1),
.sram_raddr_c2(sram_raddr_c2),
.sram_raddr_c3(sram_raddr_c3),
.sram_raddr_c4(sram_raddr_c4),

//Read SRAM d0~d4
.sram_rdata_d0(sram_rdata_d0),
.sram_rdata_d1(sram_rdata_d1),
.sram_rdata_d2(sram_rdata_d2),
.sram_rdata_d3(sram_rdata_d3),
.sram_rdata_d4(sram_rdata_d4),

.sram_raddr_d0(sram_raddr_d0),
.sram_raddr_d1(sram_raddr_d1),
.sram_raddr_d2(sram_raddr_d2),
.sram_raddr_d3(sram_raddr_d3),
.sram_raddr_d4(sram_raddr_d4),

//Read SRAM e0~e4
.sram_rdata_e0(sram_rdata_e0),
.sram_rdata_e1(sram_rdata_e1),
.sram_rdata_e2(sram_rdata_e2),
.sram_rdata_e3(sram_rdata_e3),
.sram_rdata_e4(sram_rdata_e4),

.sram_raddr_e0(sram_raddr_e0),
.sram_raddr_e1(sram_raddr_e1),
.sram_raddr_e2(sram_raddr_e2),
.sram_raddr_e3(sram_raddr_e3),
.sram_raddr_e4(sram_raddr_e4),

//Write SRAM e0~e4
.sram_write_enable_e0(sram_write_enable_e0),
.sram_write_enable_e0(sram_write_enable_e1),
.sram_write_enable_e0(sram_write_enable_e2),
.sram_write_enable_e0(sram_write_enable_e3),
.sram_write_enable_e0(sram_write_enable_e4),
.sram_bytemask_e(sram_bytemask_e),
.sram_waddr_e(sram_waddr_e),
.sram_wdata_e(sram_wdata_e),

//Write SRAM f
.sram_write_enable_f(sram_write_enable_f),
.sram_bytemask_f(sram_bytemask_f),
.sram_waddr_f(sram_waddr_f),
.sram_wdata_f(sram_wdata_f),

//FC weight
.sram_rdata_weight(fc_sram_rdata_weight),		//load fc weight
.sram_raddr_weight(fc_sram_raddr_weight),       //read address from SRAM weight

//FC done signal
.fc1_done(fc1_done),
.fc2_done(fc2_done)
);