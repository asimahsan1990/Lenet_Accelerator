verify_drc -ignore_density
verify_lvs -ignore_floating_port
source -echo ../pre_layout/design_data/addCoreFiller.tcl
save_mw_cel lenet
save_mw_cel -as 6_corefiller

set_write_stream_options -map_layer       /usr/cadtool/cad/synopsys/SAED32_EDK/tech/milkyway/saed32nm_1p9m_gdsout_mw.map       -child_depth 20 -flatten_via
derive_pg_connection -power_net {VDD} -ground_net {VSS} -power_pin {VDD} -ground_pin {VSS} -create_ports top
verify_lvs -ignore_floating_port

set_write_stream_options -map_layer       /usr/cadtool/cad/synopsys/SAED32_EDK/tech/milkyway/saed32nm_1p9m_gdsout_mw.map       -child_depth 20 -flatten_via

write_stream -format gds -lib_name /home/m103/m103061112/Desktop/ICLAB/Final_Project/Lenet_Accelerator/icc_oneset/icc_run/lenet -cells {6_corefiller } ../post_layout/lenet.gds

write_verilog -diode_ports -wire_declaration           -keep_backslash_before_hiersep  -no_physical_only_cells           -supply_statement none           ../post_layout/lenet_layout.v

write_sdf -version 1.0 -context verilog ../post_layout/lenet_layout.sdf

write_sdc ../post_layout/lenet_layout.sdc -version 1.9

extract_rc
write_parasitics -output ../post_layout/lenet_layout -format SPEF -compress