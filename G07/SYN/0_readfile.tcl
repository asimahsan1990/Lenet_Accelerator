set TOP_DIR $TOPLEVEL
set RPT_DIR report
set NET_DIR netlist

sh rm -rf ./$TOP_DIR
sh rm -rf ./$RPT_DIR
sh rm -rf ./$NET_DIR
sh mkdir ./$TOP_DIR
sh mkdir ./$RPT_DIR
sh mkdir ./$NET_DIR

# define a lib path here
define_design_lib $TOPLEVEL -path ./$TOPLEVEL

# Read Design File (add your files here)
set HDL_DIR "../hdl"
analyze -library $TOPLEVEL -format verilog "$HDL_DIR/lenet_2set.v \
											$HDL_DIR/lenet.v \
											$HDL_DIR/conv_hdl/conv_top.v \
											$HDL_DIR/conv_hdl/conv_control.v \
											$HDL_DIR/conv_hdl/data_reg.v \
											$HDL_DIR/conv_hdl/fsm.v \
											$HDL_DIR/conv_hdl/multiply_compare.v \
											$HDL_DIR/conv_hdl/quantize.v \
											$HDL_DIR/conv_hdl/bias_sel.v \
											$HDL_DIR/fc_hdl/fc_top.v \
											$HDL_DIR/fc_hdl/fc_controller.v \
											$HDL_DIR/fc_hdl/fc_data_reg.v \
											$HDL_DIR/fc_hdl/fc_multiplier_accumulator.v \
											$HDL_DIR/fc_hdl/fc_quantize.v
											"
                                             

# elaborate your design
elaborate $TOPLEVEL -architecture verilog -library $TOPLEVEL

# Solve Multiple Instance
set uniquify_naming_style "%s_mydesign_%d"
uniquify

# link the design
current_design $TOPLEVEL
link
