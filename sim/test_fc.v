`timescale 1ns/100ps

`define PAT_START_NO 0
`define PAT_END_NO   2

`define cycle_period 10

module test_fc;

localparam SRAM_DATA_WIDTH = 32;
localparam WEIGHT_NUM = 25, WEIGHT_WIDTH = 4;

//====== module I/O =====
reg clk;
reg srstn;
reg conv_done;		//connect conv_done wire from CONV module

reg mem_sel;

//Read SRAM c0~c4
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_c0;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_c1;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_c2;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_c3;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_c4;
wire [9:0] sram_raddr_c0;
wire [9:0] sram_raddr_c1;
wire [9:0] sram_raddr_c2;
wire [9:0] sram_raddr_c3;
wire [9:0] sram_raddr_c4;

//Read SRAM d0~d4
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_d0;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_d1;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_d2;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_d3;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_d4;
wire [9:0] sram_raddr_d0;
wire [9:0] sram_raddr_d1;
wire [9:0] sram_raddr_d2;
wire [9:0] sram_raddr_d3;
wire [9:0] sram_raddr_d4;

//Read SRAM e0~e4
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_e0;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_e1;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_e2;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_e3;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_e4;
wire [9:0] sram_raddr_e0;
wire [9:0] sram_raddr_e1;
wire [9:0] sram_raddr_e2;
wire [9:0] sram_raddr_e3;
wire [9:0] sram_raddr_e4;

//Write SRAM e0~e4
wire sram_write_enable_e0;
wire sram_write_enable_e1;
wire sram_write_enable_e2;
wire sram_write_enable_e3;
wire sram_write_enable_e4;
wire [3:0] sram_bytemask_e;
wire [9:0] sram_waddr_e;
wire [7:0] sram_wdata_e;

//Write SRAM f
wire sram_write_enable_f;
wire [3:0] sram_bytemask_f;
wire [9:0] sram_waddr_f;
wire [7:0] sram_wdata_f;

//FC weight
reg [WEIGHT_NUM*WEIGHT_WIDTH-1:0] sram_rdata_weight;		//load fc weight
wire [WEIGHT_ADDR_WIDTH-1:0] sram_raddr_weight;       //read address from SRAM weight

//FC done signal
wire fc1_done;
wire fc2_done;

reg [7:0] mem[0:32*32-1];

//====== top connection =====
fc_top ##(.WEIGHT_WIDTH(4),.WEIGHT_NUM(25),.DATA_WIDTH(8),.DATA_NUM_PER_SRAM_ADDR(4),.WEIGHT_ADDR_WIDTH(15))
fc_top (
.clk(clk),
.srstn(srstn),
.conv_done(conv_done),
.mem_sel(mem_sel),
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

.sram_write_enable_e0(sram_write_enable_e0),
.sram_write_enable_e1(sram_write_enable_e1),
.sram_write_enable_e2(sram_write_enable_e2),
.sram_write_enable_e3(sram_write_enable_e3),
.sram_write_enable_e4(sram_write_enable_e4),

.sram_bytemask_e(sram_bytemask_e),
.sram_waddr_e(sram_waddr_e),
.sram_wdata_e(sram_wdata_e),

.sram_write_enable_f(sram_write_enable_f),
.sram_bytemask_f(sram_bytemask_f),
.sram_waddr_f(sram_waddr_f),
.sram_wdata_f(sram_wdata_f),

.sram_rdata_weight(sram_rdata_weight),
.sram_raddr_weight(sram_raddr_weight),

.fc1_done(fc1_done),
.fc2_done(fc2_done)
);

/*=====================================*/
/*		 	sram connection		 	   */
/*=====================================*/
//weight_sram connection
sram_20000x80b sram_weight_0(
.clk(clk),
.csb(1'b0),
.wsb(1'b1),
.wdata(1'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_weight), 
.rdata(sram_rdata_weight)
);

//sram connection(c0-c4)


//sram connection(d0-d4)


//sram connection(e0-e4)


//sram connection(f)