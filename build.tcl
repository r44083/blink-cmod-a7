set option {
    {projname.arg    "" "name of project"}
    {partname.arg    "" "target partname"}
    {vhdls.arg       "" "repo path"}
    {constraints.arg "" "Constraints files"}
}
array set args [cmdline::getoptions argv $option]

set BUILDDIR ./build

# Step 1: setup design sources and constraints
read_vhdl $args(vhdls)

read_xdc $args(constraints)

# Setep 2: run synthesis, report utilization and timing estimates, write checkpoint design
synth_design -top main -part $args(partname) -flatten rebuilt

write_checkpoint -force $BUILDDIR/post_synth

report_timing_summary -file $BUILDDIR/report/post_synth_timing_summary.rpt
report_power -file $BUILDDIR/report/post_synth_power.rpt
report_io -file $BUILDDIR/report/post_synth_io.rpt

# Step 3: run placement and logic optimization, report utilization and timing estimates
opt_design
power_opt_design

place_design
phys_opt_design

write_checkpoint -force $BUILDDIR/post_place

report_clock_utilization -file $BUILDDIR/report/post_place_clock_utilization.rpt
report_utilization -file $BUILDDIR/report/post_place_utilization.rpt

# Step 4: run router, report actual utilization and timing, write checkpoint design, run DRCs
route_design

write_checkpoint -force $BUILDDIR/post_route

report_timing_summary -file $BUILDDIR/report/post_route_timing_summary.rpt
report_utilization -file $BUILDDIR/report/post_route_utilization.rpt
report_power -file $BUILDDIR/report/post_route_power.rpt
report_methodology -file $BUILDDIR/report/post_route_methodology.rpt
report_drc -file $BUILDDIR/report/post_route_drc.rpt

# *_netlist.v is needed for timing simulation
write_verilog -force $BUILDDIR/$args(projname)_netlist.v -mode timesim -sdf_anno true
write_xdc -no_fixed_only -force $BUILDDIR/$args(projname)_constraints.xdc

# Step 5: generate a bitstream
write_bitstream -force $BUILDDIR/$args(projname)_bitstream.bit
