///////////////////////////

module sram_20000x80b(
input clk,
input csb,  //chip enable
input wsb,  //write enable
input wdata, //write data
input [9:0] waddr, //write address
input [14:0] raddr, //read address

output reg [79:0]rdata //read data
);

localparam WEIGHT_WIDTH = 4;
localparam WEIGHT_PIXEL_NUM = 25;

/*
/////////////////////



/////////////////////
*/
reg [WEIGHT_PIXEL_NUM*WEIGHT_WIDTH-1:0] mem[0:20000];
reg [79:0] _rdata;

always@(posedge clk)
  if(~csb && ~wsb)
    mem[waddr] <= wdata;

always@(posedge clk)
  if(~csb)
    _rdata <= mem[raddr];

always@*
begin
    //rdata = #(`cycle_period*0.2) _rdata;
    rdata =  _rdata;
end


task load_w(
    input integer index,
    input [79:0] weight_input
);
    mem[index] = weight_input;
endtask

task dis();
integer i;
for (i = 21;i < 41 ;i = i + 1 ) begin
  $display("%b",mem[i]);
end

endtask

endmodule