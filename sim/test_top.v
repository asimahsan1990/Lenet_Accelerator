`timescale 1ns/100ps

`define PAT_START_NO 0
`define PAT_END_NO   2

`define cycle_period 10

module test_lenet;

localparam SRAM_DATA_WIDTH = 32;
localparam WEIGHT_NUM = 25, WEIGHT_WIDTH = 4;

//====== module I/O =====
reg clk;
reg srstn;
reg conv1_start;
reg conv2_start;

wire conv1_finish;
wire conv2_finish;

wire [WEIGHT_NUM*WEIGHT_WIDTH-1:0] sram_rdata_weight;
wire [16:0] conv1_sram_raddr_weight;       //read address to weight SRAM
wire [9:0] conv2_sram_raddr_weight;        //read address to weight SRAM
reg [16:0] sram_raddr_weight;              //read address to weight SRAM

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

wire [3:0] sram_bytemask_a;
wire [3:0] sram_bytemask_b;
wire [9:0] sram_waddr_a;
wire [9:0] sram_waddr_b;
wire [7:0] sram_wdata_a;
wire [7:0] sram_wdata_b;

wire signed [7:0] out;


reg [7:0] mem[0:32*32-1];


//====== top connection =====

conv1_top #(.WEIGHT_WIDTH(4),.WEIGHT_NUM(25),.DATA_WIDTH(8),.DATA_NUM_PER_SRAM_ADDR(4))
conv1_top (
.clk(clk),
.srstn(srstn),
.conv1_start(conv1_start),
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
.sram_raddr_weight(conv1_sram_raddr_weight),

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
.conv1_finish(conv1_finish)
);

conv2_top #(.WEIGHT_WIDTH(4),.WEIGHT_NUM(25),.DATA_WIDTH(8),.DATA_NUM_PER_SRAM_ADDR(4))
conv2_top(
.clk(clk),
.srstn(srstn),
.conv2_start(conv2_start),
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

.sram_raddr_b0(sram_raddr_b0),
.sram_raddr_b1(sram_raddr_b1),
.sram_raddr_b2(sram_raddr_b2),
.sram_raddr_b3(sram_raddr_b3),
.sram_raddr_b4(sram_raddr_b4),
.sram_raddr_b5(sram_raddr_b5),
.sram_raddr_b6(sram_raddr_b6),
.sram_raddr_b7(sram_raddr_b7),
.sram_raddr_b8(sram_raddr_b8),
.sram_raddr_weight(conv2_sram_raddr_weight),

.sram_write_enable_a0(sram_write_enable_a0),

.sram_bytemask_a(sram_bytemask_a),
.sram_waddr_a(sram_waddr_a),
.sram_wdata_a(sram_wdata_a),
.conv2_finish(conv2_finish)
);


//====== sram connection =====

sram_20000x100b sram_weight_0(
.clk(clk),
.csb(1'b0),
.wsb(1'b1),
.wdata(1'b0), 
.waddr(10'd0), 
.raddr(sram_raddr_weight), 
.rdata(sram_rdata_weight)
);

//sram connection

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

//SRAM 2 
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


//dump wave file
initial begin
  $fsdbDumpfile("lenet.fsdb"); // "gray.fsdb" can be replaced into any name you want
  $fsdbDumpvars("+mda");              // but make sure in .fsdb format
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

//====== main procedural block for simulation =====
integer pat_no, pat_length, hw_length, cycle_cnt;

integer col_cnt;
reg [7:0] weight_cnt,weight_cnt_2,weight_cnt_3;

integer i,j;
reg [17*8-1:0] pat_string;
reg [99:0] conv1_w[0:19];
reg [99:0] conv1_b[0:1];  //second row not use
reg [99:0] conv2_w[0:1000];
reg [99:0] conv2_b[0:1];
reg [4*800-1:0] fc1_w[0:500-1];
reg [4*500-1:0] score_w[0:10-1];
reg [7:0] golden_ans [0:9999];
reg [31:0] conv1_golden_sram[0:720-1];
reg [31:0] pool2_golden_sram[0:200-1];
reg [7:0] pool2_1d [0:800-1]; 
reg signed [7:0] fc1_output [0:500-1];
reg signed [7:0] score_output[0:9]; 
reg signed [31:0] tmp_sum;
reg signed [7:0] tmp_big;
reg [7:0] ans;
reg [1:0] layer_sel;

integer fp;

initial begin
  //$fsdbDumpvars;
    $readmemb("weight_data/conv1_w.dat",conv1_w);
    $readmemb("weight_data/conv1_b.dat",conv1_b);
    $readmemb("weight_data/conv2_w.dat",conv2_w);
    $readmemb("weight_data/conv2_b.dat",conv2_b);
    $readmemb("weight_data/fc1_w.dat",fc1_w);
    $readmemb("weight_data/score_w.dat",score_w);

    $readmemh("golden/golden_ans.dat",golden_ans);
    $readmemh("golden/conv1_golden.dat",conv1_golden_sram);
    $readmemb("golden/conv2_golden.dat",pool2_golden_sram);
    
    //====== load conv1_w =====
    for(i = 0; i < 20; i= i + 1)begin
        sram_weight_0.load_w(i,conv1_w[i]);
    end

    //====== load conv1_b =====
    sram_weight_0.load_w(20,conv1_b[0]);
    
    //====== load conv2_w =====
    for(i = 21; i < 1021; i= i + 1)begin
        sram_weight_0.load_w(i,conv2_w[i-21]);
    end

    //====== load conv2_b =====
    for(i = 1021; i < 1023; i = i + 1) begin
        sram_weight_0.load_w(i,conv2_b[i-1021]);
    end

    //====== load fc1_w =====
    for(i = 1100; i < 17100; i = i + 1) begin
        sram_weight_0.load_w(i,fc1_w[i-1100]);
    end

    //====== load score_w =====
    for(i = 17100; i < 17300; i = i + 1) begin
        sram_weight_0.load_w(i,score_w[i-17100]);
    end

    #(`cycle_period);
    
    for(pat_no=`PAT_START_NO;pat_no<=`PAT_END_NO;pat_no=pat_no+1) begin
        bmp2sram(pat_no); //load mnist (.bmp) into SRAM

        $write("|\n");
        $write("The input pattern is No.%d:\n",pat_no);
        $write("|\n");
        display_sram;  

        /////////////////////////////////////////////////////////
        
        //you can choose test only CONV1 , CONV1 + CONV2 or whole lenet
        //CONV1 : 0  , CONV2 : 1 , ALL : 2
        layer_sel = 1;
        conv1_start = 1'b0;
        conv2_start = 1'b0;

        /////////////////////////////////////////////////////////

        //Do CONV1 and POOL1 and write result to SRAM B
        
        @(negedge clk);
        srstn = 1'b0;
        @(negedge clk);
        srstn = 1'b1;
        conv1_start = 1'b1;  //one-cycle pulse signal  
        @(negedge clk);
        conv1_start = 1'b0;
        sram_raddr_weight = conv1_sram_raddr_weight;

        while(~conv1_finish)begin    //it's mean that your sram a0 can be tested
            @(negedge clk);  begin
                sram_raddr_weight = conv1_sram_raddr_weight;
            end
        end

        if(layer_sel == 0) begin
            $write("\n");
            $write("You already finished the CONV1 and POOL1 !!!!!\n");
            $write("Now you can open the nWave to check the waveform ! \n");
            $finish;
        end
        
        //start to do CONV2 and POOL2, and write your result into sram a0 

        cycle_cnt = 0;

        @(negedge clk);
        conv2_start = 1'b1;  //one-cycle pulse signal  
        @(negedge clk);
        conv2_start = 1'b0;
        sram_raddr_weight = {7'd0,conv2_sram_raddr_weight};
        while(~conv2_finish)begin    //it's mean that your sram a0 can be tested
            @(negedge clk);     begin
                cycle_cnt = cycle_cnt + 1;
                sram_raddr_weight = {7'd0,conv2_sram_raddr_weight};
            end
        end

        for(i = 0; i < 200;i = i + 1) begin
            pool2_1d[i*4] = sram_128x32b_a0.mem[i][31:24];
            pool2_1d[i*4 + 1] = sram_128x32b_a0.mem[i][23:16];
            pool2_1d[i*4 + 2] = sram_128x32b_a0.mem[i][15:8];  
            pool2_1d[i*4 + 3] = sram_128x32b_a0.mem[i][7:0];      
        end

        //show the conv2_ouptut feature map 20x4x4 feature map to let you check the answer
        
        for(i = 0; i < 50; i = i + 1) begin
            $write("------POOL2's output feature map from Weight %d------\n",i[7:0]);
            for (j = 0;j < 16 ;j = j + 1) begin
                 $write("%d ",$signed(pool2_1d[i * 16 + j]));
                 if((j+1) % 4 == 0) $write("\n");
            end 
        end
        
    // test your CONV2 answer!!! 
        if(layer_sel == 1) begin
            for(i = 0; i < 200; i = i + 1) begin
                if(pool2_golden_sram[i] == sram_128x32b_a0.mem[i]) $write("sram #a0 address: %d PASS!!\n",i[7:0]); 
                else begin
                    $write("You have wrong answer in the sram #a0 !!!\n\n");
                    $write("Your answer at address %d is \n%d %d %d %d  \n",i[7:0],$signed(sram_128x32b_a0.mem[i][31:24]),$signed(sram_128x32b_a0.mem[i][23:16]),$signed(sram_128x32b_a0.mem[i][15:8]),$signed(sram_128x32b_a0.mem[i][7:0]));
                    $write("But the golden answer is  \n%d %d %d %d \n",$signed(pool2_golden_sram[i][31:24]),$signed(pool2_golden_sram[i][23:16]),$signed(pool2_golden_sram[i][15:8]),$signed(pool2_golden_sram[i][7:0]));
                    $finish;
                end
            end
            $write("|\n");
            $display("Congratulations! YOU PASS CONV2!!!!!");
            $display("Total cycle count C in CONV2 = %d.", cycle_cnt);
            $finish;
        end
      
        //////////////////////////////////////////////
        // do FC1 and FC2 by testbench
        FC1_layer;
        FC2_layer;
        //////////////////////////////////////////////
        //test the lenet answer
        if (layer_sel == 2) begin
            if(ans == golden_ans[pat_no])  $write("Your answer is : %d , PASS!!\n",ans);
            else begin  
            $write(" Wrong!!!!!!!!!!!!!!!,you have wrong answer\n");
            $write("Your answer is : %d , but the golden is : %d \n",ans,golden_ans[pat_no]);
            #5 $finish;
            end
        end
    end
    $display("Congratulations! Simulation from pattern no %04d to %04d is successfully passed!", `PAT_START_NO, `PAT_END_NO);
    #5 $finish;
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


task FC1_layer;
    begin
        for(i = 0; i < 200;i = i + 1) begin
            pool2_1d[i*4] = sram_128x32b_a0.mem[i][31:24];
            pool2_1d[i*4 + 1] = sram_128x32b_a0.mem[i][23:16];
            pool2_1d[i*4 + 2] = sram_128x32b_a0.mem[i][15:8];  
            pool2_1d[i*4 + 3] = sram_128x32b_a0.mem[i][7:0];      
        end
        // calculate for fc1_output
        for (i = 0; i < 500;i = i + 1) begin
            tmp_sum = 0;
            for (j = 0; j < 800;j = j + 1) begin
                tmp_sum = tmp_sum + $signed(pool2_1d[j]) * $signed(fc1_w[i][(799-j)*4 +: 4]);
            end
            tmp_sum = tmp_sum + 32;
            tmp_sum = tmp_sum >>> 6;
            if(tmp_sum >= 127) fc1_output[i] = 127;
            else if(tmp_sum < 0) fc1_output[i] = 0;
            else fc1_output[i] = tmp_sum[7:0];
        end
        //show the fc1_output feature map 500x1 feature map
        $write("------Show the feature map of fc1 output ------\n");
        for(i = 0; i < 100; i = i + 1) begin
            for (j = 0;j < 5 ;j = j + 1) begin
                 $write("%d ",$signed(fc1_output[i * 5 + j]));
                 if((j+1) % 5 == 0) $write("\n");
            end 
        end
    end
endtask

task FC2_layer;
    begin
        //calculate for score_output
        for (i = 0; i < 10;i = i + 1) begin
            tmp_sum = 0;
            for (j = 0; j < 500;j = j + 1) begin
                tmp_sum = tmp_sum + $signed(fc1_output[j]) * $signed(score_w[i][(499-j)*4 +: 4]);
            end
            tmp_sum = tmp_sum + 16;
            tmp_sum = tmp_sum >>> 5;
            if(tmp_sum >= 127) score_output[i] = 127;
            else if(tmp_sum < -128) score_output[i] = -128;
            else score_output[i] = tmp_sum[7:0];
        end
        $write("------Show the feature map of FC2 output ------\n");
        tmp_big = 0;
        ans = 0;
        for(i = 0; i < 10; i = i + 1) begin
            $write("%d ",score_output[i]);
            ans = (tmp_big >= score_output[i])? ans : i[7:0];
            tmp_big = (tmp_big >= score_output[i])? tmp_big : score_output[i];
        end
        $write("\n");
    end
endtask


endmodule
