# Pipeline processor RISC-V RV32I 
# author: Gontsova Aleksandra

transcript on
vlib work

vlog -reportprogress 300 -work work alu.sv
vlog -reportprogress 300 -work work controlUnit.sv
vlog -reportprogress 300 -work work hazardUnit.sv
vlog -reportprogress 300 -work work instrDec.sv
vlog -reportprogress 300 -work work loadmemExt.sv
vlog -reportprogress 300 -work work mem.sv
vlog -reportprogress 300 -work work muxes.sv
vlog -reportprogress 300 -work work notArchMuxes.sv
vlog -reportprogress 300 -work work stageControlRegisters.sv
vlog -reportprogress 300 -work work stageRegisters.sv
vlog -reportprogress 300 -work work pc.sv
vlog -reportprogress 300 -work work top.sv
vlog -reportprogress 300 -work work tb_mini.sv

vsim work.tb_mini

add wave -position end  sim:/tb_mini/clk
add wave -position end  sim:/tb_mini/reset
add wave -position end  sim:/tb_mini/cnt

add wave -group "Stage Fetch" -radix Unsigned sim:/tb_mini/dut/pcPlus4 sim:/tb_mini/dut/pcOut 
add wave -group "Stage Fetch" sim:/tb_mini/dut/instr

add wave -group "Stage Decode" -radix unsigned sim:/tb_mini/dut/pcPlus4_D sim:/tb_mini/dut/pc_D 
add wave -group "Stage Decode" -radix hexadecimal sim:/tb_mini/dut/instr_D
add wave -group "Stage Decode" -radix unsigned sim:/tb_mini/dut/instrOpcode 
add wave -group "Stage Decode" -radix decimal sim:/tb_mini/dut/rd1 sim:/tb_mini/dut/rd2 
add wave -group "Stage Decode" sim:/tb_mini/dut/rd 
add wave -group "Stage Decode" -radix decimal sim:/tb_mini/dut/immISU sim:/tb_mini/dut/immBranch 
add wave -group "Stage Decode" -color "Medium Violet Red" sim:/tb_mini/dut/aluSrcA sim:/tb_mini/dut/aluSrcB

add wave -group "Stage Execute" -radix unsigned sim:/tb_mini/dut/pcPlus4_E sim:/tb_mini/dut/pc_E 
add wave -group "Stage Execute" -radix decimal sim:/tb_mini/dut/srcA sim:/tb_mini/dut/srcB sim:/tb_mini/dut/aluResult sim:/tb_mini/dut/pcBranch 
add wave -group "Stage Execute" -color "Medium Violet Red" sim:/tb_mini/dut/aluSrcA_E sim:/tb_mini/dut/aluSrcB_E sim:/tb_mini/dut/pcSrc

add wave -group "Stage Memory" -radix unsigned sim:/tb_mini/dut/pcPlus4_M 
add wave -group "Stage Memory" -radix decimal sim:/tb_mini/dut/aluResult_M 
add wave -group "Stage Memory" sim:/tb_mini/dut/rd_M 
add wave -group "Stage Memory" -radix decimal sim:/tb_mini/dut/writeData_M sim:/tb_mini/dut/data

add wave -group "Stage WriteBack" -radix unsigned sim:/tb_mini/dut/pcPlus4_W 
add wave -group "Stage WriteBack" -radix decimal sim:/tb_mini/dut/aluResult_W sim:/tb_mini/dut/data_W sim:/tb_mini/dut/inst_regFile/RF[5] sim:/tb_mini/dut/inst_regFile/RF[6] sim:/tb_mini/dut/inst_regFile/RF[7] 
add wave -group "Stage WriteBack" sim:/tb_mini/dut/rd_W 
add wave -group "Stage WriteBack" -radix decimal sim:/tb_mini/dut/wd 

add wave -group "Stage Execute" -color "Yellow" sim:/tb_mini/dut/forwardA_E sim:/tb_mini/dut/forwardB_E
add wave -group "Stage Execute" -color "Yellow" sim:/tb_mini/dut/flush_E
add wave -group "Stage Fetch" -color "Yellow" sim:/tb_mini/dut/stall_F
add wave -group "Stage Decode" -color "Yellow" sim:/tb_mini/dut/stall_D sim:/tb_mini/dut/flush_D

add wave -group "Stage Memory" sim:/tb_mini/dut/inst_dataMemory/RAM[4]
add wave -group "Stage Memory" sim:/tb_mini/dut/inst_dataMemory/RAM[5]
add wave -group "Stage Memory" sim:/tb_mini/dut/inst_dataMemory/RAM[6]
add wave -group "Stage Memory" sim:/tb_mini/dut/inst_dataMemory/RAM[7]

run -all
