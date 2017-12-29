module quantize(
input clk,
input srstn,
input signed [3:0] bias_data,
input signed [31:0] ori_data,
input [1:0] mode,
output reg [7:0] quantized_data
);

localparam IDLE = 0, CONV1 = 1, CONV2 = 2, DONE = 3;

localparam WEIGHT_BW = 4;
localparam CONV1_WEIGHT_FL = 3,CONV2_WEIGHT_FL = 5, FC1_WEIGHT_FL = 6,SCORE_WEIGHT_FL = 4;

localparam max_val = 127,min_val = -128;
localparam DATA_BW = 8;
localparam CONV1_DATA_IN_FL = 8,CONV1_DATA_OUT_FL = 5;
localparam CONV2_DATA_IN_FL = 5,CONV2_DATA_OUT_FL = 4;
localparam FC1_DATA_IN_FL = 4, FC1_DATA_OUT_FL = 4;
localparam SCORE_DATA_IN_FL = 4, SCORE_DATA_OUT_FL = 3;

reg signed [31:0] bias_extend;
reg signed [31:0] ori_round_data;
reg signed [31:0] ori_shifted_data;
reg [7:0] n_quantized_data;

//quantize the data form 32 bit to 8 bit
always@* begin
	if (mode == CONV2) begin
	    bias_extend = {{28{bias_data[3]}},bias_data} <<< CONV2_DATA_IN_FL;
	    ori_round_data = ori_data + bias_extend + (1 << (CONV2_WEIGHT_FL+CONV2_DATA_IN_FL-1-CONV2_DATA_OUT_FL));
	    ori_shifted_data = ori_round_data >>> (CONV2_WEIGHT_FL+CONV2_DATA_IN_FL-CONV2_DATA_OUT_FL);
	    if(ori_shifted_data >= max_val) n_quantized_data = max_val;
	    else if(ori_shifted_data <= min_val) n_quantized_data = min_val;
	    else n_quantized_data = ori_shifted_data[7:0];
	    end
    else begin
    	bias_extend = {{28{bias_data[3]}},bias_data} <<< CONV1_DATA_IN_FL;
    	ori_round_data = ori_data + bias_extend + (1 << (CONV1_WEIGHT_FL+CONV1_DATA_IN_FL-1-CONV1_DATA_OUT_FL));
    	ori_shifted_data = ori_round_data >>> (CONV1_WEIGHT_FL+CONV1_DATA_IN_FL-CONV1_DATA_OUT_FL);
    	if(ori_shifted_data >= max_val) n_quantized_data = max_val;
    	else if(ori_shifted_data <= min_val) n_quantized_data = min_val;
    	else n_quantized_data = ori_shifted_data[7:0];
    end
end

always@(posedge clk) begin
	if(~srstn) begin
		quantized_data <= 0;
	end
	else begin
		quantized_data <= n_quantized_data;
	end
end

endmodule