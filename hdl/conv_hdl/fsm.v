module fsm(
input clk,
input srstn,
input conv_start,
input conv1_done,
input conv_done,

output reg [1:0] mode,
output reg mem_sel 				// 0: c0 ~ c4, 1: d0 ~ d4
);

reg [1:0] n_mode;
reg n_mem_sel;

localparam  IDLE = 0, CONV1 = 1, CONV2 = 2, DONE = 3;

always@(posedge clk) begin
	if (~srstn) begin
		mode <= IDLE;
		mem_sel <= 1;
	end
	else begin
		mode <= n_mode;
		mem_sel <= n_mem_sel;
	end
end

always@* begin
	case(mode)
		IDLE : n_mode = (conv_start)? CONV1 : IDLE;
		CONV1 : n_mode = (conv1_done)? CONV2 : CONV1;
		CONV2 : n_mode = (conv_done)? DONE : CONV2;
		DONE : n_mode = IDLE;
		default : n_mode = IDLE;
	endcase
end

always@* begin
	if(conv_start) begin
		n_mem_sel = ~mem_sel;
	end
	else begin
		n_mem_sel = mem_sel;
	end
end

endmodule