vlog ./testbench/modules/PIPELINE/PIPELINE_tb.v ./rtl/modules/PIPELINE_CONTROL.v
vsim PIPELINE_tb
run -all
exit
