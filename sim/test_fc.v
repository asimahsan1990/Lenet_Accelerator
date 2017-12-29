`timescale 1ns/100ps

`define PAT_START_NO 0
`define PAT_END_NO   2

`define cycle_period 10

module test_fc;

localparam SRAM_DATA_WIDTH = 32;
localparam WEIGHT_NUM = 25, WEIGHT_WIDTH = 4;
localparam WEIGHT_ADDR_WIDTH = 15;

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
wire [WEIGHT_ADDR_WIDTH-1:0] sram_raddr_weight;       		//read address from SRAM weight

//FC done signal
wire fc1_done;
wire fc2_done;

reg [7:0] mem[0:32*32-1];

//====== top connection =====
fc_top #(.WEIGHT_WIDTH(4),.WEIGHT_NUM(20),.DATA_WIDTH(8),.DATA_NUM_PER_SRAM_ADDR(4),.WEIGHT_ADDR_WIDTH(15))
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
sram_20250x80b sram_weight_0(
.clk(clk),
.csb(1'b0),
.wsb(1'b1),
.wdata(80'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_weight), 
.rdata(sram_rdata_weight)
);

//sram connection(c0-c4)
sram_128x32b sram_128x32b_c0(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_c0), 
.rdata(sram_rdata_c0)
);

sram_128x32b sram_128x32b_c1(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_c1), 
.rdata(sram_rdata_c1)
);

sram_128x32b sram_128x32b_c2(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_c2), 
.rdata(sram_rdata_c2)
);

sram_128x32b sram_128x32b_c3(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_c3), 
.rdata(sram_rdata_c3)
);

sram_128x32b sram_128x32b_c4(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_c4), 
.rdata(sram_rdata_c4)
);
//sram connection(d0-d4)
sram_128x32b sram_128x32b_d0(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_d0), 
.rdata(sram_rdata_d0)
);

sram_128x32b sram_128x32b_d1(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_d1), 
.rdata(sram_rdata_d1)
);

sram_128x32b sram_128x32b_d2(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_d2), 
.rdata(sram_rdata_d2)
);

sram_128x32b sram_128x32b_d3(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_d3), 
.rdata(sram_rdata_d3)
);

sram_128x32b sram_128x32b_d4(
.clk(clk),
.bytemask(4'd0),
.csb(1'b0),
.wsb(1'b1),
.wdata(8'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_d4), 
.rdata(sram_rdata_d4)
);
//sram connection(e0-e4)
sram_128x32b sram_128x32b_e0(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e0),
.wdata(sram_wdata_e), 
.waddr(sram_waddr_e), 
.raddr(sram_raddr_e4), 
.rdata(sram_rdata_e4)
);

sram_128x32b sram_128x32b_e1(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e1),
.wdata(sram_wdata_e), 
.waddr(sram_waddr_e), 
.raddr(sram_raddr_e4), 
.rdata(sram_rdata_e4)
);

sram_128x32b sram_128x32b_e2(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e1),
.wdata(sram_wdata_e), 
.waddr(sram_waddr_e), 
.raddr(sram_raddr_e2), 
.rdata(sram_rdata_e2)
);

sram_128x32b sram_128x32b_e3(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e3),
.wdata(sram_wdata_e), 
.waddr(sram_waddr_e), 
.raddr(sram_raddr_e3), 
.rdata(sram_rdata_e3)
);

sram_128x32b sram_128x32b_e4(
.clk(clk),
.bytemask(sram_bytemask_e),
.csb(1'b0),
.wsb(sram_write_enable_e4),
.wdata(sram_wdata_e), 
.waddr(sram_waddr_e), 
.raddr(sram_raddr_e4), 
.rdata(sram_rdata_e4)
);

//sram connection(f)
sram_128x32b sram_128x32b_f(
.clk(clk),
.bytemask(sram_bytemask_f),
.csb(1'b0),
.wsb(sram_write_enable_f),
.wdata(sram_wdata_f), 
.waddr(sram_waddr_f), 
.raddr(), 
.rdata()
);

//dump wave file
initial begin
  $fsdbDumpfile("fc_test.fsdb");  	       // "gray.fsdb" can be replaced into any name you want
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
integer pat_no, pat_length, hw_length, cycle_cnt_fc1, cycle_cnt_fc2, cycle_cnt_total;
integer i, j;
reg [4*800-1:0] fc1_w[0:500-1];
reg [4*500-1:0] fc2_w[0:10-1];
reg signed [31:0] fc1_output [0:125-1];
reg signed [31:0] fc1_golden [0:125-1];
reg signed [31:0] fc2_output [0:2];
reg signed [31:0] fc2_golden [0:2];
reg [31:0] pool2_golden [0:200-1];

initial begin
	$readmemb("weight_data/fc1_w.dat",fc1_w);
	$readmemb("weight_data/score_w.dat",fc2_w);
	$readmemh("golden/00/fc1_00.dat",fc1_golden);
	$readmemh("golden/00/fc2_00.dat",fc2_golden);
	$readmemb("golden/00/pool2_00.dat",pool2_golden);
	for(i = 0; i < 500; i= i + 1)begin
		for(j = 0; j < 40; j = j + 1)begin
        	sram_weight_0.load_w(i*40+j,fc1_w[i][j*80 +: 80]);
    	end
    end
    for(i = 0; i < 10; i = i + 1)begin
    	for(j = 0; j < 25; j = j + 1)begin
    		sram_weight_0.load_w(i*25+j + 20000,fc2_w[i][j*80 +: 80]);
    	end
    end
	mem_sel = 1; // load in c0-c4
	for(i = 0; i < 40;i = i + 1) begin
        sram_128x32b_c0.mem[i][31:24] = pool2_golden[5*i][31:24];
        sram_128x32b_c0.mem[i][23:16] = pool2_golden[5*i][23:16];
        sram_128x32b_c0.mem[i][15:8] = pool2_golden[5*i][15:8];  
        sram_128x32b_c0.mem[i][7:0] = pool2_golden[5*i][7:0];

        sram_128x32b_c1.mem[i][31:24] = pool2_golden[i*5 + 1][31:24];
        sram_128x32b_c1.mem[i][23:16] = pool2_golden[i*5 + 1][23:16];
        sram_128x32b_c1.mem[i][15:8] = pool2_golden[i*5 + 1][15:8];  
        sram_128x32b_c1.mem[i][7:0] = pool2_golden[i*5 + 1][7:0];  
        
        sram_128x32b_c2.mem[i][31:24] = pool2_golden[i*5 + 2][31:24];
        sram_128x32b_c2.mem[i][23:16] = pool2_golden[i*5 + 2][23:16];
        sram_128x32b_c2.mem[i][15:8] = pool2_golden[i*5 + 2][15:8];  
        sram_128x32b_c2.mem[i][7:0] = pool2_golden[i*5 + 2][7:0];

        sram_128x32b_c3.mem[i][31:24] = pool2_golden[i*5 + 3][31:24];
        sram_128x32b_c3.mem[i][23:16] = pool2_golden[i*5 + 3][23:16];
        sram_128x32b_c3.mem[i][15:8] = pool2_golden[i*5 + 3][15:8];  
        sram_128x32b_c3.mem[i][7:0] = pool2_golden[i*5 + 3][7:0];  

        sram_128x32b_c4.mem[i][31:24] = pool2_golden[i*5 + 4][31:24];
        sram_128x32b_c4.mem[i][23:16] = pool2_golden[i*5 + 4][23:16];
        sram_128x32b_c4.mem[i][15:8] = pool2_golden[i*5 + 4][15:8];  
        sram_128x32b_c4.mem[i][7:0] = pool2_golden[i*5 + 4][7:0];
    end
    srstn = 1'b1;
    @(negedge clk);
    srstn = 1'b0;
    @(negedge clk);
    srstn = 1'b1;
    conv_done = 1'b0;
	@(negedge clk);
	conv_done = 1'b1;
	@(negedge clk);
	conv_done = 1'b0;
	//Do CONV2 and POOL2 and write result to SRAM c

	while(~fc1_done)begin    //when break from this while, it means sram e0~e4 can be tested
        @(negedge clk);
        cycle_cnt_fc1 = cycle_cnt_fc1 + 1;
    end
    for (i = 0; i < 25; i = i + 1)begin
    	fc1_output[5*i] = sram_128x32b_e0.mem[i];
    	fc1_output[5*i+1] = sram_128x32b_e1.mem[i];
    	fc1_output[5*i+2] = sram_128x32b_e2.mem[i];
    	fc1_output[5*i+3] = sram_128x32b_e3.mem[i];
    	fc1_output[5*i+4] = sram_128x32b_e4.mem[i];
    end

    for(i = 0; i < 125; i = i + 1)begin
    	if(fc1_output[i] == fc1_golden[i])$write("sram #e[%g] address: %d PASS!!\n", i%5, i/5);
    	else begin
    		$write("You have wrong answer in the sram #e[%g] !!!\n\n", i%5);
            $write("Your answer at address %d is \n%d %d %d %d  \n" ,i/5, $signed(fc1_output[i][31:24])
            															, $signed(fc1_output[i][23:16])
            															, $signed(fc1_output[i][15:8])
            															, $signed(fc1_output[i][7:0]));
            $write("But the golden answer is  \n%d %d %d %d \n" , $signed(fc1_golden[i][31:24])
            													, $signed(fc1_golden[i][23:16])
            													, $signed(fc1_golden[i][15:8])
            													, $signed(fc1_golden[i][7:0]));
            $finish;
    	end
    end

    $write("|\n");
    $display("Congratulations! YOU PASS FC1!!!!!\n");
    $display("Start Testing FC2\n");
    while(~fc2_done)begin    //when break from this while, it means sram f can be tested
        @(negedge clk);
        cycle_cnt_fc2 = cycle_cnt_fc2 + 1;
    end
    for(i = 0; i < 3; i = i + 1)
    	fc2_output[i] = sram_128x32b_f.mem[i];
    for(i = 0; i < 3; i= i + 1)begin
    	if(fc2_output[i] == fc2_golden[i]) $write("sram #f address: %d PASS!!\n", i);
    	else begin
    		$write("You have wrong answer in the sram #f !!!\n\n");
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
    $write("|\n");
    $display("Congratulations! YOU PASS FC2!!!!!");
    $display("Steven you are so cool!!!!!");
    $display("Total cycle count in FC2 = %d.", cycle_cnt_fc2);
    $finish;
end

endmodule