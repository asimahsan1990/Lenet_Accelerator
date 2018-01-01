`timescale 1ns/100ps

`define PAT_START_NO 0
`define PAT_END_NO   0

`define cycle_period 10

module test_top;

localparam SRAM_DATA_WIDTH = 32,  WEIGHT_WIDTH = 4;
localparam CONV_WEIGHT_NUM = 25, CONV_WEIGHT_ADDR_WIDTH = 17;
localparam FC_WEIGHT_NUM = 20, FC_WEIGHT_ADDR_WIDTH = 15;

reg [7:0] mem[0:32*32-1];
//====== module I/O =====
reg clk;
reg srstn;

reg conv_start;

wire conv_done;	 // conv_finish for testing if conv2(remember to set mem_sel)
				 
wire mem_sel;	 // mem_sel(1:c0~c4| 0:d0~d4)

wire fc2_done;	 //FC done signal

/*=================================*/
/*		 		SRAM A 		 	   */
/*=================================*/
wire sram_write_enable_a0;
wire sram_write_enable_a1;
wire sram_write_enable_a2;
wire sram_write_enable_a3;
wire sram_write_enable_a4;
wire sram_write_enable_a5;
wire sram_write_enable_a6;
wire sram_write_enable_a7;
wire sram_write_enable_a8;

wire [3:0] sram_bytemask_a;
wire [9:0] sram_waddr_a;
wire [7:0] sram_wdata_a;

wire [9:0] sram_raddr_a0;
wire [9:0] sram_raddr_a1;
wire [9:0] sram_raddr_a2;
wire [9:0] sram_raddr_a3;
wire [9:0] sram_raddr_a4;
wire [9:0] sram_raddr_a5;
wire [9:0] sram_raddr_a6;
wire [9:0] sram_raddr_a7;
wire [9:0] sram_raddr_a8;

wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a0;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a1;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a2;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a3;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a4;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a5;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a6;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a7;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_a8;


/*=================================*/
/*	  	 SRAM A Connection		   */
/*=================================*/
sram_128x32b sram_128x32b_a0(
.clk(clk),
.bytemask(sram_bytemask_a),
.csb(1'b0),
.wsb(sram_write_enable_a0),
.wdata(sram_wdata_a), 
.waddr(sram_waddr_a), 
.raddr(sram_raddr_a0), 
.rdata(sram_rdata_a0)
);

sram_128x32b sram_128x32b_a1(
.clk(clk),
.bytemask(sram_bytemask_a),
.csb(1'b0),
.wsb(sram_write_enable_a1),
.wdata(sram_wdata_a), 
.waddr(sram_waddr_a), 
.raddr(sram_raddr_a1), 
.rdata(sram_rdata_a1)
);

sram_128x32b sram_128x32b_a2(
.clk(clk),
.bytemask(sram_bytemask_a),
.csb(1'b0),
.wsb(sram_write_enable_a2),
.wdata(sram_wdata_a), 
.waddr(sram_waddr_a), 
.raddr(sram_raddr_a2), 
.rdata(sram_rdata_a2)
);

sram_128x32b sram_128x32b_a3(
.clk(clk),
.bytemask(sram_bytemask_a),
.csb(1'b0),
.wsb(sram_write_enable_a3),
.wdata(sram_wdata_a), 
.waddr(sram_waddr_a), 
.raddr(sram_raddr_a3), 
.rdata(sram_rdata_a3)
);

sram_128x32b sram_128x32b_a4(
.clk(clk),
.bytemask(sram_bytemask_a),
.csb(1'b0),
.wsb(sram_write_enable_a4),
.wdata(sram_wdata_a), 
.waddr(sram_waddr_a), 
.raddr(sram_raddr_a4), 
.rdata(sram_rdata_a4)
);

sram_128x32b sram_128x32b_a5(
.clk(clk),
.bytemask(sram_bytemask_a),
.csb(1'b0),
.wsb(sram_write_enable_a5),
.wdata(sram_wdata_a), 
.waddr(sram_waddr_a), 
.raddr(sram_raddr_a5), 
.rdata(sram_rdata_a5)
);

sram_128x32b sram_128x32b_a6(
.clk(clk),
.bytemask(sram_bytemask_a),
.csb(1'b0),
.wsb(sram_write_enable_a6),
.wdata(sram_wdata_a), 
.waddr(sram_waddr_a), 
.raddr(sram_raddr_a6), 
.rdata(sram_rdata_a6)
);

sram_128x32b sram_128x32b_a7(
.clk(clk),
.bytemask(sram_bytemask_a),
.csb(1'b0),
.wsb(sram_write_enable_a7),
.wdata(sram_wdata_a), 
.waddr(sram_waddr_a), 
.raddr(sram_raddr_a7), 
.rdata(sram_rdata_a7)
);

sram_128x32b sram_128x32b_a8(
.clk(clk),
.bytemask(sram_bytemask_a),
.csb(1'b0),
.wsb(sram_write_enable_a8),
.wdata(sram_wdata_a), 
.waddr(sram_waddr_a), 
.raddr(sram_raddr_a8), 
.rdata(sram_rdata_a8)
);

/*=============================*/
/*			SRAM B 			   */
/*=============================*/
wire sram_write_enable_b0;
wire sram_write_enable_b1;
wire sram_write_enable_b2;
wire sram_write_enable_b3;
wire sram_write_enable_b4;
wire sram_write_enable_b5;
wire sram_write_enable_b6;
wire sram_write_enable_b7;
wire sram_write_enable_b8;

wire [3:0] sram_bytemask_b;
wire [9:0] sram_waddr_b;
wire [7:0] sram_wdata_b;

wire [9:0] sram_raddr_b0;
wire [9:0] sram_raddr_b1;
wire [9:0] sram_raddr_b2;
wire [9:0] sram_raddr_b3;
wire [9:0] sram_raddr_b4;
wire [9:0] sram_raddr_b5;
wire [9:0] sram_raddr_b6;
wire [9:0] sram_raddr_b7;
wire [9:0] sram_raddr_b8;

wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b0;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b1;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b2;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b3;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b4;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b5;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b6;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b7;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b8;

/*=================================*/
/*	  	 SRAM B Connection		   */
/*=================================*/
sram_128x32b sram_128x32b_b0(
.clk(clk),
.bytemask(sram_bytemask_b),
.csb(1'b0),
.wsb(sram_write_enable_b0),
.wdata(sram_wdata_b), 
.waddr(sram_waddr_b), 
.raddr(sram_raddr_b0), 
.rdata(sram_rdata_b0)
);

sram_128x32b sram_128x32b_b1(
.clk(clk),
.bytemask(sram_bytemask_b),
.csb(1'b0),
.wsb(sram_write_enable_b1),
.wdata(sram_wdata_b), 
.waddr(sram_waddr_b), 
.raddr(sram_raddr_b1), 
.rdata(sram_rdata_b1)
);

sram_128x32b sram_128x32b_b2(
.clk(clk),
.bytemask(sram_bytemask_b),
.csb(1'b0),
.wsb(sram_write_enable_b2),
.wdata(sram_wdata_b), 
.waddr(sram_waddr_b), 
.raddr(sram_raddr_b2), 
.rdata(sram_rdata_b2)
);

sram_128x32b sram_128x32b_b3(
.clk(clk),
.bytemask(sram_bytemask_b),
.csb(1'b0),
.wsb(sram_write_enable_b3),
.wdata(sram_wdata_b), 
.waddr(sram_waddr_b), 
.raddr(sram_raddr_b3), 
.rdata(sram_rdata_b3)
);

sram_128x32b sram_128x32b_b4(
.clk(clk),
.bytemask(sram_bytemask_b),
.csb(1'b0),
.wsb(sram_write_enable_b4),
.wdata(sram_wdata_b), 
.waddr(sram_waddr_b), 
.raddr(sram_raddr_b4), 
.rdata(sram_rdata_b4)
);

sram_128x32b sram_128x32b_b5(
.clk(clk),
.bytemask(sram_bytemask_b),
.csb(1'b0),
.wsb(sram_write_enable_b5),
.wdata(sram_wdata_b), 
.waddr(sram_waddr_b), 
.raddr(sram_raddr_b5), 
.rdata(sram_rdata_b5)
);

sram_128x32b sram_128x32b_b6(
.clk(clk),
.bytemask(sram_bytemask_b),
.csb(1'b0),
.wsb(sram_write_enable_b6),
.wdata(sram_wdata_b), 
.waddr(sram_waddr_b), 
.raddr(sram_raddr_b6), 
.rdata(sram_rdata_b6)
);

sram_128x32b sram_128x32b_b7(
.clk(clk),
.bytemask(sram_bytemask_b),
.csb(1'b0),
.wsb(sram_write_enable_b7),
.wdata(sram_wdata_b), 
.waddr(sram_waddr_b), 
.raddr(sram_raddr_b7), 
.rdata(sram_rdata_b7)
);

sram_128x32b sram_128x32b_b8(
.clk(clk),
.bytemask(sram_bytemask_b),
.csb(1'b0),
.wsb(sram_write_enable_b8),
.wdata(sram_wdata_b), 
.waddr(sram_waddr_b), 
.raddr(sram_raddr_b8), 
.rdata(sram_rdata_b8)
);

/*=============================*/
/*		 	SRAM C		 	   */
/*=============================*/
wire sram_write_enable_c0;
wire sram_write_enable_c1;
wire sram_write_enable_c2;
wire sram_write_enable_c3;
wire sram_write_enable_c4;

wire [3:0] sram_bytemask_c;
wire [9:0] sram_waddr_c;
wire [7:0] sram_wdata_c;

wire [5:0] sram_raddr_c0;
wire [5:0] sram_raddr_c1;
wire [5:0] sram_raddr_c2;
wire [5:0] sram_raddr_c3;
wire [5:0] sram_raddr_c4;

wire [SRAM_DATA_WIDTH-1:0] sram_rdata_c0;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_c1;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_c2;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_c3;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_c4;

/*=================================*/
/*	  	 SRAM C Connection		   */
/*=================================*/
sram_128x32b sram_128x32b_c0(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c0),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr({4'd0, sram_raddr_c0}), 
.rdata(sram_rdata_c0)
);

sram_128x32b sram_128x32b_c1(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c1),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr({4'd0, sram_raddr_c1}), 
.rdata(sram_rdata_c1)
);

sram_128x32b sram_128x32b_c2(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c2),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr({4'd0, sram_raddr_c2}), 
.rdata(sram_rdata_c2)
);

sram_128x32b sram_128x32b_c3(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c3),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr({4'd0, sram_raddr_c3}), 
.rdata(sram_rdata_c3)
);

sram_128x32b sram_128x32b_c4(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c4),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr({4'd0, sram_raddr_c4}), 
.rdata(sram_rdata_c4)
);

/*=============================*/
/*		 	SRAM D		 	   */
/*=============================*/
wire sram_write_enable_d0;
wire sram_write_enable_d1;
wire sram_write_enable_d2;
wire sram_write_enable_d3;
wire sram_write_enable_d4;

wire [3:0] sram_bytemask_d;
wire [9:0] sram_waddr_d;
wire [7:0] sram_wdata_d;

wire [5:0] sram_raddr_d0;
wire [5:0] sram_raddr_d1;
wire [5:0] sram_raddr_d2;
wire [5:0] sram_raddr_d3;
wire [5:0] sram_raddr_d4;

wire [SRAM_DATA_WIDTH-1:0] sram_rdata_d0;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_d1;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_d2;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_d3;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_d4;

/*=================================*/
/*	  	 SRAM D Connection		   */
/*=================================*/

sram_128x32b sram_128x32b_d0(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d0),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr({4'd0,sram_raddr_d0}), 
.rdata(sram_rdata_d0)
);

sram_128x32b sram_128x32b_d1(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d1),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr({4'd0,sram_raddr_d1}), 
.rdata(sram_rdata_d1)
);

sram_128x32b sram_128x32b_d2(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d2),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr({4'd0,sram_raddr_d2}), 
.rdata(sram_rdata_d2)
);

sram_128x32b sram_128x32b_d3(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d3),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr({4'd0,sram_raddr_d3}), 
.rdata(sram_rdata_d3)
);

sram_128x32b sram_128x32b_d4(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d4),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr({4'd0,sram_raddr_d4}), 
.rdata(sram_rdata_d4)
);

/*=============================*/
/*		 	SRAM E		 	   */
/*=============================*/
wire sram_write_enable_e0;
wire sram_write_enable_e1;
wire sram_write_enable_e2;
wire sram_write_enable_e3;
wire sram_write_enable_e4;

wire [3:0] sram_bytemask_e;
wire [4:0] sram_waddr_e;
wire [7:0] sram_wdata_e;

wire [4:0] sram_raddr_e0;
wire [4:0] sram_raddr_e1;
wire [4:0] sram_raddr_e2;
wire [4:0] sram_raddr_e3;
wire [4:0] sram_raddr_e4;

wire [SRAM_DATA_WIDTH-1:0] sram_rdata_e0;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_e1;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_e2;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_e3;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_e4;

/*=================================*/
/*	  	 SRAM E Connection		   */
/*=================================*/

sram_128x32b sram_128x32b_e0(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e0),
.wdata(sram_wdata_e), 
.waddr({5'd0,sram_waddr_e}), 
.raddr({5'd0,sram_raddr_e0}), 
.rdata(sram_rdata_e0)
);

sram_128x32b sram_128x32b_e1(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e1),
.wdata(sram_wdata_e), 
.waddr({5'd0,sram_waddr_e}), 
.raddr({5'd0,sram_raddr_e1}), 
.rdata(sram_rdata_e1)
);

sram_128x32b sram_128x32b_e2(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e2),
.wdata(sram_wdata_e), 
.waddr({5'd0,sram_waddr_e}), 
.raddr({5'd0,sram_raddr_e2}), 
.rdata(sram_rdata_e2)
);

sram_128x32b sram_128x32b_e3(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e3),
.wdata(sram_wdata_e), 
.waddr({5'd0,sram_waddr_e}), 
.raddr({5'd0,sram_raddr_e3}), 
.rdata(sram_rdata_e3)
);

sram_128x32b sram_128x32b_e4(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e4),
.wdata(sram_wdata_e), 
.waddr({5'd0,sram_waddr_e}), 
.raddr({5'd0,sram_raddr_e4}), 
.rdata(sram_rdata_e4)
);

/*=============================*/
/*		 	SRAM F		 	   */
/*=============================*/
wire sram_write_enable_f;
wire [3:0] sram_bytemask_f;
wire [1:0] sram_waddr_f;
wire [7:0] sram_wdata_f;

/*=================================*/
/*	  	 SRAM F Connection		   */
/*=================================*/
sram_128x32b sram_128x32b_f(
.clk(clk),
.bytemask(sram_bytemask_f),
.csb(1'b0),
.wsb(sram_write_enable_f),
.wdata(sram_wdata_f), 
.waddr({8'd0,sram_waddr_f}), 
.raddr(), 
.rdata()
);

/*=============================*/
/*		 CONV WEIGHT SRAM 	   */
/*=============================*/
wire [CONV_WEIGHT_NUM*WEIGHT_WIDTH-1:0] conv_sram_rdata_weight;	//load conv weight
wire [CONV_WEIGHT_ADDR_WIDTH-1:0] conv_sram_raddr_weight;       //read address from SRAM weight

sram_20000x100b sram_weight_conv(
.clk(clk),
.csb(1'b0),
.wsb(1'b1),
.wdata(1'b0), 
.waddr(10'd0), 
.raddr(conv_sram_raddr_weight), 
.rdata(conv_sram_rdata_weight)
);

/*=============================*/
/*		 FC WEIGHT SRAM 	   */
/*=============================*/
wire [FC_WEIGHT_NUM*WEIGHT_WIDTH-1:0] fc_sram_rdata_weight;		//load fc weight
wire [FC_WEIGHT_ADDR_WIDTH-1:0] fc_sram_raddr_weight;       	//read address from SRAM weight

sram_20250x80b sram_weight_fc(
.clk(clk),
.csb(1'b0),
.wsb(1'b1),
.wdata(1'b0), 
.waddr(10'd0), 
.raddr(fc_sram_raddr_weight), 
.rdata(fc_sram_rdata_weight)
);

lenet #(.WEIGHT_WIDTH(4),.WEIGHT_NUM(25),.DATA_WIDTH(8),.DATA_NUM_PER_SRAM_ADDR(4))
lenet (
	.clk(clk),
	.srstn(srstn),
/* CONTROL SIGNALS */
	.conv_start(conv_start),
	.fc_done(fc2_done),
	.conv_done(conv_done),
	.mem_sel(mem_sel),
	.fc1_done(fc1_done),
	.fc2_done(fc2_done),
/* SRAM A */
	.sram_rdata_a0(sram_rdata_a0),
	.sram_rdata_a1(sram_rdata_a1),
	.sram_rdata_a2(sram_rdata_a2),
	.sram_rdata_a3(sram_rdata_a3),
	.sram_rdata_a4(sram_rdata_a4),
	.sram_rdata_a5(sram_rdata_a5),
	.sram_rdata_a6(sram_rdata_a6),
	.sram_rdata_a7(sram_rdata_a7),
	.sram_rdata_a8(sram_rdata_a8),

	.sram_raddr_a0(sram_raddr_a0),
	.sram_raddr_a1(sram_raddr_a1),
	.sram_raddr_a2(sram_raddr_a2),
	.sram_raddr_a3(sram_raddr_a3),
	.sram_raddr_a4(sram_raddr_a4),
	.sram_raddr_a5(sram_raddr_a5),
	.sram_raddr_a6(sram_raddr_a6),
	.sram_raddr_a7(sram_raddr_a7),
	.sram_raddr_a8(sram_raddr_a8),
/* SRAM B */
	.sram_rdata_b0(sram_rdata_b0),
	.sram_rdata_b1(sram_rdata_b1),
	.sram_rdata_b2(sram_rdata_b2),
	.sram_rdata_b3(sram_rdata_b3),
	.sram_rdata_b4(sram_rdata_b4),
	.sram_rdata_b5(sram_rdata_b5),
	.sram_rdata_b6(sram_rdata_b6),
	.sram_rdata_b7(sram_rdata_b7),
	.sram_rdata_b8(sram_rdata_b8),

	.sram_raddr_b0(sram_raddr_b0),
	.sram_raddr_b1(sram_raddr_b1),
	.sram_raddr_b2(sram_raddr_b2),
	.sram_raddr_b3(sram_raddr_b3),
	.sram_raddr_b4(sram_raddr_b4),
	.sram_raddr_b5(sram_raddr_b5),
	.sram_raddr_b6(sram_raddr_b6),
	.sram_raddr_b7(sram_raddr_b7),
	.sram_raddr_b8(sram_raddr_b8),

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
	.sram_wdata_b(sram_wdata_b),
/* SRAM C */
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

	.sram_write_enable_c0(sram_write_enable_c0),
	.sram_write_enable_c1(sram_write_enable_c1),
	.sram_write_enable_c2(sram_write_enable_c2),
	.sram_write_enable_c3(sram_write_enable_c3),
	.sram_write_enable_c4(sram_write_enable_c4),

	.sram_bytemask_c(sram_bytemask_c),
	.sram_waddr_c(sram_waddr_c),
	.sram_wdata_c(sram_wdata_c),
/* SRAM D */
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

	.sram_write_enable_d0(sram_write_enable_d0),
	.sram_write_enable_d1(sram_write_enable_d1),
	.sram_write_enable_d2(sram_write_enable_d2),
	.sram_write_enable_d3(sram_write_enable_d3),
	.sram_write_enable_d4(sram_write_enable_d4),

	.sram_bytemask_d(sram_bytemask_d),
	.sram_waddr_d(sram_waddr_d),
	.sram_wdata_d(sram_wdata_d),
/* SRAM E */
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
/* SRAM F */
	.sram_bytemask_f(sram_bytemask_f),
	.sram_waddr_f(sram_waddr_f),
	.sram_wdata_f(sram_wdata_f),
	.sram_write_enable_f(sram_write_enable_f),
/* CONV WEIGHT SRAM */
	.conv_sram_raddr_weight(conv_sram_raddr_weight),
	.conv_sram_rdata_weight(conv_sram_rdata_weight),
/* FC WEIGHT SRAM */
	.fc_sram_raddr_weight(fc_sram_raddr_weight),
	.fc_sram_rdata_weight(fc_sram_rdata_weight)
);

//dump wave file
initial begin
  $fsdbDumpfile("top_test.fsdb");  		       // "top_test.fsdb" can be replaced into any name you want
  $fsdbDumpvars("+mda");              		   // but make sure in .fsdb format
end

//====== clock generation =====
initial begin
    srstn = 1'b1;
    clk = 1'b1;
    #(`cycle_period/2);
    while(1) begin
    	#(`cycle_period/2) clk = ~clk;
    end
end

/*================================*/
/*		main Simulation block 	  */
/*================================*/
/* general variable */
integer pat_no, pat_length;
integer cycle_cnt_fc1, cycle_cnt_fc2, cycle_cnt_conv1, cycle_cnt_conv2;
integer i,j;

/* weight & bias */
reg [99:0] conv1_w[0:19];
reg [99:0] conv1_b[0:1];  
reg [99:0] conv2_w[0:1000];
reg [99:0] conv2_b[0:1];
reg [4*800-1:0] fc1_w[0:500-1];
reg [4*500-1:0] fc2_w[0:10-1];

/* golden */
reg [31:0] conv1_golden_sram[0:720-1];
reg [31:0] pool2_golden_sram[0:200-1];
reg signed [31:0] fc1_golden [0:125-1];
reg signed [31:0] fc2_golden [0:2];
reg [7:0] golden_ans [0:9999];

/* debug buffer */
reg [31:0] pool1_1d [0:720-1];
reg [7:0] pool2_1d [0:800-1];
reg signed [31:0] fc1_output [0:125-1];
reg signed [31:0] fc2_output [0:2];

initial begin
	/* Read Weight from dat file */
	$readmemb("weight_data/conv1_w.dat",conv1_w);
	$readmemb("weight_data/conv1_b.dat",conv1_b);
	$readmemb("weight_data/conv2_w.dat",conv2_w);
	$readmemb("weight_data/conv2_b.dat",conv2_b);
	$readmemb("weight_data/fc1_w.dat",fc1_w);
    $readmemb("weight_data/score_w.dat",fc2_w);
    /* Load Weight into SRAM */
    //====== conv =====
	for(i = 0; i < 20; i = i + 1)begin
		sram_weight_conv.load_w(i,conv1_w[i]);
	end
	sram_weight_conv.load_w(20,conv1_b[0]);
	for(i = 21; i < 1021; i = i + 1)begin
		sram_weight_conv.load_w(i,conv2_w[i-21]);
	end
	for(i = 1021; i < 1023; i = i + 1) begin
		sram_weight_conv.load_w(i,conv2_b[i-1021]);
	end
	//====== fc =====
    for(i = 0; i < 500; i= i + 1)begin
        for(j = 0; j < 40; j = j + 1)begin
            sram_weight_fc.load_w(i*40+j,fc1_w[i][(40-j-1)*80 +: 80]);
        end
    end
    for(i = 0; i < 10; i = i + 1)begin
        for(j = 0; j < 25; j = j + 1)begin
            sram_weight_fc.load_w(i*25+j + 20000,fc2_w[i][(25-j-1)*80 +: 80]);
        end
    end
end

initial begin
    #(`cycle_period);
    srstn = 1'b1;
    @(negedge clk);
    srstn = 1'b0;
    @(negedge clk);
    srstn = 1'b1;
    /* Initialization */
   	cycle_cnt_conv1 = 0;
	cycle_cnt_conv2 = 0;
	cycle_cnt_fc1 = 0;
	cycle_cnt_fc2 = 0;
	bmp2sram(0);
	$write("|\n");
    $write("The input pattern is No.%d:\n", 0);
    $write("|\n");
    $readmemh("golden/conv1_golden.dat",conv1_golden_sram);
	$readmemb("golden/00/pool2_00.dat",pool2_golden_sram);
    display_sram;
    conv_start = 1'b0;
	@(negedge clk);
	conv_start = 1'b1;
	@(negedge clk);
	conv_start = 1'b0;

    /*================================*/
	/*			TEST CONV 2  		  */
	/*================================*/
    
    while(~conv_done)begin    //it means sram a0 can be tested
	    @(negedge clk);     
	    begin
	        cycle_cnt_conv2 = cycle_cnt_conv2 + 1;
	    end
	end
	if(mem_sel == 0) begin
        $display("Test sram c0~c4\n");
		for(i = 0; i < 40;i = i + 1) begin
            pool2_1d[i*20] = sram_128x32b_c0.mem[i][31:24];
            pool2_1d[i*20 + 1] = sram_128x32b_c0.mem[i][23:16];
            pool2_1d[i*20 + 2] = sram_128x32b_c0.mem[i][15:8];  
            pool2_1d[i*20 + 3] = sram_128x32b_c0.mem[i][7:0];

            pool2_1d[i*20 + 4] = sram_128x32b_c1.mem[i][31:24];
            pool2_1d[i*20 + 5] = sram_128x32b_c1.mem[i][23:16];
            pool2_1d[i*20 + 6] = sram_128x32b_c1.mem[i][15:8];  
            pool2_1d[i*20 + 7] = sram_128x32b_c1.mem[i][7:0];  
            
            pool2_1d[i*20 + 8] = sram_128x32b_c2.mem[i][31:24];
            pool2_1d[i*20 + 9] = sram_128x32b_c2.mem[i][23:16];
            pool2_1d[i*20 + 10] = sram_128x32b_c2.mem[i][15:8];  
            pool2_1d[i*20 + 11] = sram_128x32b_c2.mem[i][7:0];  

            pool2_1d[i*20 + 12] = sram_128x32b_c3.mem[i][31:24];
            pool2_1d[i*20 + 13] = sram_128x32b_c3.mem[i][23:16];
            pool2_1d[i*20 + 14] = sram_128x32b_c3.mem[i][15:8];  
            pool2_1d[i*20 + 15] = sram_128x32b_c3.mem[i][7:0];  

            pool2_1d[i*20 + 16] = sram_128x32b_c4.mem[i][31:24];
            pool2_1d[i*20 + 17] = sram_128x32b_c4.mem[i][23:16];
            pool2_1d[i*20 + 18] = sram_128x32b_c4.mem[i][15:8];  
            pool2_1d[i*20 + 19] = sram_128x32b_c4.mem[i][7:0];  
        end
	end
	else begin
        $display("Test sram d0~d4\n");
		for(i = 0; i < 40;i = i + 1) begin
            pool2_1d[i*20] = sram_128x32b_d0.mem[i][31:24];
            pool2_1d[i*20 + 1] = sram_128x32b_d0.mem[i][23:16];
            pool2_1d[i*20 + 2] = sram_128x32b_d0.mem[i][15:8];  
            pool2_1d[i*20 + 3] = sram_128x32b_d0.mem[i][7:0];

            pool2_1d[i*20 + 4] = sram_128x32b_d1.mem[i][31:24];
            pool2_1d[i*20 + 5] = sram_128x32b_d1.mem[i][23:16];
            pool2_1d[i*20 + 6] = sram_128x32b_d1.mem[i][15:8];  
            pool2_1d[i*20 + 7] = sram_128x32b_d1.mem[i][7:0];  
            
            pool2_1d[i*20 + 8] = sram_128x32b_d2.mem[i][31:24];
            pool2_1d[i*20 + 9] = sram_128x32b_d2.mem[i][23:16];
            pool2_1d[i*20 + 10] = sram_128x32b_d2.mem[i][15:8];  
            pool2_1d[i*20 + 11] = sram_128x32b_d2.mem[i][7:0];  

            pool2_1d[i*20 + 12] = sram_128x32b_d3.mem[i][31:24];
            pool2_1d[i*20 + 13] = sram_128x32b_d3.mem[i][23:16];
            pool2_1d[i*20 + 14] = sram_128x32b_d3.mem[i][15:8];  
            pool2_1d[i*20 + 15] = sram_128x32b_d3.mem[i][7:0];  

            pool2_1d[i*20 + 16] = sram_128x32b_d4.mem[i][31:24];
            pool2_1d[i*20 + 17] = sram_128x32b_d4.mem[i][23:16];
            pool2_1d[i*20 + 18] = sram_128x32b_d4.mem[i][15:8];  
            pool2_1d[i*20 + 19] = sram_128x32b_d4.mem[i][7:0]; 
        end
	end
	for(i = 0; i < 200; i = i + 1) begin
        for(j = 0; j < 4; j = j + 1)begin
            if(pool2_golden_sram[i][(4-j)*8-1 -: 8] == pool2_1d[i*4 + j]) $write("sram #a[%d] address: %d PASS!!\n", i%5, i/5); 
            else begin
                $write("You have wrong answer in the sram #a[%d] !!!\n\n", i%5);
                $write("Your answer at address %d is \n%d %d %d %d  \n" ,i/5, $signed(pool2_1d[i])
                                                                            , $signed(pool2_1d[i+1])
                                                                            , $signed(pool2_1d[i+2])
                                                                            , $signed(pool2_1d[i+3]));
                $write("But the golden answer is  \n%d %d %d %d \n" , $signed(pool2_golden_sram[i][31:24])
                                                                    , $signed(pool2_golden_sram[i][23:16])
                                                                    , $signed(pool2_golden_sram[i][15:8])
                                                                    , $signed(pool2_golden_sram[i][7:0]));
                $finish;
            end
        end
    end
    $display("Congratulations! YOU PASS 0 CONV2!!!!!");
    $display("PAUL you are so cool!!!!!");
    $display("Total cycle count in CONV2 = %d.\n", cycle_cnt_conv2);
    $display("Total cycle count = %g\n", cycle_cnt_conv1+cycle_cnt_conv2);

    $readmemh("golden/00/fc2_00.dat",fc2_golden);

    /*================================*/
	/*			TEST FC 2  			  */
	/*================================*/
	
	while(~fc2_done)begin    //when break from this while, it means sram f can be tested
        @(negedge clk);
        cycle_cnt_fc2 = cycle_cnt_fc2 + 1;
    end

    for(i = 0; i < 3; i = i + 1)
    	fc2_output[i] = sram_128x32b_f.mem[i];

    for(i = 0; i < 2; i= i + 1)begin
        if(fc2_output[i] == fc2_golden[i]) $write("sram #f address: %g PASS!!\n", i);
        else begin
            $write("You have wrong answer in the sram #f 00 !!!\n\n");
            $write("Your answer at address %d is \n%d %d %d %d  \n" ,i/5, $signed(fc2_output[i][31:24])
                                                            , $signed(fc2_output[i][23:16])
                                                            , $signed(fc2_output[i][15:8])
                                                            , $signed(fc2_output[i][7:0]));
            $write("But the golden answer is  \n%d %d %d %d \n" , $signed(fc2_golden[i][31:24])
                                                                , $signed(fc2_golden[i][23:16])
                                                                , $signed(fc2_golden[i][15:8])
                                                                , $signed(fc2_golden[i][7:0]));
            $finish;
        end 
    end

    if(fc2_output[i][31:16] == fc2_golden[i][31:16])$write("sram #f address: 2 PASS!!\n",);
    else begin
        $write("You have wrong answer in the sram #f !!!\n\n");
        $write("Your answer at address 3 is \n%d %d  \n"    , $signed(fc2_output[i][31:24])
                                                            , $signed(fc2_output[i][23:16]));
        $write("But the golden answer is  \n%d %d  \n"  , $signed(fc2_golden[i][31:24])
                                                        , $signed(fc2_golden[i][23:16]));
        $finish;
    end

    $write("|\n");
    $display("Congratulations! YOU PASS 0 FC2!!!!!");
    $display("Steven you are so cool!!!!!");
    $display("Total cycle count in FC1 = %d.", cycle_cnt_fc1);
    $display("Total cycle count in FC2 = %d.", cycle_cnt_fc2);
    $display("Total cycle count  = %d.", cycle_cnt_fc2 + cycle_cnt_fc1 + cycle_cnt_conv1 + cycle_cnt_conv2);
    #(`cycle_period);
    bmp2sram(2);
	$write("|\n");
    $write("The input pattern is No.%d:\n", 2);
    $write("|\n");
    $readmemh("golden/02/pool1_02.dat",conv1_golden_sram);
	$readmemb("golden/02/pool2_02.dat",pool2_golden_sram);
    display_sram;
    @(negedge clk);
    conv_start = 1'b0;
	@(negedge clk);
	conv_start = 1'b1;
	@(negedge clk);
	conv_start = 1'b0;
	while(~conv_done)begin    //it means sram a0 can be tested
	    @(negedge clk);
	end
	if(mem_sel == 0) begin
        $display("Test sram c0~c4\n");
		for(i = 0; i < 40;i = i + 1) begin
            pool2_1d[i*20] = sram_128x32b_c0.mem[i][31:24];
            pool2_1d[i*20 + 1] = sram_128x32b_c0.mem[i][23:16];
            pool2_1d[i*20 + 2] = sram_128x32b_c0.mem[i][15:8];  
            pool2_1d[i*20 + 3] = sram_128x32b_c0.mem[i][7:0];

            pool2_1d[i*20 + 4] = sram_128x32b_c1.mem[i][31:24];
            pool2_1d[i*20 + 5] = sram_128x32b_c1.mem[i][23:16];
            pool2_1d[i*20 + 6] = sram_128x32b_c1.mem[i][15:8];  
            pool2_1d[i*20 + 7] = sram_128x32b_c1.mem[i][7:0];  
            
            pool2_1d[i*20 + 8] = sram_128x32b_c2.mem[i][31:24];
            pool2_1d[i*20 + 9] = sram_128x32b_c2.mem[i][23:16];
            pool2_1d[i*20 + 10] = sram_128x32b_c2.mem[i][15:8];  
            pool2_1d[i*20 + 11] = sram_128x32b_c2.mem[i][7:0];  

            pool2_1d[i*20 + 12] = sram_128x32b_c3.mem[i][31:24];
            pool2_1d[i*20 + 13] = sram_128x32b_c3.mem[i][23:16];
            pool2_1d[i*20 + 14] = sram_128x32b_c3.mem[i][15:8];  
            pool2_1d[i*20 + 15] = sram_128x32b_c3.mem[i][7:0];  

            pool2_1d[i*20 + 16] = sram_128x32b_c4.mem[i][31:24];
            pool2_1d[i*20 + 17] = sram_128x32b_c4.mem[i][23:16];
            pool2_1d[i*20 + 18] = sram_128x32b_c4.mem[i][15:8];  
            pool2_1d[i*20 + 19] = sram_128x32b_c4.mem[i][7:0];  
        end
	end
	else begin
        $display("Test sram d0~d4\n");
		for(i = 0; i < 40;i = i + 1) begin
            pool2_1d[i*20] = sram_128x32b_d0.mem[i][31:24];
            pool2_1d[i*20 + 1] = sram_128x32b_d0.mem[i][23:16];
            pool2_1d[i*20 + 2] = sram_128x32b_d0.mem[i][15:8];  
            pool2_1d[i*20 + 3] = sram_128x32b_d0.mem[i][7:0];

            pool2_1d[i*20 + 4] = sram_128x32b_d1.mem[i][31:24];
            pool2_1d[i*20 + 5] = sram_128x32b_d1.mem[i][23:16];
            pool2_1d[i*20 + 6] = sram_128x32b_d1.mem[i][15:8];  
            pool2_1d[i*20 + 7] = sram_128x32b_d1.mem[i][7:0];  
            
            pool2_1d[i*20 + 8] = sram_128x32b_d2.mem[i][31:24];
            pool2_1d[i*20 + 9] = sram_128x32b_d2.mem[i][23:16];
            pool2_1d[i*20 + 10] = sram_128x32b_d2.mem[i][15:8];  
            pool2_1d[i*20 + 11] = sram_128x32b_d2.mem[i][7:0];  

            pool2_1d[i*20 + 12] = sram_128x32b_d3.mem[i][31:24];
            pool2_1d[i*20 + 13] = sram_128x32b_d3.mem[i][23:16];
            pool2_1d[i*20 + 14] = sram_128x32b_d3.mem[i][15:8];  
            pool2_1d[i*20 + 15] = sram_128x32b_d3.mem[i][7:0];  

            pool2_1d[i*20 + 16] = sram_128x32b_d4.mem[i][31:24];
            pool2_1d[i*20 + 17] = sram_128x32b_d4.mem[i][23:16];
            pool2_1d[i*20 + 18] = sram_128x32b_d4.mem[i][15:8];  
            pool2_1d[i*20 + 19] = sram_128x32b_d4.mem[i][7:0]; 
        end
	end
	for(i = 0; i < 200; i = i + 1) begin
        for(j = 0; j < 4; j = j + 1)begin
            if(pool2_golden_sram[i][(4-j)*8-1 -: 8] == pool2_1d[i*4 + j]) $write("sram #a[%d] address: %d PASS!!\n", i%5, i/5); 
            else begin
                $write("You have wrong answer in the sram #a[%d] !!!\n\n", i%5);
                $write("Your answer at address %d is \n%d %d %d %d  \n" ,i/5, $signed(pool2_1d[i])
                                                                            , $signed(pool2_1d[i+1])
                                                                            , $signed(pool2_1d[i+2])
                                                                            , $signed(pool2_1d[i+3]));
                $write("But the golden answer is  \n%d %d %d %d \n" , $signed(pool2_golden_sram[i][31:24])
                                                                    , $signed(pool2_golden_sram[i][23:16])
                                                                    , $signed(pool2_golden_sram[i][15:8])
                                                                    , $signed(pool2_golden_sram[i][7:0]));
                $finish;
            end
        end
    end
    $display("Congratulations! YOU PASS 2 CONV2!!!!!");
    //$finish;
end

/*================================*/
/*			FEED 2nd PHOTO  	  */
/*================================*/
initial begin
	#(`cycle_period);
	#(`cycle_period);
	while(~conv_done)begin    //it means sram a0 can be tested
	    @(negedge clk);
	end
	bmp2sram(1);
	$write("|\n");
    $write("The input pattern is No.%d:\n", 1);
    $write("|\n");
    $readmemh("golden/01/pool1_01.dat",conv1_golden_sram);
	$readmemb("golden/01/pool2_01.dat",pool2_golden_sram);
    display_sram;
    @(negedge clk);
    conv_start = 1'b0;
	@(negedge clk);
	conv_start = 1'b1;
	@(negedge clk);
	conv_start = 1'b0;
	while(~conv_done)begin    //it means sram a0 can be tested
	    @(negedge clk);
	end
	if(mem_sel == 0) begin
        $display("Test sram c0~c4\n");
		for(i = 0; i < 40;i = i + 1) begin
            pool2_1d[i*20] = sram_128x32b_c0.mem[i][31:24];
            pool2_1d[i*20 + 1] = sram_128x32b_c0.mem[i][23:16];
            pool2_1d[i*20 + 2] = sram_128x32b_c0.mem[i][15:8];  
            pool2_1d[i*20 + 3] = sram_128x32b_c0.mem[i][7:0];

            pool2_1d[i*20 + 4] = sram_128x32b_c1.mem[i][31:24];
            pool2_1d[i*20 + 5] = sram_128x32b_c1.mem[i][23:16];
            pool2_1d[i*20 + 6] = sram_128x32b_c1.mem[i][15:8];  
            pool2_1d[i*20 + 7] = sram_128x32b_c1.mem[i][7:0];  
            
            pool2_1d[i*20 + 8] = sram_128x32b_c2.mem[i][31:24];
            pool2_1d[i*20 + 9] = sram_128x32b_c2.mem[i][23:16];
            pool2_1d[i*20 + 10] = sram_128x32b_c2.mem[i][15:8];  
            pool2_1d[i*20 + 11] = sram_128x32b_c2.mem[i][7:0];  

            pool2_1d[i*20 + 12] = sram_128x32b_c3.mem[i][31:24];
            pool2_1d[i*20 + 13] = sram_128x32b_c3.mem[i][23:16];
            pool2_1d[i*20 + 14] = sram_128x32b_c3.mem[i][15:8];  
            pool2_1d[i*20 + 15] = sram_128x32b_c3.mem[i][7:0];  

            pool2_1d[i*20 + 16] = sram_128x32b_c4.mem[i][31:24];
            pool2_1d[i*20 + 17] = sram_128x32b_c4.mem[i][23:16];
            pool2_1d[i*20 + 18] = sram_128x32b_c4.mem[i][15:8];  
            pool2_1d[i*20 + 19] = sram_128x32b_c4.mem[i][7:0];  
        end
	end
	else begin
        $display("Test sram d0~d4\n");
		for(i = 0; i < 40;i = i + 1) begin
            pool2_1d[i*20] = sram_128x32b_d0.mem[i][31:24];
            pool2_1d[i*20 + 1] = sram_128x32b_d0.mem[i][23:16];
            pool2_1d[i*20 + 2] = sram_128x32b_d0.mem[i][15:8];  
            pool2_1d[i*20 + 3] = sram_128x32b_d0.mem[i][7:0];

            pool2_1d[i*20 + 4] = sram_128x32b_d1.mem[i][31:24];
            pool2_1d[i*20 + 5] = sram_128x32b_d1.mem[i][23:16];
            pool2_1d[i*20 + 6] = sram_128x32b_d1.mem[i][15:8];  
            pool2_1d[i*20 + 7] = sram_128x32b_d1.mem[i][7:0];  
            
            pool2_1d[i*20 + 8] = sram_128x32b_d2.mem[i][31:24];
            pool2_1d[i*20 + 9] = sram_128x32b_d2.mem[i][23:16];
            pool2_1d[i*20 + 10] = sram_128x32b_d2.mem[i][15:8];  
            pool2_1d[i*20 + 11] = sram_128x32b_d2.mem[i][7:0];  

            pool2_1d[i*20 + 12] = sram_128x32b_d3.mem[i][31:24];
            pool2_1d[i*20 + 13] = sram_128x32b_d3.mem[i][23:16];
            pool2_1d[i*20 + 14] = sram_128x32b_d3.mem[i][15:8];  
            pool2_1d[i*20 + 15] = sram_128x32b_d3.mem[i][7:0];  

            pool2_1d[i*20 + 16] = sram_128x32b_d4.mem[i][31:24];
            pool2_1d[i*20 + 17] = sram_128x32b_d4.mem[i][23:16];
            pool2_1d[i*20 + 18] = sram_128x32b_d4.mem[i][15:8];  
            pool2_1d[i*20 + 19] = sram_128x32b_d4.mem[i][7:0]; 
        end
	end
	for(i = 0; i < 200; i = i + 1) begin
        for(j = 0; j < 4; j = j + 1)begin
            if(pool2_golden_sram[i][(4-j)*8-1 -: 8] == pool2_1d[i*4 + j]) $write("sram #a[%d] address: %d PASS!!\n", i%5, i/5); 
            else begin
                $write("You have wrong answer in the sram #a[%d] !!!\n\n", i%5);
                $write("Your answer at address %d is \n%d %d %d %d  \n" ,i/5, $signed(pool2_1d[i])
                                                                            , $signed(pool2_1d[i+1])
                                                                            , $signed(pool2_1d[i+2])
                                                                            , $signed(pool2_1d[i+3]));
                $write("But the golden answer is  \n%d %d %d %d \n" , $signed(pool2_golden_sram[i][31:24])
                                                                    , $signed(pool2_golden_sram[i][23:16])
                                                                    , $signed(pool2_golden_sram[i][15:8])
                                                                    , $signed(pool2_golden_sram[i][7:0]));
                $finish;
            end
        end
    end
    $display("Congratulations! YOU PASS 1 CONV2!!!!!");
    /*================================*/
	/*			TEST FC 2 (bmp01) 	  */
	/*================================*/
	while(~fc2_done)begin    //when break from this while, it means sram f can be tested
        @(negedge clk);
        cycle_cnt_fc2 = cycle_cnt_fc2 + 1;
    end
	$readmemh("golden/01/fc2_01.dat",fc2_golden);
	while(~fc2_done)begin    //when break from this while, it means sram f can be tested
        @(negedge clk);
        cycle_cnt_fc2 = cycle_cnt_fc2 + 1;
    end

    for(i = 0; i < 3; i = i + 1)
    	fc2_output[i] = sram_128x32b_f.mem[i];

    for(i = 0; i < 2; i= i + 1)begin
        if(fc2_output[i] == fc2_golden[i]) $write("sram #f address: %g PASS!!\n", i);
        else begin
            $write("You have wrong answer in the sram #f(bmp01) !!!\n\n");
            $write("Your answer at address %d is \n%d %d %d %d  \n" ,i/5, $signed(fc2_output[i][31:24])
                                                            , $signed(fc2_output[i][23:16])
                                                            , $signed(fc2_output[i][15:8])
                                                            , $signed(fc2_output[i][7:0]));
            $write("But the golden answer is  \n%d %d %d %d \n" , $signed(fc2_golden[i][31:24])
                                                                , $signed(fc2_golden[i][23:16])
                                                                , $signed(fc2_golden[i][15:8])
                                                                , $signed(fc2_golden[i][7:0]));
            $finish;
        end 
    end

    if(fc2_output[i][31:16] == fc2_golden[i][31:16])$write("sram #f address: 2 PASS!!\n",);
    else begin
        $write("You have wrong answer in the sram #f !!!\n\n");
        $write("Your answer at address 3 is \n%d %d  \n"    , $signed(fc2_output[i][31:24])
                                                            , $signed(fc2_output[i][23:16]));
        $write("But the golden answer is  \n%d %d  \n"  , $signed(fc2_golden[i][31:24])
                                                        , $signed(fc2_golden[i][23:16]));
        $finish;
    end

    $write("|\n");
    $display("Congratulations! YOU PASS 1 FC2!!!!!");

    $finish;
end

task bmp2sram(
input [31:0] pat_no
);

    reg [17*8-1:0] bmp_filename;
    integer this_i, this_j,i,j;
    integer index_a,index_b,index_c;
    integer index_d,index_e,index_f;
    integer index_g,index_h,index_i;
    integer file_in;
    reg [7:0] char_in;
    reg [31:0] tmp;
    begin
        bmp_filename = "bmp/test_0001.bmp";
        bmp_filename[8*8-1:7*8] = (pat_no/1000)+48;
        bmp_filename[7*8-1:6*8] = (pat_no%1000)/100+48;
        bmp_filename[6*8-1:5*8] = (pat_no%100)/10+48;
        bmp_filename[5*8-1:4*8] = pat_no%10+48;
        $display("filename : %s\n", bmp_filename);
        file_in = $fopen(bmp_filename,"rb");

        for(this_i=0;this_i<1078;this_i=this_i+1)
           char_in = $fgetc(file_in);

        for(this_i=27;this_i>=0;this_i=this_i-1) begin
            for(this_j=0;this_j<28;this_j=this_j+1) begin //four-byte alignment
               char_in = $fgetc(file_in);
               if(char_in <= 127)  mem[this_i*32 + this_j] = char_in;
               else mem[this_i*32 + this_j] = 127;
            end
        end

        $fclose(file_in);
        index_a = 0;
        index_b = 0;
        index_c = 0;
        index_d = 0;
        index_e = 0;
        index_f = 0;
        index_g = 0;
        index_h = 0;
        index_i = 0;

        for(i = 0; i < 28; i = i + 2) begin
            for(j = 0; j < 28; j = j + 2) begin
                case (i % 6)
                    0 : begin
                        case (j % 6)
                            0 : begin
                                tmp[31:24] = mem[i*32+j];
                                tmp[23:16] = mem[i*32+j+1];
                                tmp[15:8] = mem[(i+1)*32+j];
                                tmp[7:0] = mem[(i+1)*32+j+1];
                                sram_128x32b_a0.char2sram(index_a,tmp);
                                index_a = index_a + 1;
                            end
                            2 : begin
                                tmp[31:24] = mem[i*32+j];
                                tmp[23:16] = mem[i*32+j+1];
                                tmp[15:8] = mem[(i+1)*32+j];
                                tmp[7:0] = mem[(i+1)*32+j+1];
                                sram_128x32b_a1.char2sram(index_b,tmp);
                                index_b = index_b + 1;
                            end
                            4 : begin
                                tmp[31:24] = mem[i*32+j];
                                tmp[23:16] = mem[i*32+j+1];
                                tmp[15:8] = mem[(i+1)*32+j];
                                tmp[7:0] = mem[(i+1)*32+j+1];
                                sram_128x32b_a2.char2sram(index_c,tmp);
                                index_c = index_c + 1;
                            end 
                            default: tmp = 0;
                        endcase
                    end

                    2 : begin
                        case (j % 6)
                            0 : begin
                                tmp[31:24] = mem[i*32+j];
                                tmp[23:16] = mem[i*32+j+1];
                                tmp[15:8] = mem[(i+1)*32+j];
                                tmp[7:0] = mem[(i+1)*32+j+1];
                                sram_128x32b_a3.char2sram(index_d,tmp);
                                index_d = index_d + 1;              
                            end
                            2 : begin
                                tmp[31:24] = mem[i*32+j];
                                tmp[23:16] = mem[i*32+j+1];
                                tmp[15:8] = mem[(i+1)*32+j];
                                tmp[7:0] = mem[(i+1)*32+j+1];
                                sram_128x32b_a4.char2sram(index_e,tmp);
                                index_e = index_e + 1;
                            end
                            4 : begin
                                tmp[31:24] = mem[i*32+j];
                                tmp[23:16] = mem[i*32+j+1];
                                tmp[15:8] = mem[(i+1)*32+j];
                                tmp[7:0] = mem[(i+1)*32+j+1];
                                sram_128x32b_a5.char2sram(index_f,tmp);
                                index_f = index_f + 1;
                            end 
                            default: tmp = 0;
                        endcase
                    end

                    4 : begin
                        case (j % 6)
                            0 : begin
                                tmp[31:24] = mem[i*32+j];
                                tmp[23:16] = mem[i*32+j+1];
                                tmp[15:8] = mem[(i+1)*32+j];
                                tmp[7:0] = mem[(i+1)*32+j+1];
                                sram_128x32b_a6.char2sram(index_g,tmp);
                                index_g = index_g + 1;
                            end
                            2 : begin
                                tmp[31:24] = mem[i*32+j];
                                tmp[23:16] = mem[i*32+j+1];
                                tmp[15:8] = mem[(i+1)*32+j];
                                tmp[7:0] = mem[(i+1)*32+j+1];
                                sram_128x32b_a7.char2sram(index_h,tmp);
                                index_h = index_h + 1;
                            end
                            4 : begin
                                tmp[31:24] = mem[i*32+j];
                                tmp[23:16] = mem[i*32+j+1];
                                tmp[15:8] = mem[(i+1)*32+j];
                                tmp[7:0] = mem[(i+1)*32+j+1];
                                sram_128x32b_a8.char2sram(index_i,tmp);
                                index_i = index_i + 1;
                            end 
                            default: tmp = 0;
                        endcase
                    end 
                    default:  tmp = 0;
                endcase
            end
        end
    end
endtask

//display the mnist image in 28x28 SRAM
task display_sram;
integer this_i, this_j;
    begin
        for(this_i=0;this_i<28;this_i=this_i+1) begin
            for(this_j=0;this_j<28;this_j=this_j+1) begin
               $write("%d",mem[this_i*32+this_j]);
            end
            $write("\n");
        end
    end
endtask

endmodule