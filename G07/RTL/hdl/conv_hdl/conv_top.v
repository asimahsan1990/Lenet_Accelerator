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
input conv_start,						//1: start (one-cycle pulse)
input fc_done,

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
output conv_done,
output mem_sel								// 1: c0 ~ c4, 0: d0 ~ d4
);

localparam  IDLE = 0, CONV1 = 1, CONV2 = 2, DONE = 3;

wire [1:0] mode;
wire [3:0] box_sel;
wire [36*8-1:0] src_window;
wire [WEIGHT_NUM*WEIGHT_WIDTH-1:0] conv1_weight, weight;
wire load_conv1_bias_enable;
wire load_conv2_bias0_enable, load_conv2_bias1_enable;
wire [16:0] conv1_bias_set;
wire [7:0] set;
wire signed [3:0] bias_data;
wire [4:0] channel;
wire signed [31:0] data_out;
wire signed [7:0] out;

assign sram_wdata_b = out;
assign sram_wdata_c = out;
assign sram_wdata_d = out;

fsm fsm(
.clk(clk),
.srstn(srstn),
.fc_done(fc_done),
.conv_start(conv_start),
.conv1_done(conv1_done),
.conv_done(conv_done),
.mode(mode),
.mem_sel(mem_sel)
);

conv_control conv_control(
.clk(clk),
.srstn(srstn),
.mode(mode),
.mem_sel(mem_sel),
.conv1_done(conv1_done),
.sram_raddr_weight(sram_raddr_weight),
.box_sel(box_sel),
.load_conv1_bias_enable(load_conv1_bias_enable),
.conv1_bias_set(conv1_bias_set),
.sram_raddr_a0(sram_raddr_a0),
.sram_raddr_a1(sram_raddr_a1),
.sram_raddr_a2(sram_raddr_a2),
.sram_raddr_a3(sram_raddr_a3),
.sram_raddr_a4(sram_raddr_a4),
.sram_raddr_a5(sram_raddr_a5),
.sram_raddr_a6(sram_raddr_a6),
.sram_raddr_a7(sram_raddr_a7),
.sram_raddr_a8(sram_raddr_a8),
.sram_write_enable_b0(sram_write_enable_b0),
.sram_write_enable_b1(sram_write_enable_b1),
.sram_write_enable_b2(sram_write_enable_b2),
.sram_write_enable_b3(sram_write_enable_b3),
.sram_write_enable_b4(sram_write_enable_b4),
.sram_write_enable_b5(sram_write_enable_b5),
.sram_write_enable_b6(sram_write_enable_b6),
.sram_write_enable_b7(sram_write_enable_b7),
.sram_write_enable_b8(sram_write_enable_b8),
.sram_bytemask_b(sram_bytemask_b),
.sram_waddr_b(sram_waddr_b),
.conv_done(conv_done),
.channel(channel),
.set(set),
.load_conv2_bias0_enable(load_conv2_bias0_enable),
.load_conv2_bias1_enable(load_conv2_bias1_enable),
.sram_raddr_b0(sram_raddr_b0),
.sram_raddr_b1(sram_raddr_b1),
.sram_raddr_b2(sram_raddr_b2),
.sram_raddr_b3(sram_raddr_b3),
.sram_raddr_b4(sram_raddr_b4),
.sram_raddr_b5(sram_raddr_b5),
.sram_raddr_b6(sram_raddr_b6),
.sram_raddr_b7(sram_raddr_b7),
.sram_raddr_b8(sram_raddr_b8),
.sram_write_enable_c0(sram_write_enable_c0),
.sram_write_enable_c1(sram_write_enable_c1),
.sram_write_enable_c2(sram_write_enable_c2),
.sram_write_enable_c3(sram_write_enable_c3),
.sram_write_enable_c4(sram_write_enable_c4),
.sram_bytemask_c(sram_bytemask_c),
.sram_waddr_c(sram_waddr_c),
.sram_write_enable_d0(sram_write_enable_d0),
.sram_write_enable_d1(sram_write_enable_d1),
.sram_write_enable_d2(sram_write_enable_d2),
.sram_write_enable_d3(sram_write_enable_d3),
.sram_write_enable_d4(sram_write_enable_d4),
.sram_bytemask_d(sram_bytemask_d),
.sram_waddr_d(sram_waddr_d)
);

data_reg data_reg(
.clk(clk),
.srstn(srstn),
.mode(mode),
.box_sel(box_sel),
.sram_rdata_a0(sram_rdata_a0),
.sram_rdata_a1(sram_rdata_a1),
.sram_rdata_a2(sram_rdata_a2),
.sram_rdata_a3(sram_rdata_a3),
.sram_rdata_a4(sram_rdata_a4),
.sram_rdata_a5(sram_rdata_a5),
.sram_rdata_a6(sram_rdata_a6),
.sram_rdata_a7(sram_rdata_a7),
.sram_rdata_a8(sram_rdata_a8),
.sram_rdata_b0(sram_rdata_b0),
.sram_rdata_b1(sram_rdata_b1),
.sram_rdata_b2(sram_rdata_b2),
.sram_rdata_b3(sram_rdata_b3),
.sram_rdata_b4(sram_rdata_b4),
.sram_rdata_b5(sram_rdata_b5),
.sram_rdata_b6(sram_rdata_b6),
.sram_rdata_b7(sram_rdata_b7),
.sram_rdata_b8(sram_rdata_b8),
.sram_rdata_weight(sram_rdata_weight),
.conv1_weight(conv1_weight),
.weight(weight),
.src_window(src_window)
);

bias_sel bias_sel(
.clk(clk),
.srstn(srstn),
.mode(mode),
.load_conv1_bias_enable(load_conv1_bias_enable),
.load_conv2_bias0_enable(load_conv2_bias0_enable),
.load_conv2_bias1_enable(load_conv2_bias1_enable),
.conv1_bias_set(conv1_bias_set),
.set(set),
.sram_raddr_weight(sram_raddr_weight),
.sram_rdata_weight(sram_rdata_weight),
.bias_data(bias_data)
);

multiply_compare multiply_compare(
.clk(clk),
.srstn(srstn),
.mode(mode),
.channel(channel),
//.conv1_sram_rdata_weight(sram_rdata_weight),
.conv1_sram_rdata_weight(conv1_weight),
.conv2_sram_rdata_weight(weight),
.src_window(src_window),
.data_out(data_out)
);

quantize quantize(
.clk(clk),
.srstn(srstn),
.mode(mode),
.bias_data(bias_data),
.ori_data(data_out),
.quantized_data(out)
);

endmodule