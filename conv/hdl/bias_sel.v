module bias_sel(
input clk,
input srstn,
input [1:0] mode,
input load_conv1_bias_enable,
input load_conv2_bias0_enable,
input load_conv2_bias1_enable,
input [16:0] conv1_bias_set,
input [7:0] set,
input [99:0] sram_rdata_weight,
input [16:0] sram_raddr_weight,
output reg signed [3:0] bias_data
);

localparam IDLE = 0, CONV1 = 1, CONV2 = 2, DONE = 3;

reg signed [3:0] n_bias_data;
reg [99:0] delay_weight;
reg signed [3:0] conv_weight_box[0:49];
reg signed [3:0] n_conv_weight_box[0:49];
integer i,j;

always@(posedge clk) begin
    if(~srstn) begin
        bias_data <= 0;
        for(j = 0;j < 50; j = j + 1) conv_weight_box[j] <= 0;
        delay_weight <= 0;
    end
    else begin
        bias_data <= n_bias_data;
        for(j = 0;j < 50; j = j + 1) conv_weight_box[j] <= n_conv_weight_box[j];
        delay_weight <= sram_rdata_weight;
    end
end


always@* begin
    if (mode == CONV1) begin
        if(load_conv1_bias_enable) begin
            for(j = 0;j < 50; j = j + 1) begin
                if (j<25) n_conv_weight_box[j] = delay_weight[(24-j)*4 +: 4];
                /*****/
                //if (j<25) n_conv_weight_box[j] = sram_rdata_weight[(24-j)*4 +: 4];
                /*****/
                else n_conv_weight_box[j] = conv_weight_box[j];
            end
            n_bias_data = 0;
        end
        else begin
            for(j = 0;j < 50; j = j + 1) n_conv_weight_box[j] = conv_weight_box[j];
            //n_bias_data = conv_weight_box[sram_raddr_weight];
            n_bias_data = conv_weight_box[conv1_bias_set];
        end
    end
    else if(mode == CONV2) begin
        if(load_conv2_bias0_enable) begin
            for(j = 0;j < 50; j = j + 1) begin
                if (j<25) n_conv_weight_box[j] = delay_weight[(24-j)*4 +: 4];
                /*****/
                //if (j<25) n_conv_weight_box[j] = sram_rdata_weight[(24-j)*4 +: 4];
                /*****/
                else n_conv_weight_box[j] = conv_weight_box[j];
            end
            n_bias_data = 0;
        end
        else if (load_conv2_bias1_enable) begin
            for(j = 0;j < 50; j = j + 1) begin 
                if (j<25) n_conv_weight_box[j] = conv_weight_box[j];
                else n_conv_weight_box[j] = delay_weight[(49-j)*4 +: 4];
                /*****/
                //else n_conv_weight_box[j] = sram_rdata_weight[(49-j)*4 +: 4];
                /*****/
            end
            n_bias_data = 0;
        end
        else begin
            for(j = 0;j < 50; j = j + 1) n_conv_weight_box[j] = conv_weight_box[j];
            n_bias_data = conv_weight_box[set];
        end
    end
    else begin
        for(j = 0;j < 50; j = j + 1) n_conv_weight_box[j] = conv_weight_box[j];
        n_bias_data = bias_data;
    end
end

endmodule