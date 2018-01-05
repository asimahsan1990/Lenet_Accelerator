//Wrap the synthesized netlist 

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
              //set 2
              sram_rdata_a0_1, 
              sram_rdata_a1_1, 
              sram_rdata_a2_1, 
              sram_rdata_a3_1, 
              sram_rdata_a4_1, 
              sram_rdata_a5_1, 
              sram_rdata_a6_1, 
              sram_rdata_a7_1,
              sram_rdata_a8_1,

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
              //set 2
              sram_rdata_b0_1, 
              sram_rdata_b1_1, 
              sram_rdata_b2_1, 
              sram_rdata_b3_1, 
              sram_rdata_b4_1, 
              sram_rdata_b5_1, 
              sram_rdata_b6_1, 
              sram_rdata_b7_1,
              sram_rdata_b8_1,

              sram_wdata_b_1,

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
              //set 2
              sram_rdata_c0_1,
              sram_rdata_c1_1,
              sram_rdata_c2_1,
              sram_rdata_c3_1,
              sram_rdata_c4_1,
              sram_wdata_c_1,
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
              //set 2
              sram_rdata_d0_1,
              sram_rdata_d1_1,
              sram_rdata_d2_1,
              sram_rdata_d3_1,
              sram_rdata_d4_1,

              sram_wdata_d_1,
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
              //set 2
              sram_rdata_e0_1,
              sram_rdata_e1_1,
              sram_rdata_e2_1,
              sram_rdata_e3_1,
              sram_rdata_e4_1,

              sram_wdata_e_1,
            /* SRAM F */
              sram_bytemask_f,
              sram_waddr_f,
              sram_wdata_f,
              sram_write_enable_f,
              //set 2
              sram_wdata_f_1,
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
  input [31:0] sram_rdata_a0_1;
  input [31:0] sram_rdata_a1_1;
  input [31:0] sram_rdata_a2_1;
  input [31:0] sram_rdata_a3_1;
  input [31:0] sram_rdata_a4_1;
  input [31:0] sram_rdata_a5_1;
  input [31:0] sram_rdata_a6_1;
  input [31:0] sram_rdata_a7_1;
  input [31:0] sram_rdata_a8_1;
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

  input [31:0] sram_rdata_b0_1;
  input [31:0] sram_rdata_b1_1;
  input [31:0] sram_rdata_b2_1;
  input [31:0] sram_rdata_b3_1;
  input [31:0] sram_rdata_b4_1;
  input [31:0] sram_rdata_b5_1;
  input [31:0] sram_rdata_b6_1;
  input [31:0] sram_rdata_b7_1;
  input [31:0] sram_rdata_b8_1;

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

  input [31:0] sram_rdata_c0_1;
  input [31:0] sram_rdata_c1_1;
  input [31:0] sram_rdata_c2_1;
  input [31:0] sram_rdata_c3_1;
  input [31:0] sram_rdata_c4_1;

  output sram_write_enable_c0;
  output sram_write_enable_c1;
  output sram_write_enable_c2;
  output sram_write_enable_c3;
  output sram_write_enable_c4;

  output [3:0] sram_bytemask_c;
  output [9:0] sram_waddr_c;
  output [7:0] sram_wdata_c;

/* SRAM D */
  input [31:0] sram_rdata_d0;
  input [31:0] sram_rdata_d1;
  input [31:0] sram_rdata_d2;
  input [31:0] sram_rdata_d3;
  input [31:0] sram_rdata_d4;

  input [5:0] sram_raddr_d0;
  input [5:0] sram_raddr_d1;
  input [5:0] sram_raddr_d2;
  input [5:0] sram_raddr_d3;
  input [5:0] sram_raddr_d4;

  input [31:0] sram_rdata_d0_1;
  input [31:0] sram_rdata_d1_1;
  input [31:0] sram_rdata_d2_1;
  input [31:0] sram_rdata_d3_1;
  input [31:0] sram_rdata_d4_1;

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

  input [31:0] sram_rdata_e0_1;
  input [31:0] sram_rdata_e1_1;
  input [31:0] sram_rdata_e2_1;
  input [31:0] sram_rdata_e3_1;
  input [31:0] sram_rdata_e4_1;

  output sram_write_enable_e0;
  output sram_write_enable_e1;
  output sram_write_enable_e2;
  output sram_write_enable_e3;
  output sram_write_enable_e4;

  output [3:0] sram_bytemask_e;
  output [9:0] sram_waddr_e;
  output [7:0] sram_wdata_e;
/* SRAM F */ 
  output [7:0] sram_wdata_f;
  output [7:0] sram_wdata_f_1;
  output [3:0] sram_bytemask_f;
  output [1:0] sram_waddr_f;
  output sram_write_enable_f;
/* CONV w_b SRAM */
  input [99:0] conv_sram_rdata_weight;
  output [16:0] conv_sram_raddr_weight;
/* FC w_b SRAM */
  input [79:0] fc_sram_rdata_weight;
  output [14:0] fc_sram_raddr_weight;




  lenet_2set U0(.clk(clk), .rst_n(rst_n), .boot_up(boot_up), 
              .boot_addr(boot_addr), .boot_datai(boot_datai), .boot_web(boot_web), 
              .peri_web(peri_web), .peri_addr(peri_addr), .peri_datao(peri_datao));
  
endmodule
