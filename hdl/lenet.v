/**
 * Editor : Steven
 * File : lenet.v
 */

module lenet
(
input clk,
input srstn,
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

input [79:0] sram_rdata_fcweight,
output [14:0] sram_raddr_fcweight,
output fc1_done,
output fc2_done
);


wire conv_done;
wire mem_sel;

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
.sram_rdata_weight(sram_rdata_fcweight),		//load fc weight
.sram_raddr_weight(sram_raddr_fcweight),       //read address from SRAM weight

//FC done signal
.fc1_done(fc1_done),
.fc2_done(fc2_done)
);