module CHIP ( clk, srstn, conv_start, conv_done, mem_sel, fc1_done, fc2_done,
            /* SRAM A */ 
              sram_rdata_a0, 
              sram_rdata_a1, 
              sram_rdata_a2, 
              sram_rdata_a3, 
              sram_rdata_a4, 
              sram_rdata_a5, 
              sram_rdata_a6, 
              sram_rdata_a7,
              sram_rdata_a8,  
              
              sram_raddr_a0,
              sram_raddr_a1,
              sram_raddr_a2,
              sram_raddr_a3,
              sram_raddr_a4,
              sram_raddr_a5,
              sram_raddr_a6,
              sram_raddr_a7,
              sram_raddr_a8,

            /* SRAM B */
              sram_rdata_b0, 
              sram_rdata_b1, 
              sram_rdata_b2, 
              sram_rdata_b3, 
              sram_rdata_b4, 
              sram_rdata_b5, 
              sram_rdata_b6, 
              sram_rdata_b7,
              sram_rdata_b8,
              
              sram_raddr_b0,
              sram_raddr_b1,
              sram_raddr_b2,
              sram_raddr_b3,
              sram_raddr_b4,
              sram_raddr_b5,
              sram_raddr_b6,
              sram_raddr_b7,
              sram_raddr_b8,

              sram_write_enable_b0,
              sram_write_enable_b1,
              sram_write_enable_b2,
              sram_write_enable_b3,
              sram_write_enable_b4,
              sram_write_enable_b5,
              sram_write_enable_b6,
              sram_write_enable_b7,
              sram_write_enable_b8,

              sram_bytemask_b,
              sram_waddr_b,
              sram_wdata_b,

            /* SRAM C */
              sram_rdata_c0,
              sram_rdata_c1,
              sram_rdata_c2,
              sram_rdata_c3,
              sram_rdata_c4,

              sram_raddr_c0,
              sram_raddr_c1,
              sram_raddr_c2,
              sram_raddr_c3,
              sram_raddr_c4,

              sram_write_enable_c0,
              sram_write_enable_c1,
              sram_write_enable_c2,
              sram_write_enable_c3,
              sram_write_enable_c4,

              sram_bytemask_c,
              sram_waddr_c,
              sram_wdata_c,
            /* SRAM D */
              sram_rdata_d0,
              sram_rdata_d1,
              sram_rdata_d2,
              sram_rdata_d3,
              sram_rdata_d4,

              sram_raddr_d0,
              sram_raddr_d1,
              sram_raddr_d2,
              sram_raddr_d3,
              sram_raddr_d4,

              sram_write_enable_d0,
              sram_write_enable_d1,
              sram_write_enable_d2,
              sram_write_enable_d3,
              sram_write_enable_d4,

              sram_bytemask_d,
              sram_waddr_d,
              sram_wdata_d,

            /* SRAM E */
              sram_rdata_e0,
              sram_rdata_e1,
              sram_rdata_e2,
              sram_rdata_e3,
              sram_rdata_e4,

              sram_raddr_e0,
              sram_raddr_e1,
              sram_raddr_e2,
              sram_raddr_e3,
              sram_raddr_e4,

              sram_write_enable_e0,
              sram_write_enable_e1,
              sram_write_enable_e2,
              sram_write_enable_e3,
              sram_write_enable_e4,

              sram_bytemask_e,
              sram_waddr_e,
              sram_wdata_e,

            /* SRAM F */
              sram_bytemask_f,
              sram_waddr_f,
              sram_wdata_f,
              sram_write_enable_f,
            /* CONV Weight & Bias SRAM */
              conv_sram_raddr_weight,
              conv_sram_rdata_weight,
            /* FC Weight & Bias SRAM */
              fc_sram_raddr_weight,
              fc_sram_rdata_weight
              );
  input clk, srstn, conv_start;
  output conv_done, mem_sel, fc1_done, fc2_done;
/* SRAM A */
  input [31:0] sram_rdata_a0;
  input [31:0] sram_rdata_a1;
  input [31:0] sram_rdata_a2;
  input [31:0] sram_rdata_a3;
  input [31:0] sram_rdata_a4;
  input [31:0] sram_rdata_a5;
  input [31:0] sram_rdata_a6;
  input [31:0] sram_rdata_a7;
  input [31:0] sram_rdata_a8;

  output [9:0] sram_raddr_a0;
  output [9:0] sram_raddr_a1;
  output [9:0] sram_raddr_a2;
  output [9:0] sram_raddr_a3;
  output [9:0] sram_raddr_a4;
  output [9:0] sram_raddr_a5;
  output [9:0] sram_raddr_a6;
  output [9:0] sram_raddr_a7;
  output [9:0] sram_raddr_a8;
  /* SRAM B */
  input [31:0] sram_rdata_b0;
  input [31:0] sram_rdata_b1;
  input [31:0] sram_rdata_b2;
  input [31:0] sram_rdata_b3;
  input [31:0] sram_rdata_b4;
  input [31:0] sram_rdata_b5;
  input [31:0] sram_rdata_b6;
  input [31:0] sram_rdata_b7;
  input [31:0] sram_rdata_b8;
  
  output [9:0] sram_raddr_b0;
  output [9:0] sram_raddr_b1;
  output [9:0] sram_raddr_b2;
  output [9:0] sram_raddr_b3;
  output [9:0] sram_raddr_b4;
  output [9:0] sram_raddr_b5;
  output [9:0] sram_raddr_b6;
  output [9:0] sram_raddr_b7;
  output [9:0] sram_raddr_b8;

  output sram_write_enable_b0;
  output sram_write_enable_b1;
  output sram_write_enable_b2;
  output sram_write_enable_b3;
  output sram_write_enable_b4;
  output sram_write_enable_b5;
  output sram_write_enable_b6;
  output sram_write_enable_b7;
  output sram_write_enable_b8;

  output [3:0] sram_bytemask_b;
  output [9:0] sram_waddr_b;
  output [7:0] sram_wdata_b;
/* SRAM C */
  input [31:0] sram_rdata_c0;
  input [31:0] sram_rdata_c1;
  input [31:0] sram_rdata_c2;
  input [31:0] sram_rdata_c3;
  input [31:0] sram_rdata_c4;

  output [5:0] sram_raddr_c0;
  output [5:0] sram_raddr_c1;
  output [5:0] sram_raddr_c2;
  output [5:0] sram_raddr_c3;
  output [5:0] sram_raddr_c4;

  output [3:0] sram_bytemask_c;
  output [9:0] sram_waddr_c;
  output [7:0] sram_wdata_c;

/* SRAM D */
  input [31:0] sram_rdata_d0;
  input [31:0] sram_rdata_d1;
  input [31:0] sram_rdata_d2;
  input [31:0] sram_rdata_d3;
  input [31:0] sram_rdata_d4;

  output [5:0] sram_raddr_d0;
  output [5:0] sram_raddr_d1;
  output [5:0] sram_raddr_d2;
  output [5:0] sram_raddr_d3;
  output [5:0] sram_raddr_d4;

  output sram_write_enable_d0;
  output sram_write_enable_d1;
  output sram_write_enable_d2;
  output sram_write_enable_d3;
  output sram_write_enable_d4;

  output [3:0] sram_bytemask_d;
  output [9:0] sram_waddr_d;
  output [7:0] sram_wdata_d;

  /* SRAM E */
  input [31:0] sram_rdata_e0;
  input [31:0] sram_rdata_e1;
  input [31:0] sram_rdata_e2;
  input [31:0] sram_rdata_e3;
  input [31:0] sram_rdata_e4;

  output [4:0] sram_raddr_e0;
  output [4:0] sram_raddr_e1;
  output [4:0] sram_raddr_e2;
  output [4:0] sram_raddr_e3;
  output [4:0] sram_raddr_e4;

  output [3:0] sram_bytemask_e;
  output [4:0] sram_waddr_e;
  output [7:0] sram_wdata_e;
  /* SRAM F */ 
  output [7:0] sram_wdata_f;
  output [3:0] sram_bytemask_f;
  output [1:0] sram_waddr_f;
  output sram_write_enable_f;
/* CONV w_b SRAM */
  input [99:0] conv_sram_rdata_weight;
  output [16:0] conv_sram_raddr_weight;
/* FC w_b SRAM */
  input [79:0] fc_sram_rdata_weight;
  output [14:0] fc_sram_raddr_weight;

lenet_2set
U0 (
  .clk(clk),
  .srstn(srstn),
/* CONTROL SIGNALS */
  .conv_start(conv_start),
  .conv_done(conv_done),
  .mem_sel(mem_sel),
  .fc1_done(fc1_done),
  .fc2_done(fc2_done),
/* SRAM A */
  .sram_rdata_a0(sram_rdata_a0),
  .sram_rdata_a1(sram_rdata_a1),
  .sram_rdata_a2(sram_rdata_a2),
  .sram_rdata_a3(sram_rdata_a3),
  .sram_rdata_a4(sram_rdata_a4),
  .sram_rdata_a5(sram_rdata_a5),
  .sram_rdata_a6(sram_rdata_a6),
  .sram_rdata_a7(sram_rdata_a7),
  .sram_rdata_a8(sram_rdata_a8),

  .sram_raddr_a0(sram_raddr_a0),
  .sram_raddr_a1(sram_raddr_a1),
  .sram_raddr_a2(sram_raddr_a2),
  .sram_raddr_a3(sram_raddr_a3),
  .sram_raddr_a4(sram_raddr_a4),
  .sram_raddr_a5(sram_raddr_a5),
  .sram_raddr_a6(sram_raddr_a6),
  .sram_raddr_a7(sram_raddr_a7),
  .sram_raddr_a8(sram_raddr_a8),
/* SRAM B */
  .sram_rdata_b0(sram_rdata_b0),
  .sram_rdata_b1(sram_rdata_b1),
  .sram_rdata_b2(sram_rdata_b2),
  .sram_rdata_b3(sram_rdata_b3),
  .sram_rdata_b4(sram_rdata_b4),
  .sram_rdata_b5(sram_rdata_b5),
  .sram_rdata_b6(sram_rdata_b6),
  .sram_rdata_b7(sram_rdata_b7),
  .sram_rdata_b8(sram_rdata_b8),

  .sram_raddr_b0(sram_raddr_b0),
  .sram_raddr_b1(sram_raddr_b1),
  .sram_raddr_b2(sram_raddr_b2),
  .sram_raddr_b3(sram_raddr_b3),
  .sram_raddr_b4(sram_raddr_b4),
  .sram_raddr_b5(sram_raddr_b5),
  .sram_raddr_b6(sram_raddr_b6),
  .sram_raddr_b7(sram_raddr_b7),
  .sram_raddr_b8(sram_raddr_b8),

  .sram_write_enable_b0(sram_write_enable_b0),
  .sram_write_enable_b1(sram_write_enable_b1),
  .sram_write_enable_b2(sram_write_enable_b2),
  .sram_write_enable_b3(sram_write_enable_b3),
  .sram_write_enable_b4(sram_write_enable_b4),
  .sram_write_enable_b5(sram_write_enable_b5),
  .sram_write_enable_b6(sram_write_enable_b6),
  .sram_write_enable_b7(sram_write_enable_b7),
  .sram_write_enable_b8(sram_write_enable_b8),

  .sram_bytemask_b(sram_bytemask_b),
  .sram_waddr_b(sram_waddr_b),
  .sram_wdata_b(sram_wdata_b),
/* SRAM C */
  .sram_rdata_c0(sram_rdata_c0),
  .sram_rdata_c1(sram_rdata_c1),
  .sram_rdata_c2(sram_rdata_c2),
  .sram_rdata_c3(sram_rdata_c3),
  .sram_rdata_c4(sram_rdata_c4),

  .sram_raddr_c0(sram_raddr_c0),
  .sram_raddr_c1(sram_raddr_c1),
  .sram_raddr_c2(sram_raddr_c2),
  .sram_raddr_c3(sram_raddr_c3),
  .sram_raddr_c4(sram_raddr_c4),

  .sram_write_enable_c0(sram_write_enable_c0),
  .sram_write_enable_c1(sram_write_enable_c1),
  .sram_write_enable_c2(sram_write_enable_c2),
  .sram_write_enable_c3(sram_write_enable_c3),
  .sram_write_enable_c4(sram_write_enable_c4),

  .sram_bytemask_c(sram_bytemask_c),
  .sram_waddr_c(sram_waddr_c),
  .sram_wdata_c(sram_wdata_c),
/* SRAM D */
  .sram_rdata_d0(sram_rdata_d0),
  .sram_rdata_d1(sram_rdata_d1),
  .sram_rdata_d2(sram_rdata_d2),
  .sram_rdata_d3(sram_rdata_d3),
  .sram_rdata_d4(sram_rdata_d4),

  .sram_raddr_d0(sram_raddr_d0),
  .sram_raddr_d1(sram_raddr_d1),
  .sram_raddr_d2(sram_raddr_d2),
  .sram_raddr_d3(sram_raddr_d3),
  .sram_raddr_d4(sram_raddr_d4),

  .sram_write_enable_d0(sram_write_enable_d0),
  .sram_write_enable_d1(sram_write_enable_d1),
  .sram_write_enable_d2(sram_write_enable_d2),
  .sram_write_enable_d3(sram_write_enable_d3),
  .sram_write_enable_d4(sram_write_enable_d4),

  .sram_bytemask_d(sram_bytemask_d),
  .sram_waddr_d(sram_waddr_d),
  .sram_wdata_d(sram_wdata_d),
/* SRAM E */
  .sram_rdata_e0(sram_rdata_e0),
  .sram_rdata_e1(sram_rdata_e1),
  .sram_rdata_e2(sram_rdata_e2),
  .sram_rdata_e3(sram_rdata_e3),
  .sram_rdata_e4(sram_rdata_e4),

  .sram_raddr_e0(sram_raddr_e0),
  .sram_raddr_e1(sram_raddr_e1),
  .sram_raddr_e2(sram_raddr_e2),
  .sram_raddr_e3(sram_raddr_e3),
  .sram_raddr_e4(sram_raddr_e4),

  .sram_write_enable_e0(sram_write_enable_e0),
  .sram_write_enable_e1(sram_write_enable_e1),
  .sram_write_enable_e2(sram_write_enable_e2),
  .sram_write_enable_e3(sram_write_enable_e3),
  .sram_write_enable_e4(sram_write_enable_e4),

  .sram_bytemask_e(sram_bytemask_e),
  .sram_waddr_e(sram_waddr_e),
  .sram_wdata_e(sram_wdata_e),
/* SRAM F */
  .sram_bytemask_f(sram_bytemask_f),
  .sram_waddr_f(sram_waddr_f),
  .sram_wdata_f(sram_wdata_f),
  .sram_write_enable_f(sram_write_enable_f),
/* CONV WEIGHT SRAM */
  .conv_sram_raddr_weight(conv_sram_raddr_weight),
  .conv_sram_rdata_weight(conv_sram_rdata_weight),
/* FC WEIGHT SRAM */
  .fc_sram_raddr_weight(fc_sram_raddr_weight),
  .fc_sram_rdata_weight(fc_sram_rdata_weight)
);
  
endmodule