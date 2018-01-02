# Lenet_Accelerator
## Developer: Yun-Chen Lo, Steven Wong, Paul Lai
1. Goal: Write an IC with smallest Cycle Count
2. Folder Description:

#### SIM
##### All Parts have passed nLint, presim, gate_sim
> 1. testtop.v
> 2. testconv.v
> > Remember to set mem_sel 1 for testing c0-c4| mem_sel 0 for testing d0-d4
![alt text](https://i.imgur.com/Nf52u0W.png)
> 3. testfc.v
![alt text](https://i.imgur.com/Kuo0dBu.png)
#### HDL
###### CONV_HDL
> 1. conv_top.v
> 2. bias_sel.v
> 3. conv_control.v
> 4. data_reg.v
> 5. fsm.v
> 6. multiply_compare.v
> 7. quantize.v
###### FC_HDL
> 1. fc_top.v
> 2. fc_controller.v
> 3. fc_data_reg.v
> 4. fc_multiplier_accumulator.v
> 5. fc_quantize.v
#### SYN
> 1. 0_readfile.tcl
> 2. 1_setting.tcl
> 3. 2_compile.tcl
> 4. 3_report.tcl
> 5. synthesis.tcl

#### OPTIMIZATION
> 1. Overlap convolution layer computation time with fully-connected layer computation time.
> 2. Do conv1 with conv2 hardware by folding.
> 3. Design FC hardware with smallest number of MACs, but can cooperate with conv hardware.
> 4. Implement weight reusing(# of loading weight/# of bmp) (optional)