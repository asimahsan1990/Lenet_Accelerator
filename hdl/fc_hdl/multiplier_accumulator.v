/**
 * Editor : 
 * File : multiplier_accumulator.v
 */
module multiplier_accumulator(
	input clk,
	input srstn,
	input [20*8-1:0] src_window,
	input [20*4-1:0] sram_rdata_weight,
	input accumulate_reset,
	output signed [31:0] data_out		//bit number > 8+4+10=22 is enough
);

localparam WEIGHT_WIDTH = 4;
localparam WEIGHT_NUM = 25;
localparam DATA_WIDTH = 8;
localparam MAC_NUM = 20;

// data width 8 +   weight width 4 = 12, and we have 20 MACs
reg signed [WEIGHT_WIDTH+DATA_WIDTH-1:0] accumulator [0:MAC_NUM-1];

integer i;
always@* begin
	for(i = 0;i<MAC_NUM;i=i+1) begin

	end
end
endmodule