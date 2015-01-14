proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param gui.test TreeTableDev
  create_project -in_memory -part xc7z020clg484-1
  set_property board_part em.avnet.com:zed:part0:1.0 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir C:/Users/eleve/Desktop/project_final/project_final.cache/wt [current_project]
  set_property parent.project_dir C:/Users/eleve/Desktop/project_final [current_project]
  add_files -quiet C:/Users/eleve/Desktop/project_final/project_final.runs/synth_1/TOP.dcp
  read_xdc C:/Users/eleve/Desktop/project_final/project_final.srcs/constrs_1/new/contraintes.xdc
  link_design -top TOP -part xc7z020clg484-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  catch {update_ip_catalog -quiet -current_ip_cache {c:/Users/eleve/Desktop/project_final/project_final.cache} }
  opt_design 
  write_checkpoint -force TOP_opt.dcp
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  place_design 
  write_checkpoint -force TOP_placed.dcp
  catch { report_io -file TOP_io_placed.rpt }
  catch { report_clock_utilization -file TOP_clock_utilization_placed.rpt }
  catch { report_utilization -file TOP_utilization_placed.rpt -pb TOP_utilization_placed.pb }
  catch { report_control_sets -verbose -file TOP_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force TOP_routed.dcp
  catch { report_drc -file TOP_drc_routed.rpt -pb TOP_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -file TOP_timing_summary_routed.rpt -pb TOP_timing_summary_routed.pb }
  catch { report_power -file TOP_power_routed.rpt -pb TOP_power_summary_routed.pb }
  catch { report_route_status -file TOP_route_status.rpt -pb TOP_route_status.pb }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force TOP.bit 
  if { [file exists C:/Users/eleve/Desktop/project_final/project_final.runs/synth_1/TOP.hwdef] } {
    catch { write_sysdef -hwdef C:/Users/eleve/Desktop/project_final/project_final.runs/synth_1/TOP.hwdef -bitfile TOP.bit -meminfo TOP_bd.bmm -file TOP.sysdef }
  }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

