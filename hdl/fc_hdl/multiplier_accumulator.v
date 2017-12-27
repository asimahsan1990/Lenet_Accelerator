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
localparam WEIGHT_NUM = 20;
localparam DATA_WIDTH = 8;
localparam DATA_NUM = 20;
localparam MAC_NUM = 20;

// data width 8 +   weight width 4 = 12, and we have 20 MACs

reg signed [16:0] accumulator;
reg signed [WEIGHT_WIDTH+DATA_WIDTH-1:0] multiplier [0:MAC_NUM-1];

reg signed [WEIGHT_WIDTH-1:0] n_fc_weight_box [0:MAC_NUM-1];
reg signed [WEIGHT_WIDTH-1:0] fc_weight_box [0:MAC_NUM-1];

reg signed [DATA_WIDTH-1:0] fc_input_box [0:MAC_NUM-1];

reg signed [22:0] accumulator_sum, n_accumulator_sum;
integer i;

//arrange weight data w/ FF
always@* begin
	for(i = 0; i<MAC_NUM; i = i+1)begin
		n_fc_weight_box[i] = sram_rdata_weight[WEIGHT_WIDTH*(WEIGHT_NUM-1-i)+:WEIGHT_WIDTH];
	end
end
always@(posedge clk)begin
	if(~srstn)
		fc_weight_box <= 0;
	else
		fc_weight_box <= n_fc_weight_box;
end

//arrange input data w/o FF
always@*begin
	for(i = 0; i<MAC_NUM; i = i+1)begin
		fc_input_box[i] = src_window[DATA_WIDTH*(DATA_NUM-1-i)+:DATA_WIDTH];
	end
end

//multiply and add
always@* begin
	for(i = 0; i<MAC_NUM; i=i+1) begin
		multiplier[i] = src_window[(MAC_NUM-1-i)*8 +: 8]*fc_weight_box[i];
		accumulator = accumulator + {{5{multiplier[i][WEIGHT_WIDTH+DATA_WIDTH-1]}},multiplier[i]};
	end
end

//reset to 0 when 1 output is produced
always@*begin
	if(accumulate_reset)begin
		n_accumulator_sum = accumulator;
	end
	else begin
		n_accumulator_sum = accumulator_sum + accumulator;
	end
end

always@(posedge clk)begin
	if(~srstn)
		accumulator_sum <= 0;
	else
		accumulator_sum <= n_accumulator_sum;
end

//assign accumulator_sum to data_out
assign data_out = {{9{accumulator_sum[22]}},accumulator_sum};
endmodule