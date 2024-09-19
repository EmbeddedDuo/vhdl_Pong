# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "F:/Studium/VHDL/Modulabschlussprojekt/vhdl_Pong/project_1/project_1.runs/synth_1/pong_top.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

OPTRACE "synth_1" START { ROLLUP_AUTO }
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir F:/Studium/VHDL/Modulabschlussprojekt/vhdl_Pong/project_1/project_1.cache/wt [current_project]
set_property parent.project_path F:/Studium/VHDL/Modulabschlussprojekt/vhdl_Pong/project_1/project_1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo f:/Studium/VHDL/Modulabschlussprojekt/vhdl_Pong/project_1/project_1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_vhdl -library xil_defaultlib {
  F:/Studium/VHDL/BCD_Decoder.vhd
  F:/Studium/VHDL/Rotation_Encoder_Debounced.vhd
  F:/Studium/VHDL/Controller_Interface.vhd
  F:/Studium/VHDL/Seven_Segment_Displays.vhd
  F:/Studium/VHDL/Score_Display.vhd
  F:/Studium/VHDL/Pong_JP/Pong_JP.srcs/sources_1/imports/src/ball_motion/src/ball_motion.vhd
  F:/Studium/VHDL/Pong_JP/Pong_JP.srcs/sources_1/imports/src/clock_enable.vhd
  F:/Studium/VHDL/Pong_JP/Pong_JP.srcs/sources_1/imports/src/clock_enable/src/clock_enable.vhd
  F:/Studium/VHDL/Pong_JP/Pong_JP.srcs/sources_1/imports/src/collision_detection/src/collision_detection.vhd
  F:/Studium/VHDL/Pong_JP/Pong_JP.srcs/sources_1/imports/src/vga_controller/src/vga_controller.vhd
  F:/Studium/VHDL/Pong_JP/Pong_JP.srcs/sources_1/imports/src/pong_toplevel.vhd
}
OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc F:/Studium/VHDL/Pong_JP/Pong_JP.srcs/constrs_1/imports/nexysa7100t.xdc
set_property used_in_implementation false [get_files F:/Studium/VHDL/Pong_JP/Pong_JP.srcs/constrs_1/imports/nexysa7100t.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top pong_top -part xc7a100tcsg324-1
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef pong_top.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
generate_parallel_reports -reports { "report_utilization -file pong_top_utilization_synth.rpt -pb pong_top_utilization_synth.pb"  } 
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }