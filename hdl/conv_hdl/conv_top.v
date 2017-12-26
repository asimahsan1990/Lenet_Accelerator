/**
 * Editor : 
 * File : conv_top.v
 */
module conv_top#(
    parameter WEIGHT_WIDTH = 4,
    parameter WEIGHT_NUM = 25,
    parameter DATA_WIDTH = 8,
    parameter DATA_NUM_PER_SRAM_ADDR = 4
)
(
input clk,							//clock input
input srstn,						//synchronous reset (active low)
input start,						//1: start (one-cycle pulse)

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
input [WEIGHT_NUM*WEIGHT_WIDTH-1:0] sram_rdata_weight,
// Read address for weight and bias
output [16:0] sram_raddr_weight,

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

output conv1_done,
output conv2_done,
output mem_sel
);


endmodule