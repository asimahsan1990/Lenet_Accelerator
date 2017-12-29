module data_reg(
input clk,
input srstn,
input [1:0] mode,
input [3:0] box_sel,
input [31:0] sram_rdata_a0,
input [31:0] sram_rdata_a1,
input [31:0] sram_rdata_a2,
input [31:0] sram_rdata_a3,
input [31:0] sram_rdata_a4,
input [31:0] sram_rdata_a5,
input [31:0] sram_rdata_a6,
input [31:0] sram_rdata_a7,
input [31:0] sram_rdata_a8,
input [31:0] sram_rdata_b0,
input [31:0] sram_rdata_b1,
input [31:0] sram_rdata_b2,
input [31:0] sram_rdata_b3,
input [31:0] sram_rdata_b4,
input [31:0] sram_rdata_b5,
input [31:0] sram_rdata_b6,
input [31:0] sram_rdata_b7,
input [31:0] sram_rdata_b8,
input [99:0] sram_rdata_weight,

output reg [99:0] conv1_weight,
output reg [99:0] weight,
output reg [36*8-1:0] src_window
);

localparam IDLE = 0, CONV1 = 1, CONV2 = 2, DONE = 3;

localparam RESET_SEL_DATA = 4'b0000;
localparam SEL_DATA_TYPE1 = 4'b0001, SEL_DATA_TYPE2 = 4'b0010 , SEL_DATA_TYPE3 = 4'b0011;
localparam SEL_DATA_TYPE4 = 4'b0101, SEL_DATA_TYPE5 = 4'b0110 , SEL_DATA_TYPE6 = 4'b0111;
localparam SEL_DATA_TYPE7 = 4'b1001, SEL_DATA_TYPE8 = 4'b1010 , SEL_DATA_TYPE9 = 4'b1011;
localparam HOLD_DATA = 4'b1111;

reg [31:0] sram_rdata_0;
reg [31:0] sram_rdata_1;
reg [31:0] sram_rdata_2;
reg [31:0] sram_rdata_3;
reg [31:0] sram_rdata_4;
reg [31:0] sram_rdata_5;
reg [31:0] sram_rdata_6;
reg [31:0] sram_rdata_7;
reg [31:0] sram_rdata_8;
reg [7:0] src_aox [0:35];
reg [7:0] n_src_aox [0:35];

reg [31:0] i;

always@(posedge clk) begin
    if(~srstn) begin
        for(i = 0; i < 36; i = i + 1) src_aox[i] <= 0;
        weight <= 0;
        conv1_weight <= 0;
    end
    else begin
        for(i = 0; i < 36; i = i + 1) src_aox[i] <= n_src_aox[i];
        weight <= conv1_weight;
        conv1_weight <= sram_rdata_weight;
    end
end

always@(posedge clk) begin
	if(~srstn) begin
		sram_rdata_0 <= 0;
		sram_rdata_1 <= 0;
		sram_rdata_2 <= 0;
		sram_rdata_3 <= 0;
		sram_rdata_4 <= 0;
		sram_rdata_5 <= 0;
		sram_rdata_6 <= 0;
		sram_rdata_7 <= 0;
		sram_rdata_8 <= 0;
	end
	else begin
		if(mode == CONV2) begin
        	sram_rdata_0 <= sram_rdata_b0;
        	sram_rdata_1 <= sram_rdata_b1;
        	sram_rdata_2 <= sram_rdata_b2;
        	sram_rdata_3 <= sram_rdata_b3;
        	sram_rdata_4 <= sram_rdata_b4;
        	sram_rdata_5 <= sram_rdata_b5;
        	sram_rdata_6 <= sram_rdata_b6;
        	sram_rdata_7 <= sram_rdata_b7;
        	sram_rdata_8 <= sram_rdata_b8;
    	end
    	else begin
    		sram_rdata_0 <= sram_rdata_a0;
        	sram_rdata_1 <= sram_rdata_a1;
        	sram_rdata_2 <= sram_rdata_a2;
        	sram_rdata_3 <= sram_rdata_a3;
        	sram_rdata_4 <= sram_rdata_a4;
        	sram_rdata_5 <= sram_rdata_a5;
        	sram_rdata_6 <= sram_rdata_a6;
        	sram_rdata_7 <= sram_rdata_a7;
        	sram_rdata_8 <= sram_rdata_a8;
    	end
	end
end

always@* begin
    case (box_sel)
        RESET_SEL_DATA : begin
            for(i = 0; i < 36; i = i + 1) n_src_aox[i] = 0;
        end
        SEL_DATA_TYPE1 : begin
            n_src_aox[0] = sram_rdata_0[31:24];
            n_src_aox[1] = sram_rdata_0[23:16];
            n_src_aox[2] = sram_rdata_1[31:24];
            n_src_aox[3] = sram_rdata_1[23:16];
            n_src_aox[4] = sram_rdata_2[31:24];
            n_src_aox[5] = sram_rdata_2[23:16];
            //rw2
            n_src_aox[6] = sram_rdata_0[15:8];
            n_src_aox[7] = sram_rdata_0[7:0];
            n_src_aox[8] = sram_rdata_1[15:8];
            n_src_aox[9] = sram_rdata_1[7:0];
            n_src_aox[10] = sram_rdata_2[15:8];
            n_src_aox[11] = sram_rdata_2[7:0];
            //rw3
            n_src_aox[12] = sram_rdata_3[31:24];
            n_src_aox[13] = sram_rdata_3[23:16];
            n_src_aox[14] = sram_rdata_4[31:24];
            n_src_aox[15] = sram_rdata_4[23:16];
            n_src_aox[16] = sram_rdata_5[31:24];
            n_src_aox[17] = sram_rdata_5[23:16];
            //rw4
            n_src_aox[18] = sram_rdata_3[15:8];
            n_src_aox[19] = sram_rdata_3[7:0];
            n_src_aox[20] = sram_rdata_4[15:8];
            n_src_aox[21] = sram_rdata_4[7:0];
            n_src_aox[22] = sram_rdata_5[15:8];
            n_src_aox[23] = sram_rdata_5[7:0];
            //rw5
            n_src_aox[24] = sram_rdata_6[31:24];
            n_src_aox[25] = sram_rdata_6[23:16];
            n_src_aox[26] = sram_rdata_7[31:24];
            n_src_aox[27] = sram_rdata_7[23:16];
            n_src_aox[28] = sram_rdata_8[31:24];
            n_src_aox[29] = sram_rdata_8[23:16];
            //rw6
            n_src_aox[30] = sram_rdata_6[15:8];
            n_src_aox[31] = sram_rdata_6[7:0];
            n_src_aox[32] = sram_rdata_7[15:8];
            n_src_aox[33] = sram_rdata_7[7:0];
            n_src_aox[34] = sram_rdata_8[15:8];
            n_src_aox[35] = sram_rdata_8[7:0];
        end
        SEL_DATA_TYPE2 : begin
            n_src_aox[0] = sram_rdata_1[31:24];
            n_src_aox[1] = sram_rdata_1[23:16];
            n_src_aox[2] = sram_rdata_2[31:24];
            n_src_aox[3] = sram_rdata_2[23:16];
            n_src_aox[4] = sram_rdata_0[31:24];
            n_src_aox[5] = sram_rdata_0[23:16];
            //rw2
            n_src_aox[6] = sram_rdata_1[15:8];
            n_src_aox[7] = sram_rdata_1[7:0];
            n_src_aox[8] = sram_rdata_2[15:8];
            n_src_aox[9] = sram_rdata_2[7:0];
            n_src_aox[10] = sram_rdata_0[15:8];
            n_src_aox[11] = sram_rdata_0[7:0];
            //rw3
            n_src_aox[12] = sram_rdata_4[31:24];
            n_src_aox[13] = sram_rdata_4[23:16];
            n_src_aox[14] = sram_rdata_5[31:24];
            n_src_aox[15] = sram_rdata_5[23:16];
            n_src_aox[16] = sram_rdata_3[31:24];
            n_src_aox[17] = sram_rdata_3[23:16];
            //rw4
            n_src_aox[18] = sram_rdata_4[15:8];
            n_src_aox[19] = sram_rdata_4[7:0];
            n_src_aox[20] = sram_rdata_5[15:8];
            n_src_aox[21] = sram_rdata_5[7:0];
            n_src_aox[22] = sram_rdata_3[15:8];
            n_src_aox[23] = sram_rdata_3[7:0];
            //rw5
            n_src_aox[24] = sram_rdata_7[31:24];
            n_src_aox[25] = sram_rdata_7[23:16];
            n_src_aox[26] = sram_rdata_8[31:24];
            n_src_aox[27] = sram_rdata_8[23:16];
            n_src_aox[28] = sram_rdata_6[31:24];
            n_src_aox[29] = sram_rdata_6[23:16];
            //rw6
            n_src_aox[30] = sram_rdata_7[15:8];
            n_src_aox[31] = sram_rdata_7[7:0];
            n_src_aox[32] = sram_rdata_8[15:8];
            n_src_aox[33] = sram_rdata_8[7:0];
            n_src_aox[34] = sram_rdata_6[15:8];
            n_src_aox[35] = sram_rdata_6[7:0];                
        end 
        SEL_DATA_TYPE3 : begin
            n_src_aox[0] = sram_rdata_2[31:24];
            n_src_aox[1] = sram_rdata_2[23:16];
            n_src_aox[2] = sram_rdata_0[31:24];
            n_src_aox[3] = sram_rdata_0[23:16];
            n_src_aox[4] = sram_rdata_1[31:24];
            n_src_aox[5] = sram_rdata_1[23:16];
            //rw2
            n_src_aox[6] = sram_rdata_2[15:8];
            n_src_aox[7] = sram_rdata_2[7:0];
            n_src_aox[8] = sram_rdata_0[15:8];
            n_src_aox[9] = sram_rdata_0[7:0];
            n_src_aox[10] = sram_rdata_1[15:8];
            n_src_aox[11] = sram_rdata_1[7:0];
            //rw3
            n_src_aox[12] = sram_rdata_5[31:24];
            n_src_aox[13] = sram_rdata_5[23:16];
            n_src_aox[14] = sram_rdata_3[31:24];
            n_src_aox[15] = sram_rdata_3[23:16];
            n_src_aox[16] = sram_rdata_4[31:24];
            n_src_aox[17] = sram_rdata_4[23:16];
            //rw4
            n_src_aox[18] = sram_rdata_5[15:8];
            n_src_aox[19] = sram_rdata_5[7:0];
            n_src_aox[20] = sram_rdata_3[15:8];
            n_src_aox[21] = sram_rdata_3[7:0];
            n_src_aox[22] = sram_rdata_4[15:8];
            n_src_aox[23] = sram_rdata_4[7:0];
            //rw5
            n_src_aox[24] = sram_rdata_8[31:24];
            n_src_aox[25] = sram_rdata_8[23:16];
            n_src_aox[26] = sram_rdata_6[31:24];
            n_src_aox[27] = sram_rdata_6[23:16];
            n_src_aox[28] = sram_rdata_7[31:24];
            n_src_aox[29] = sram_rdata_7[23:16];
            //rw6
            n_src_aox[30] = sram_rdata_8[15:8];
            n_src_aox[31] = sram_rdata_8[7:0];
            n_src_aox[32] = sram_rdata_6[15:8];
            n_src_aox[33] = sram_rdata_6[7:0];
            n_src_aox[34] = sram_rdata_7[15:8];
            n_src_aox[35] = sram_rdata_7[7:0];
        end 
        SEL_DATA_TYPE4 : begin
            n_src_aox[0] = sram_rdata_3[31:24];
            n_src_aox[1] = sram_rdata_3[23:16];
            n_src_aox[2] = sram_rdata_4[31:24];
            n_src_aox[3] = sram_rdata_4[23:16];
            n_src_aox[4] = sram_rdata_5[31:24];
            n_src_aox[5] = sram_rdata_5[23:16];
            //rw2
            n_src_aox[6] = sram_rdata_3[15:8];
            n_src_aox[7] = sram_rdata_3[7:0];
            n_src_aox[8] = sram_rdata_4[15:8];
            n_src_aox[9] = sram_rdata_4[7:0];
            n_src_aox[10] = sram_rdata_5[15:8];
            n_src_aox[11] = sram_rdata_5[7:0];
            //rw3
            n_src_aox[12] = sram_rdata_6[31:24];
            n_src_aox[13] = sram_rdata_6[23:16];
            n_src_aox[14] = sram_rdata_7[31:24];
            n_src_aox[15] = sram_rdata_7[23:16];
            n_src_aox[16] = sram_rdata_8[31:24];
            n_src_aox[17] = sram_rdata_8[23:16];
            //rw4
            n_src_aox[18] = sram_rdata_6[15:8];
            n_src_aox[19] = sram_rdata_6[7:0];
            n_src_aox[20] = sram_rdata_7[15:8];
            n_src_aox[21] = sram_rdata_7[7:0];
            n_src_aox[22] = sram_rdata_8[15:8];
            n_src_aox[23] = sram_rdata_8[7:0];
            //rw5
            n_src_aox[24] = sram_rdata_0[31:24];
            n_src_aox[25] = sram_rdata_0[23:16];
            n_src_aox[26] = sram_rdata_1[31:24];
            n_src_aox[27] = sram_rdata_1[23:16];
            n_src_aox[28] = sram_rdata_2[31:24];
            n_src_aox[29] = sram_rdata_2[23:16];
            //rw6
            n_src_aox[30] = sram_rdata_0[15:8];
            n_src_aox[31] = sram_rdata_0[7:0];
            n_src_aox[32] = sram_rdata_1[15:8];
            n_src_aox[33] = sram_rdata_1[7:0];
            n_src_aox[34] = sram_rdata_2[15:8];
            n_src_aox[35] = sram_rdata_2[7:0]; 
        end 
        SEL_DATA_TYPE5 : begin
            n_src_aox[0] = sram_rdata_4[31:24];
            n_src_aox[1] = sram_rdata_4[23:16];
            n_src_aox[2] = sram_rdata_5[31:24];
            n_src_aox[3] = sram_rdata_5[23:16];
            n_src_aox[4] = sram_rdata_3[31:24];
            n_src_aox[5] = sram_rdata_3[23:16];
            //rw2
            n_src_aox[6] = sram_rdata_4[15:8];
            n_src_aox[7] = sram_rdata_4[7:0];
            n_src_aox[8] = sram_rdata_5[15:8];
            n_src_aox[9] = sram_rdata_5[7:0];
            n_src_aox[10] = sram_rdata_3[15:8];
            n_src_aox[11] = sram_rdata_3[7:0];
            //rw3
            n_src_aox[12] = sram_rdata_7[31:24];
            n_src_aox[13] = sram_rdata_7[23:16];
            n_src_aox[14] = sram_rdata_8[31:24];
            n_src_aox[15] = sram_rdata_8[23:16];
            n_src_aox[16] = sram_rdata_6[31:24];
            n_src_aox[17] = sram_rdata_6[23:16];
            //rw4
            n_src_aox[18] = sram_rdata_7[15:8];
            n_src_aox[19] = sram_rdata_7[7:0];
            n_src_aox[20] = sram_rdata_8[15:8];
            n_src_aox[21] = sram_rdata_8[7:0];
            n_src_aox[22] = sram_rdata_6[15:8];
            n_src_aox[23] = sram_rdata_6[7:0];
            //rw5
            n_src_aox[24] = sram_rdata_1[31:24];
            n_src_aox[25] = sram_rdata_1[23:16];
            n_src_aox[26] = sram_rdata_2[31:24];
            n_src_aox[27] = sram_rdata_2[23:16];
            n_src_aox[28] = sram_rdata_0[31:24];
            n_src_aox[29] = sram_rdata_0[23:16];
            //rw6
            n_src_aox[30] = sram_rdata_1[15:8];
            n_src_aox[31] = sram_rdata_1[7:0];
            n_src_aox[32] = sram_rdata_2[15:8];
            n_src_aox[33] = sram_rdata_2[7:0];
            n_src_aox[34] = sram_rdata_0[15:8];
            n_src_aox[35] = sram_rdata_0[7:0]; 
        end 
        SEL_DATA_TYPE6 : begin
            n_src_aox[0] = sram_rdata_5[31:24];
            n_src_aox[1] = sram_rdata_5[23:16];
            n_src_aox[2] = sram_rdata_3[31:24];
            n_src_aox[3] = sram_rdata_3[23:16];
            n_src_aox[4] = sram_rdata_4[31:24];
            n_src_aox[5] = sram_rdata_4[23:16];
            //rw2
            n_src_aox[6] = sram_rdata_5[15:8];
            n_src_aox[7] = sram_rdata_5[7:0];
            n_src_aox[8] = sram_rdata_3[15:8];
            n_src_aox[9] = sram_rdata_3[7:0];
            n_src_aox[10] = sram_rdata_4[15:8];
            n_src_aox[11] = sram_rdata_4[7:0];
            //rw3
            n_src_aox[12] = sram_rdata_8[31:24];
            n_src_aox[13] = sram_rdata_8[23:16];
            n_src_aox[14] = sram_rdata_6[31:24];
            n_src_aox[15] = sram_rdata_6[23:16];
            n_src_aox[16] = sram_rdata_7[31:24];
            n_src_aox[17] = sram_rdata_7[23:16];
            //rw4
            n_src_aox[18] = sram_rdata_8[15:8];
            n_src_aox[19] = sram_rdata_8[7:0];
            n_src_aox[20] = sram_rdata_6[15:8];
            n_src_aox[21] = sram_rdata_6[7:0];
            n_src_aox[22] = sram_rdata_7[15:8];
            n_src_aox[23] = sram_rdata_7[7:0];
            //rw5
            n_src_aox[24] = sram_rdata_2[31:24];
            n_src_aox[25] = sram_rdata_2[23:16];
            n_src_aox[26] = sram_rdata_0[31:24];
            n_src_aox[27] = sram_rdata_0[23:16];
            n_src_aox[28] = sram_rdata_1[31:24];
            n_src_aox[29] = sram_rdata_1[23:16];
            //rw6
            n_src_aox[30] = sram_rdata_2[15:8];
            n_src_aox[31] = sram_rdata_2[7:0];
            n_src_aox[32] = sram_rdata_0[15:8];
            n_src_aox[33] = sram_rdata_0[7:0];
            n_src_aox[34] = sram_rdata_1[15:8];
            n_src_aox[35] = sram_rdata_1[7:0]; 
        end 
        SEL_DATA_TYPE7 : begin
            //row1
            n_src_aox[0] = sram_rdata_6[31:24];
            n_src_aox[1] = sram_rdata_6[23:16];
            n_src_aox[2] = sram_rdata_7[31:24];
            n_src_aox[3] = sram_rdata_7[23:16];
            n_src_aox[4] = sram_rdata_8[31:24];
            n_src_aox[5] = sram_rdata_8[23:16];
        //row2
            n_src_aox[6] = sram_rdata_6[15:8];
            n_src_aox[7] = sram_rdata_6[7:0];
            n_src_aox[8] = sram_rdata_7[15:8];
            n_src_aox[9] = sram_rdata_7[7:0];
            n_src_aox[10] = sram_rdata_8[15:8];
            n_src_aox[11] = sram_rdata_8[7:0];
        //row3
            n_src_aox[12] = sram_rdata_0[31:24];
            n_src_aox[13] = sram_rdata_0[23:16];
            n_src_aox[14] = sram_rdata_1[31:24];
            n_src_aox[15] = sram_rdata_1[23:16];
            n_src_aox[16] = sram_rdata_2[31:24];
            n_src_aox[17] = sram_rdata_2[23:16];
        //row4
            n_src_aox[18] = sram_rdata_0[15:8];
            n_src_aox[19] = sram_rdata_0[7:0];
            n_src_aox[20] = sram_rdata_1[15:8];
            n_src_aox[21] = sram_rdata_1[7:0];
            n_src_aox[22] = sram_rdata_2[15:8];
            n_src_aox[23] = sram_rdata_2[7:0];
        //row5
            n_src_aox[24] = sram_rdata_3[31:24];
            n_src_aox[25] = sram_rdata_3[23:16];
            n_src_aox[26] = sram_rdata_4[31:24];
            n_src_aox[27] = sram_rdata_4[23:16];
            n_src_aox[28] = sram_rdata_5[31:24];
            n_src_aox[29] = sram_rdata_5[23:16];
        //row6
            n_src_aox[30] = sram_rdata_3[15:8];
            n_src_aox[31] = sram_rdata_3[7:0];
            n_src_aox[32] = sram_rdata_4[15:8];
            n_src_aox[33] = sram_rdata_4[7:0];
            n_src_aox[34] = sram_rdata_5[15:8];
            n_src_aox[35] = sram_rdata_5[7:0]; 
        end 
        SEL_DATA_TYPE8 : begin
        //row1
            n_src_aox[0] = sram_rdata_7[31:24];
            n_src_aox[1] = sram_rdata_7[23:16];
            n_src_aox[2] = sram_rdata_8[31:24];
            n_src_aox[3] = sram_rdata_8[23:16];
            n_src_aox[4] = sram_rdata_6[31:24];
            n_src_aox[5] = sram_rdata_6[23:16];
        //row2
            n_src_aox[6] = sram_rdata_7[15:8];
            n_src_aox[7] = sram_rdata_7[7:0];
            n_src_aox[8] = sram_rdata_8[15:8];
            n_src_aox[9] = sram_rdata_8[7:0];
            n_src_aox[10] = sram_rdata_6[15:8];
            n_src_aox[11] = sram_rdata_6[7:0];
        //row3
            n_src_aox[12] = sram_rdata_1[31:24];
            n_src_aox[13] = sram_rdata_1[23:16];
            n_src_aox[14] = sram_rdata_2[31:24];
            n_src_aox[15] = sram_rdata_2[23:16];
            n_src_aox[16] = sram_rdata_0[31:24];
            n_src_aox[17] = sram_rdata_0[23:16];
        //row4
            n_src_aox[18] = sram_rdata_1[15:8];
            n_src_aox[19] = sram_rdata_1[7:0];
            n_src_aox[20] = sram_rdata_2[15:8];
            n_src_aox[21] = sram_rdata_2[7:0];
            n_src_aox[22] = sram_rdata_0[15:8];
            n_src_aox[23] = sram_rdata_0[7:0];
        //row5
            n_src_aox[24] = sram_rdata_4[31:24];
            n_src_aox[25] = sram_rdata_4[23:16];
            n_src_aox[26] = sram_rdata_5[31:24];
            n_src_aox[27] = sram_rdata_5[23:16];
            n_src_aox[28] = sram_rdata_3[31:24];
            n_src_aox[29] = sram_rdata_3[23:16];
        //row6
            n_src_aox[30] = sram_rdata_4[15:8];
            n_src_aox[31] = sram_rdata_4[7:0];
            n_src_aox[32] = sram_rdata_5[15:8];
            n_src_aox[33] = sram_rdata_5[7:0];
            n_src_aox[34] = sram_rdata_3[15:8];
            n_src_aox[35] = sram_rdata_3[7:0]; 
        end
        SEL_DATA_TYPE9 : begin
        //row1
            n_src_aox[0] = sram_rdata_8[31:24];
            n_src_aox[1] = sram_rdata_8[23:16];
            n_src_aox[2] = sram_rdata_6[31:24];
            n_src_aox[3] = sram_rdata_6[23:16];
            n_src_aox[4] = sram_rdata_7[31:24];
            n_src_aox[5] = sram_rdata_7[23:16];
        //row2
            n_src_aox[6] = sram_rdata_8[15:8];
            n_src_aox[7] = sram_rdata_8[7:0];
            n_src_aox[8] = sram_rdata_6[15:8];
            n_src_aox[9] = sram_rdata_6[7:0];
            n_src_aox[10] = sram_rdata_7[15:8];
            n_src_aox[11] = sram_rdata_7[7:0];
        //row3
            n_src_aox[12] = sram_rdata_2[31:24];
            n_src_aox[13] = sram_rdata_2[23:16];
            n_src_aox[14] = sram_rdata_0[31:24];
            n_src_aox[15] = sram_rdata_0[23:16];
            n_src_aox[16] = sram_rdata_1[31:24];
            n_src_aox[17] = sram_rdata_1[23:16];
        //row4
            n_src_aox[18] = sram_rdata_2[15:8];
            n_src_aox[19] = sram_rdata_2[7:0];
            n_src_aox[20] = sram_rdata_0[15:8];
            n_src_aox[21] = sram_rdata_0[7:0];
            n_src_aox[22] = sram_rdata_1[15:8];
            n_src_aox[23] = sram_rdata_1[7:0];
        //row5
            n_src_aox[24] = sram_rdata_5[31:24];
            n_src_aox[25] = sram_rdata_5[23:16];
            n_src_aox[26] = sram_rdata_3[31:24];
            n_src_aox[27] = sram_rdata_3[23:16];
            n_src_aox[28] = sram_rdata_4[31:24];
            n_src_aox[29] = sram_rdata_4[23:16];
        //row6
            n_src_aox[30] = sram_rdata_5[15:8];
            n_src_aox[31] = sram_rdata_5[7:0];
            n_src_aox[32] = sram_rdata_3[15:8];
            n_src_aox[33] = sram_rdata_3[7:0];
            n_src_aox[34] = sram_rdata_4[15:8];
            n_src_aox[35] = sram_rdata_4[7:0]; 
        end 
        default: begin
            for(i = 0; i < 36; i = i + 1) n_src_aox[i] = 0;
        end
    endcase
end

always@* begin
    for (i = 0;i < 36; i = i + 1 ) begin
        src_window[(35-i)*8 +: 8] = src_aox[i];
    end
end

endmodule