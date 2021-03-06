# 
# Synthesis run script generated by Vivado
# 

  set_param gui.test TreeTableDev
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z020clg484-1
set_property target_language VHDL [current_project]
set_property board_part em.avnet.com:zed:part0:1.0 [current_project]
set_param project.compositeFile.enableAutoGeneration 0
set_property default_lib xil_defaultlib [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/new/state_type_pkg.vhd
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/new/Transmit.vhd
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/new/Receive.vhd
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/new/MUX.vhd
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/new/ClockGenerator.vhd
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/new/Address.vhd
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/new/I2cSystem.vhd
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/imports/new/module_RW.vhd
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/new/get_acc.vhd
  C:/Users/eleve/Desktop/accelero/accelero.srcs/sources_1/new/trial1.vhd
}
read_xdc C:/Users/eleve/Desktop/accelero/accelero.srcs/constrs_1/new/I2C_system.xdc
set_property used_in_implementation false [get_files C:/Users/eleve/Desktop/accelero/accelero.srcs/constrs_1/new/I2C_system.xdc]

set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/eleve/Desktop/accelero/accelero.cache/wt [current_project]
set_property parent.project_dir C:/Users/eleve/Desktop/accelero [current_project]
catch { write_hwdef -file trial1.hwdef }
synth_design -top trial1 -part xc7z020clg484-1
write_checkpoint trial1.dcp
report_utilization -file trial1_utilization_synth.rpt -pb trial1_utilization_synth.pb
