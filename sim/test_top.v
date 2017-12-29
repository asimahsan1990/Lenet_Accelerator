`timescale 1ns/100ps

`define PAT_START_NO 0
`define PAT_END_NO   2

`define cycle_period 10

module test_top;

localparam SRAM_DATA_WIDTH = 32;
localparam CONV_WEIGHT_NUM = 25, WEIGHT_WIDTH = 4;
localparam FC_WEIGHT_NUM = 20;

//====== module I/O =====
reg clk;
reg srstn;

reg conv_start;

wire conv_done;	 // conv_finish for testing if conv2(remember to set mem_sel)
				 // mem_sel(1:c0~c4| 0:d0~d4)
wire mem_sel;

wire [CONV_WEIGHT_NUM*WEIGHT_WIDTH-1:0] sram_rdata_weight;
wire [16:0] conv_sram_raddr_weight;       //read address to weight SRAM
reg [16:0] sram_raddr_weight;             //read address to weight SRAM

wire sram_write_enable_a0;
wire sram_write_enable_a1;
wire sram_write_enable_a2;
wire sram_write_enable_a3;
wire sram_write_enable_a4;
wire sram_write_enable_a5;
wire sram_write_enable_a6;
wire sram_write_enable_a7;
wire sram_write_enable_a8;

wire sram_write_enable_b0;
wire sram_write_enable_b1;
wire sram_write_enable_b2;
wire sram_write_enable_b3;
wire sram_write_enable_b4;
wire sram_write_enable_b5;
wire sram_write_enable_b6;
wire sram_write_enable_b7;
wire sram_write_enable_b8;

wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a0;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a1;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a2;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a3;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a4;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a5;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a6;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a7;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a8;