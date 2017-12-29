module multiply_compare(
    input clk,
    input srstn,
    input [1:0] mode,
    input [4:0] channel,
    input [99:0] conv1_sram_rdata_weight,
    input [99:0] conv2_sram_rdata_weight,
    input [36*8-1:0] src_window,
    output signed [31:0] data_out
);

localparam IDLE = 0, CONV1 = 1, CONV2 = 2, DONE = 3;

localparam WEIGHT_WIDTH = 4;
localparam WEIGHT_NUM = 25;                 // 5x5
localparam DATA_WIDTH = 8;
localparam DATA_NUM_PER_PIXEL = 4;

// data width 8 +   weight width 4 = 12
reg signed [WEIGHT_WIDTH+DATA_WIDTH-1:0] conv_mul_result_a [0:WEIGHT_NUM-1];
reg signed [WEIGHT_WIDTH+DATA_WIDTH-1:0] conv_mul_result_b [0:WEIGHT_NUM-1];
reg signed [WEIGHT_WIDTH+DATA_WIDTH-1:0] conv_mul_result_c [0:WEIGHT_NUM-1];
reg signed [WEIGHT_WIDTH+DATA_WIDTH-1:0] conv_mul_result_d [0:WEIGHT_NUM-1];

reg signed [DATA_WIDTH-1:0] conv_src_a [0:WEIGHT_NUM-1];
reg signed [DATA_WIDTH-1:0] conv_src_b [0:WEIGHT_NUM-1];
reg signed [DATA_WIDTH-1:0] conv_src_c [0:WEIGHT_NUM-1];
reg signed [DATA_WIDTH-1:0] conv_src_d [0:WEIGHT_NUM-1];

reg signed [WEIGHT_WIDTH-1:0] conv_weight_box [0:WEIGHT_NUM-1];

// The four neighbor for pooling
reg signed [31:0] conv_sum_a;
reg signed [31:0] conv_sum_b;
reg signed [31:0] conv_sum_c;
reg signed [31:0] conv_sum_d;

reg signed [31:0] conv2_sum_a, n_conv2_sum_a;
reg signed [31:0] conv2_sum_b, n_conv2_sum_b;
reg signed [31:0] conv2_sum_c, n_conv2_sum_c;
reg signed [31:0] conv2_sum_d, n_conv2_sum_d;

wire signed [31:0] tmp_big1;
wire signed [31:0] tmp_big2;

// Pooling: Find the maximum from four values
assign tmp_big1 = (conv2_sum_a >= conv2_sum_b)? conv2_sum_a : conv2_sum_b;
assign tmp_big2 = (conv2_sum_c >= conv2_sum_d)? conv2_sum_c : conv2_sum_d;
assign data_out = (tmp_big1 >= tmp_big2)? tmp_big1 : tmp_big2;

reg [31:0] i,k;


always@* begin
    conv_sum_a = 0;
    conv_sum_b = 0;
    conv_sum_c = 0;
    conv_sum_d = 0;
    for(i = 0; i < 5; i = i + 1) begin
        conv_src_a[i] = src_window[(35-i)*8 +: 8];
        conv_src_b[i] = src_window[(35-(i+1))*8 +: 8];
        conv_src_c[i] = src_window[(35-(i+6))*8 +: 8];
        conv_src_d[i] = src_window[(35-(i+7))*8 +: 8];
    end
    for(i = 5; i < 10; i = i + 1) begin
        conv_src_a[i] = src_window[(35-(i+1))*8 +: 8];
        conv_src_b[i] = src_window[(35-(i+2))*8 +: 8];
        conv_src_c[i] = src_window[(35-(i+7))*8 +: 8];
        conv_src_d[i] = src_window[(35-(i+8))*8 +: 8];
    end
    for(i = 10; i < 15; i = i + 1) begin
        conv_src_a[i] = src_window[(35-(i+2))*8 +: 8];
        conv_src_b[i] = src_window[(35-(i+3))*8 +: 8];
        conv_src_c[i] = src_window[(35-(i+8))*8 +: 8];
        conv_src_d[i] = src_window[(35-(i+9))*8 +: 8];
    end
    for(i = 15; i < 20; i = i + 1) begin
        conv_src_a[i] = src_window[(35-(i+3))*8 +: 8];
        conv_src_b[i] = src_window[(35-(i+4))*8 +: 8];
        conv_src_c[i] = src_window[(35-(i+9))*8 +: 8];
        conv_src_d[i] = src_window[(35-(i+10))*8 +: 8];
    end
    for(i = 20; i < 25; i = i + 1) begin
        conv_src_a[i] = src_window[(35-(i+4))*8 +: 8];
        conv_src_b[i] = src_window[(35-(i+5))*8 +: 8];
        conv_src_c[i] = src_window[(35-(i+10))*8 +: 8];
        conv_src_d[i] = src_window[(35-(i+11))*8 +: 8];
    end
    for (k = 0;k < WEIGHT_NUM; k = k + 1) begin
        if(mode == CONV2) begin
            conv_weight_box[k] = conv2_sram_rdata_weight[(24-k)*4 +: WEIGHT_WIDTH];
        end
        else begin
            conv_weight_box[k] = conv1_sram_rdata_weight[(24-k)*4 +: WEIGHT_WIDTH];
        end
    end

    for(i = 0;i < WEIGHT_NUM; i = i + 1) begin
        conv_mul_result_a[i] = conv_src_a[i] * conv_weight_box[i];
        conv_sum_a = conv_sum_a + {{20{conv_mul_result_a[i][11]}},conv_mul_result_a[i]};
        conv_mul_result_b[i] = conv_src_b[i] * conv_weight_box[i];
        conv_sum_b = conv_sum_b + {{20{conv_mul_result_b[i][11]}},conv_mul_result_b[i]};
        conv_mul_result_c[i] = conv_src_c[i] * conv_weight_box[i];
        conv_sum_c = conv_sum_c + {{20{conv_mul_result_c[i][11]}},conv_mul_result_c[i]};
        conv_mul_result_d[i] = conv_src_d[i] * conv_weight_box[i];
        conv_sum_d = conv_sum_d + {{20{conv_mul_result_d[i][11]}},conv_mul_result_d[i]}; 
    end
end

always@(posedge clk) begin
    if(~srstn) begin
        conv2_sum_a <= 0;
        conv2_sum_b <= 0;
        conv2_sum_c <= 0;
        conv2_sum_d <= 0;
    end
    else begin
        conv2_sum_a <= n_conv2_sum_a;
        conv2_sum_b <= n_conv2_sum_b;
        conv2_sum_c <= n_conv2_sum_c;
        conv2_sum_d <= n_conv2_sum_d;
    end
end

always@* begin
    if (mode == CONV2) begin
        if (channel == 0) begin
            n_conv2_sum_a = conv_sum_a;
            n_conv2_sum_b = conv_sum_b;
            n_conv2_sum_c = conv_sum_c;
            n_conv2_sum_d = conv_sum_d;
        end
        else begin
            n_conv2_sum_a = conv2_sum_a + conv_sum_a;
            n_conv2_sum_b = conv2_sum_b + conv_sum_b;
            n_conv2_sum_c = conv2_sum_c + conv_sum_c;
            n_conv2_sum_d = conv2_sum_d + conv_sum_d;
        end
    end
    else begin
        n_conv2_sum_a = conv_sum_a;
        n_conv2_sum_b = conv_sum_b;
        n_conv2_sum_c = conv_sum_c;
        n_conv2_sum_d = conv_sum_d;
    end
end

endmodule