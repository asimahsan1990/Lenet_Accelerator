/**
 * Editor : Steven
 * File : data_reg.v
 */

 module data_reg#(
    parameter DATA_NUM = 20,
    parameter DATA_WIDTH = 8,
    parameter DATA_NUM_PER_SRAM_ADDR = 4
)
(
 	input clk,
 	input srstn,

 	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c0,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c1,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c2,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c3,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_c4,

 	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d0,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d1,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d2,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d3,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_d4,

 	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e0,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e1,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e2,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e3,
	input [DATA_NUM_PER_SRAM_ADDR*DATA_WIDTH-1:0] sram_rdata_e4,
	
	input [1:0] sram_sel,			//select c, d or e SRAM

 	output reg [DATA_NUM*DATA_WIDTH-1:0] src_window,
 );

localparam SRAM_C = 0, SRAM_D = 1, SRAM_E = 2;

reg [DATA_NUM*DATA_WIDTH-1:0] src_box, n_src_box;

always@*begin
	case(sram_sel)
		SRAM_C: begin
			n_src_box = 
		end
		SRAM_D: begin
		end
		SRAM_E: begin
		end
		default:
			n_src_box = 0;
	endcase
end

always@(posedge clk)begin
	if(~srstn)
		src_box <= 0;
	else
		src_box <= n_src_box;
end

assign src_window = src_box;
endmodule



