`timescale 1ns/100ps

`define PAT_START_NO 0
`define PAT_END_NO   2

`define cycle_period 10

module test_top;

localparam SRAM_DATA_WIDTH = 32;
localparam WEIGHT_NUM = 25, WEIGHT_WIDTH = 4;

//====== module I/O =====
reg clk;
reg srstn;
