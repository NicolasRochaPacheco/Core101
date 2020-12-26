
# Clears previous signals
gtkwave::/Edit/Highlight_All
gtkwave::/Edit/Cut

# Sets view to whole time
gtkwave::setFromEntry gtkwave::getMinTime
gtkwave::setToEntry gtkwave::getMaxTime
gtkwave::/Time/Zoom/Zoom_Best_Fit

# Adds clock and reset signals
set clock_reset [list Core101_top.clock_in Core101_top.reset_in]
gtkwave::addSignalsFromList $clock_reset

# Adds a white space for separation
gtkwave::/Edit/Insert_Blank

# Adds PC from pipeline registers
set pipeline [list pc_if_pipeline_reg.reg_data_out\[31:0\] if_dec_pipeline_reg.reg_data_out\[31:0\] dec_reg_pipeline_reg.reg_data_out\[31:0\] reg_ex_pipeline_reg.reg_data_out\[31:0\] ex_wb_pipeline_reg.reg_data_out\[31:0\]]
gtkwave::addSignalsFromList $pipeline

# Adds a white space for separation
gtkwave::/Edit/Insert_Blank

# Adds registers
set regs [list x00.data_out x01.data_out x02.data_out x03.data_out x04.data_out x05.data_out x06.data_out x07.data_out x08.data_out x09.data_out x10.data_out x11.data_out x12.data_out x13.data_out x14.data_out x15.data_out x16.data_out x17.data_out]
gtkwave::addSignalsFromList $regs

# Adds a white space for separation
gtkwave::/Edit/Insert_Blank

# Adds program counter calculation signals
set pc_calc [list pc_calc.pc_calc_prediction_en_in pc_calc.pc_calc_correction_en_in pc_calc.pc_calc_prediction_in pc_calc.pc_calc_correction_in pc_calc.pc_calc_pred_out pc_calc.pc_calc_addr_out]
gtkwave::addSignalsFromList $pc_calc

# Adds a white space for separation
gtkwave::/Edit/Insert_Blank

# Adds predictor prediction interface signals
set predictor_pred [list predictor0.predictor_pred_addr_in predictor0.predictor_pred_enable_out predictor0.predictor_pred_addr_out]
gtkwave::addSignalsFromList $predictor_pred

# Adds a white space for separation
gtkwave::/Edit/Insert_Blank

# Adds branch resolver
set bru_in [list bru0.bru_enable_in bru0.bru_pc_in bru0.bru_prediction_in bru0.bru_uop_in bru0.bru_rs1_in bru0.bru_rs2_in]
gtkwave::addSignalsFromList $bru_in
set bru_out [list bru0.bru_correction_out bru0.bru_target_out bru0.bru_feedback_result_out bru0.bru_feedback_write_en_out]
gtkwave::addSignalsFromList $bru_out

# Adds a white space for separation
gtkwave::/Edit/Insert_Blank

# Adds LSU
set lsu_in [list lsu0.lsu_enable_in lsu0.lsu_uop_in]
gtkwave::addSignalsFromList $lsu_in
set lsu_out [list lsu0.lsu_mem_data_out lsu0.lsu_mem_addr_out]
gtkwave::addSignalsFromList $lsu_out
