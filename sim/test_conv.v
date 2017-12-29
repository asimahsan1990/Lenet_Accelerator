`timescale 1ns/100ps

`define PAT_START_NO 0
`define PAT_END_NO   1

`define cycle_period 10

module test_conv;

localparam SRAM_DATA_WIDTH = 32;
localparam WEIGHT_NUM = 25, WEIGHT_WIDTH = 4;

//====== module I/O =====
reg clk;
reg srstn;

reg conv_start;

wire conv1_done; // conv1_finish for testing if conv1 is correct
wire conv_done;	 // conv_finish for testing if conv2(remember to set mem_sel)
				 // mem_sel(1:c0~c4| 0:d0~d4)


wire [WEIGHT_NUM*WEIGHT_WIDTH-1:0] sram_rdata_weight;
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
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b0;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b1;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b2;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b3;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b4;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b5;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b6;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b7;
wire [SRAM_DATA_WIDTH-1:0] sram_rdata_b8;

wire [9:0] sram_raddr_a0;
wire [9:0] sram_raddr_a1;
wire [9:0] sram_raddr_a2;
wire [9:0] sram_raddr_a3;
wire [9:0] sram_raddr_a4;
wire [9:0] sram_raddr_a5;
wire [9:0] sram_raddr_a6;
wire [9:0] sram_raddr_a7;
wire [9:0] sram_raddr_a8;

wire [9:0] sram_raddr_b0;
wire [9:0] sram_raddr_b1;
wire [9:0] sram_raddr_b2;
wire [9:0] sram_raddr_b3;
wire [9:0] sram_raddr_b4;
wire [9:0] sram_raddr_b5;
wire [9:0] sram_raddr_b6;
wire [9:0] sram_raddr_b7;
wire [9:0] sram_raddr_b8;

wire sram_write_enable_c0;
wire sram_write_enable_c1;
wire sram_write_enable_c2;
wire sram_write_enable_c3;
wire sram_write_enable_c4;

wire sram_write_enable_d0;
wire sram_write_enable_d1;
wire sram_write_enable_d2;
wire sram_write_enable_d3;
wire sram_write_enable_d4;

wire [3:0] sram_bytemask_a;
wire [3:0] sram_bytemask_b;
wire [3:0] sram_bytemask_c;
wire [3:0] sram_bytemask_d;
wire [9:0] sram_waddr_a;
wire [9:0] sram_waddr_b;
wire [9:0] sram_waddr_c;
wire [9:0] sram_waddr_d;

wire [7:0] sram_wdata_a;
wire [7:0] sram_wdata_b;
wire [7:0] sram_wdata_c;
wire [7:0] sram_wdata_d;
wire mem_sel;
wire signed [7:0] out;

reg [7:0] mem[0:32*32-1];

//====== top connection =====
conv_top #(.WEIGHT_WIDTH(4),.WEIGHT_NUM(25),.DATA_WIDTH(8),.DATA_NUM_PER_SRAM_ADDR(4))
conv_top (
.clk(clk),
.srstn(srstn),
.conv_start(conv_start),
.sram_rdata_a0(sram_rdata_a0),
.sram_rdata_a1(sram_rdata_a1),
.sram_rdata_a2(sram_rdata_a2),
.sram_rdata_a3(sram_rdata_a3),
.sram_rdata_a4(sram_rdata_a4),
.sram_rdata_a5(sram_rdata_a5),
.sram_rdata_a6(sram_rdata_a6),
.sram_rdata_a7(sram_rdata_a7),
.sram_rdata_a8(sram_rdata_a8),
.sram_rdata_weight(sram_rdata_weight),

.sram_raddr_a0(sram_raddr_a0),
.sram_raddr_a1(sram_raddr_a1),
.sram_raddr_a2(sram_raddr_a2),
.sram_raddr_a3(sram_raddr_a3),
.sram_raddr_a4(sram_raddr_a4),
.sram_raddr_a5(sram_raddr_a5),
.sram_raddr_a6(sram_raddr_a6),
.sram_raddr_a7(sram_raddr_a7),
.sram_raddr_a8(sram_raddr_a8),
.sram_raddr_weight(conv_sram_raddr_weight),

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

.mem_sel(mem_sel),

.conv1_done(conv1_done),
.conv_done(conv_done)
);

/*=====================================*/
/*		 	sram connection		 	   */
/*=====================================*/
//weight_sram connection
sram_20000x100b sram_weight_0(
.clk(clk),
.csb(1'b0),
.wsb(1'b1),
.wdata(1'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_weight), 
.rdata(sram_rdata_weight)
);

//sram connection(a0-a8)
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

//sram connection(b0-b8)
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

sram_128x32b sram_128x32b_c0(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c0),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr(), 
.rdata()
);

sram_128x32b sram_128x32b_c1(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c1),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr(), 
.rdata()
);

sram_128x32b sram_128x32b_c2(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c2),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr(), 
.rdata()
);

sram_128x32b sram_128x32b_c3(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c3),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr(), 
.rdata()
);

sram_128x32b sram_128x32b_c4(
.clk(clk),
.bytemask(sram_bytemask_c),
.csb(1'b0),
.wsb(sram_write_enable_c4),
.wdata(sram_wdata_c), 
.waddr(sram_waddr_c), 
.raddr(), 
.rdata()
);

sram_128x32b sram_128x32b_d0(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d0),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr(), 
.rdata()
);

sram_128x32b sram_128x32b_d1(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d1),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr(), 
.rdata()
);

sram_128x32b sram_128x32b_d2(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d2),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr(), 
.rdata()
);

sram_128x32b sram_128x32b_d3(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d3),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr(), 
.rdata()
);

sram_128x32b sram_128x32b_d4(
.clk(clk),
.bytemask(sram_bytemask_d),
.csb(1'b0),
.wsb(sram_write_enable_d4),
.wdata(sram_wdata_d), 
.waddr(sram_waddr_d), 
.raddr(), 
.rdata()
);

//dump wave file
initial begin
  $fsdbDumpfile("conv_test.fsdb");  	       // "gray.fsdb" can be replaced into any name you want
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
integer pat_no, pat_length, hw_length, cycle_cnt_conv1, cycle_cnt_conv2, cycle_cnt_total;

integer col_cnt;
reg [7:0] weight_cnt,weight_cnt_2,weight_cnt_3;
integer i,j;
reg [99:0] conv1_w[0:19];
reg [99:0] conv1_b[0:1];  //second row not use
reg [99:0] conv2_w[0:1000];
reg [99:0] conv2_b[0:1];
reg [4*800-1:0] fc1_w[0:500-1];
reg [4*500-1:0] fc2_w[0:10-1];

reg [7:0] golden_ans [0:9999];
reg [31:0] conv1_golden_sram[0:720-1];
reg [31:0] pool2_golden_sram[0:200-1];

reg [31:0] pool1_1d [0:720-1];
reg [7:0] pool2_1d [0:800-1];

initial begin
	$readmemb("weight_data/conv1_w.dat",conv1_w);
	$readmemb("weight_data/conv1_b.dat",conv1_b);
	$readmemb("weight_data/conv2_w.dat",conv2_w);
	$readmemb("weight_data/conv2_b.dat",conv2_b);
	$readmemb("weight_data/fc1_w.dat",fc1_w);
	$readmemb("weight_data/score_w.dat",fc2_w);

    // can specify which file to use
	$readmemh("golden/golden_ans.dat",golden_ans);
	$readmemh("golden/conv1_golden.dat",conv1_golden_sram);
	$readmemb("golden/conv2_golden.dat",pool2_golden_sram);

	//====== load conv1_w =====
	for(i = 0; i < 20; i = i + 1)begin
		sram_weight_0.load_w(i,conv1_w[i]);
	end

	//====== load conv1_b =====
	sram_weight_0.load_w(20,conv1_b[0]);

	//====== load conv2_w =====
	for(i = 21; i < 1021; i = i + 1)begin
		sram_weight_0.load_w(i,conv2_w[i-21]);
	end

	//====== load conv2_b =====
	for(i = 1021; i < 1023; i = i + 1) begin
		sram_weight_0.load_w(i,conv2_b[i-1021]);
	end

	#(`cycle_period);
	
	cycle_cnt_total = 0;
	cycle_cnt_conv1 = 0;
	cycle_cnt_conv2 = 0;
	bmp2sram(0); //load mnist (.bmp) into SRAM
	$write("|\n");
    $write("The input pattern is No.%d:\n",pat_no);
    $write("|\n");
    display_sram;

    conv_start = 1'b0;
   	srstn = 1'b1;
   	//Do CONV1 and POOL1 and write result to SRAM B
	@(negedge clk);
    srstn = 1'b0;
    @(negedge clk);
    srstn = 1'b1;
    conv_start = 1'b1;
    @(negedge clk);
    conv_start = 1'b0;
    sram_raddr_weight = conv_sram_raddr_weight;

    while(~conv1_done)begin    //when break from this while, it means sram a0 can be tested
        @(negedge clk);
        cycle_cnt_conv1 = cycle_cnt_conv1 + 1;
        sram_raddr_weight = conv_sram_raddr_weight;
    end

    for(i = 0; i < 80; i = i+1) begin
        pool1_1d[i][31:24] = sram_128x32b_b0.mem[i][31:24];
        pool1_1d[i][23:16] = sram_128x32b_b0.mem[i][23:16];
        pool1_1d[i][15:8] = sram_128x32b_b0.mem[i][15:8];  
        pool1_1d[i][7:0] = sram_128x32b_b0.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[80 + i][31:24] = sram_128x32b_b1.mem[i][31:24];
        pool1_1d[80 + i][23:16] = sram_128x32b_b1.mem[i][23:16];
        pool1_1d[80 + i][15:8] = sram_128x32b_b1.mem[i][15:8];  
        pool1_1d[80 + i][7:0] = sram_128x32b_b1.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[160 + i][31:24] = sram_128x32b_b2.mem[i][31:24];
        pool1_1d[160 + i][23:16] = sram_128x32b_b2.mem[i][23:16];
        pool1_1d[160 + i][15:8] = sram_128x32b_b2.mem[i][15:8];  
        pool1_1d[160 + i][7:0] = sram_128x32b_b2.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[240 + i][31:24] = sram_128x32b_b3.mem[i][31:24];
        pool1_1d[240 + i][23:16] = sram_128x32b_b3.mem[i][23:16];
        pool1_1d[240 + i][15:8] = sram_128x32b_b3.mem[i][15:8];  
        pool1_1d[240 + i][7:0] = sram_128x32b_b3.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[320 + i][31:24] = sram_128x32b_b4.mem[i][31:24];
        pool1_1d[320 + i][23:16] = sram_128x32b_b4.mem[i][23:16];
        pool1_1d[320 + i][15:8] = sram_128x32b_b4.mem[i][15:8];  
        pool1_1d[320 + i][7:0] = sram_128x32b_b4.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[400 + i][31:24] = sram_128x32b_b5.mem[i][31:24];
        pool1_1d[400 + i][23:16] = sram_128x32b_b5.mem[i][23:16];
        pool1_1d[400 + i][15:8] = sram_128x32b_b5.mem[i][15:8];  
        pool1_1d[400 + i][7:0] = sram_128x32b_b5.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[480 + i][31:24] = sram_128x32b_b6.mem[i][31:24];
        pool1_1d[480 + i][23:16] = sram_128x32b_b6.mem[i][23:16];
        pool1_1d[480 + i][15:8] = sram_128x32b_b6.mem[i][15:8];  
        pool1_1d[480 + i][7:0] = sram_128x32b_b6.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[560 + i][31:24] = sram_128x32b_b7.mem[i][31:24];
        pool1_1d[560 + i][23:16] = sram_128x32b_b7.mem[i][23:16];
        pool1_1d[560 + i][15:8] = sram_128x32b_b7.mem[i][15:8];  
        pool1_1d[560 + i][7:0] = sram_128x32b_b7.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[640 + i][31:24] = sram_128x32b_b8.mem[i][31:24];
        pool1_1d[640 + i][23:16] = sram_128x32b_b8.mem[i][23:16];
        pool1_1d[640 + i][15:8] = sram_128x32b_b8.mem[i][15:8];  
        pool1_1d[640 + i][7:0] = sram_128x32b_b8.mem[i][7:0]; 
    end
    //show the conv1_ouptut 9 feature map(4*20) to check the answer
    for(i = 0; i < 9; i = i +1)begin
        $write("------POOL1's output feature map from SRAM %d------\n",i[7:0]);
        for(j = 0; j < 80; j = j +1)begin
            $write("[%g]: ",i * 80 + j);
            $write("%2d %2d %2d %2d\n",$signed(pool1_1d[i * 80 + j][31:24]), $signed(pool1_1d[i*80+j][23:16]),$signed(pool1_1d[i*80+j][15:8]),$signed(pool1_1d[i*80+j][7:0]));
        end
    end
    // test CONV1 answer!!!
    for(i = 0; i < 720; i = i + 1)begin
        if(pool1_1d[i] == conv1_golden_sram[i])
            $write("sram a[%01d] address: %d PASS!!\n", i/80, i%9);
        else begin
            $write("You have wrong answer in the sram a[%01d] address !!!\n\n", i/80);
            $write("Your answer at  a[%01d] i:%d is \n%d %d %d %d  \n" ,i/80, i, $signed(pool1_1d[i][31:24])
                                                                       ,$signed(pool1_1d[i][23:16])
                                                                       ,$signed(pool1_1d[i][15:8]) 
                                                                       ,$signed(pool1_1d[i][7:0]));
            $write("But the golden answer is  \n%d %d %d %d \n" ,$signed(conv1_golden_sram[i][31:24]) 
                                                                ,$signed(conv1_golden_sram[i][23:16]) 
                                                                ,$signed(conv1_golden_sram[i][15:8]) 
                                                                ,$signed(conv1_golden_sram[i][7:0]));
            $finish;
        end
    end
    $write("|\n");
    $display("Congratulations! YOU PASS CONV1!!!!!\n");
    $display("Start Testing CONV2\n");
    $write("\n");
    while(~conv_done)begin    //it means sram a0 can be tested
	    @(negedge clk);     
	    begin
	        cycle_cnt_conv2 = cycle_cnt_conv2 + 1;
	        sram_raddr_weight = conv_sram_raddr_weight;
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
    for(i = 0; i < 50; i = i + 1) begin
        $write("------POOL2's output feature map from Weight %d------\n",i[7:0]);
        for (j = 0;j < 16 ;j = j + 1) begin
             $write("%d ",$signed(pool2_1d[i * 16 + j]));
             if((j+1) % 4 == 0) $write("\n");
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
    $write("|\n");
    $display("Congratulations! YOU PASS CONV2!!!!!");
    $display("PAUL you are so cool!!!!!");
    $display("Total cycle count in CONV2 = %d.\n", cycle_cnt_conv2);
    $display("Total cycle count = %g\n", cycle_cnt_conv1+cycle_cnt_conv2);
    //test 2nd picture
    
    cycle_cnt_conv1 = 0;
    cycle_cnt_conv2 = 0;
    $readmemh("golden/01/pool1_01.dat",conv1_golden_sram);
    $readmemb("golden/01/pool2_01.dat",pool2_golden_sram);
    bmp2sram(1); //load mnist (.bmp) into SRAM
    $write("|\n");
    $write("The input pattern is No.%d:\n",1);
    $write("|\n");
    display_sram;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    conv_start = 1'b1;
    @(negedge clk);
    conv_start = 1'b0;
    while(~conv1_done)begin    //when break from this while, it means sram a0 can be tested
        @(negedge clk);
        cycle_cnt_conv1 = cycle_cnt_conv1 + 1;
        sram_raddr_weight = conv_sram_raddr_weight;
    end
    for(i = 0; i < 80; i = i+1) begin
        pool1_1d[i][31:24] = sram_128x32b_b0.mem[i][31:24];
        pool1_1d[i][23:16] = sram_128x32b_b0.mem[i][23:16];
        pool1_1d[i][15:8] = sram_128x32b_b0.mem[i][15:8];  
        pool1_1d[i][7:0] = sram_128x32b_b0.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[80 + i][31:24] = sram_128x32b_b1.mem[i][31:24];
        pool1_1d[80 + i][23:16] = sram_128x32b_b1.mem[i][23:16];
        pool1_1d[80 + i][15:8] = sram_128x32b_b1.mem[i][15:8];  
        pool1_1d[80 + i][7:0] = sram_128x32b_b1.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[160 + i][31:24] = sram_128x32b_b2.mem[i][31:24];
        pool1_1d[160 + i][23:16] = sram_128x32b_b2.mem[i][23:16];
        pool1_1d[160 + i][15:8] = sram_128x32b_b2.mem[i][15:8];  
        pool1_1d[160 + i][7:0] = sram_128x32b_b2.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[240 + i][31:24] = sram_128x32b_b3.mem[i][31:24];
        pool1_1d[240 + i][23:16] = sram_128x32b_b3.mem[i][23:16];
        pool1_1d[240 + i][15:8] = sram_128x32b_b3.mem[i][15:8];  
        pool1_1d[240 + i][7:0] = sram_128x32b_b3.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[320 + i][31:24] = sram_128x32b_b4.mem[i][31:24];
        pool1_1d[320 + i][23:16] = sram_128x32b_b4.mem[i][23:16];
        pool1_1d[320 + i][15:8] = sram_128x32b_b4.mem[i][15:8];  
        pool1_1d[320 + i][7:0] = sram_128x32b_b4.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[400 + i][31:24] = sram_128x32b_b5.mem[i][31:24];
        pool1_1d[400 + i][23:16] = sram_128x32b_b5.mem[i][23:16];
        pool1_1d[400 + i][15:8] = sram_128x32b_b5.mem[i][15:8];  
        pool1_1d[400 + i][7:0] = sram_128x32b_b5.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[480 + i][31:24] = sram_128x32b_b6.mem[i][31:24];
        pool1_1d[480 + i][23:16] = sram_128x32b_b6.mem[i][23:16];
        pool1_1d[480 + i][15:8] = sram_128x32b_b6.mem[i][15:8];  
        pool1_1d[480 + i][7:0] = sram_128x32b_b6.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[560 + i][31:24] = sram_128x32b_b7.mem[i][31:24];
        pool1_1d[560 + i][23:16] = sram_128x32b_b7.mem[i][23:16];
        pool1_1d[560 + i][15:8] = sram_128x32b_b7.mem[i][15:8];  
        pool1_1d[560 + i][7:0] = sram_128x32b_b7.mem[i][7:0]; 
    end
    for(i = 0; i < 80; i = i+1)begin
        pool1_1d[640 + i][31:24] = sram_128x32b_b8.mem[i][31:24];
        pool1_1d[640 + i][23:16] = sram_128x32b_b8.mem[i][23:16];
        pool1_1d[640 + i][15:8] = sram_128x32b_b8.mem[i][15:8];  
        pool1_1d[640 + i][7:0] = sram_128x32b_b8.mem[i][7:0]; 
    end
    //show the conv1_ouptut 9 feature map(4*20) to check the answer
    for(i = 0; i < 9; i = i +1)begin
        $write("------POOL1's output feature map from SRAM %d------\n",i[7:0]);
        for(j = 0; j < 80; j = j +1)begin
            $write("[%g]: ",i * 80 + j);
            $write("%2d %2d %2d %2d\n",$signed(pool1_1d[i * 80 + j][31:24]), $signed(pool1_1d[i*80+j][23:16]),$signed(pool1_1d[i*80+j][15:8]),$signed(pool1_1d[i*80+j][7:0]));
        end
    end
    // test CONV1 answer!!!
    for(i = 0; i < 720; i = i + 1)begin
        if(pool1_1d[i] == conv1_golden_sram[i])
            $write("sram a[%01d] address: %d PASS!!\n", i/80, i%9);
        else begin
            $write("You have wrong answer in the sram a[%01d] address !!!\n\n", i/80);
            $write("Your answer at  a[%01d] i:%d is \n%d %d %d %d  \n" ,i/80, i, $signed(pool1_1d[i][31:24])
                                                                       ,$signed(pool1_1d[i][23:16])
                                                                       ,$signed(pool1_1d[i][15:8]) 
                                                                       ,$signed(pool1_1d[i][7:0]));
            $write("But the golden answer is  \n%d %d %d %d \n" ,$signed(conv1_golden_sram[i][31:24]) 
                                                                ,$signed(conv1_golden_sram[i][23:16]) 
                                                                ,$signed(conv1_golden_sram[i][15:8]) 
                                                                ,$signed(conv1_golden_sram[i][7:0]));
            $finish;
        end
    end
    $write("|\n");
    $display("Congratulations! YOU PASS CONV1!!!!!\n");
    $display("Start Testing CONV2\n");
    $write("\n");
    while(~conv_done)begin    //it means sram a0 can be tested
        @(negedge clk);     
        begin
            cycle_cnt_conv2 = cycle_cnt_conv2 + 1;
            sram_raddr_weight = conv_sram_raddr_weight;
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
    for(i = 0; i < 50; i = i + 1) begin
        $write("------POOL2's output feature map from Weight %d------\n",i[7:0]);
        for (j = 0;j < 16 ;j = j + 1) begin
             $write("%d ",$signed(pool2_1d[i * 16 + j]));
             if((j+1) % 4 == 0) $write("\n");
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
    $write("|\n");
    $display("Congratulations! YOU PASS CONV2!!!!!");
    $display("PAUL you are so cool!!!!!");
    $display("Total cycle count in CONV2 = %d.\n", cycle_cnt_conv2);
    $display("Total cycle count = %g\n", cycle_cnt_conv1+cycle_cnt_conv2);

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