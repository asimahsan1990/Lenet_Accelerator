/**
 * Editor : Steven
 * File : quantize.v
 */
module quantize(
input clk,
input srstn,
input fc_state,					//fc_state = 0: fc1, fc_state = 1: fc2
input signed [31:0] unquautized_data,
output reg signed[7:0] quantized_data
);

localparam FC1_STATE = 0, FC2_STATE = 1;

reg signed [31:0] unquautized_round_data;
reg signed [31:0] unquautized_shifted_data;
reg signed [7:0] n_quantized_data;		//connect to the signed result in reg signed form

always@*begin
	case(fc_state)
		FC1_STATE: begin
			unquautized_round_data = unquautized_data + 32;
			unquautized_shifted_data = unquautized_round_data >>>6;
			if(unquautized_shifted_data > 127)
				n_quantized_data = 127;
			else if(unquautized_shifted_data < 0)
				n_quantized_data = 0;
			else
				n_quantized_data = unquautized_shifted_data[7:0];
		end
		FC2_STATE: begin
			unquautized_round_data = unquautized_data + 16;
			unquautized_shifted_data = unquautized_round_data >>>5;
			if(unquautized_shifted_data > 127)
				n_quantized_data = 127;
			else if(unquautized_shifted_data < -128)
				n_quantized_data = -8'd128;
			else
				n_quantized_data = unquautized_shifted_data[7:0];
		end
		default: begin	//same as FC1_STATE
			unquautized_round_data = unquautized_data + 32;	
			unquautized_shifted_data = unquautized_round_data >>>6;
			if(unquautized_shifted_data > 127)
				n_quantized_data = 127;
			else if(unquautized_shifted_data < 0)
				n_quantized_data = 0;
			else
				n_quantized_data = unquautized_round_data[7:0];
		end
	endcase
end

always@(posedge clk)begin
	if(~srstn)
		quantized_data <= 0;
	else
		quantized_data <= n_quantized_data;
end
endmodule