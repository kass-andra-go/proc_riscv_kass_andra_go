//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

module top(
input logic clk,reset
);

logic [31:0] pcIn, pcOut;
logic [31:0] pc_D, pc_E;
logic [31:0] pcPlus4, pcPlus4_D, pcPlus4_E, pcPlus4_M, pcPlus4_W;
logic [31:0] pcBranch;

logic [31:0] instr, instr_D;

logic [6:0] instrOpcode;
logic [2:0] instrFunct3, instrFunct3_E, instrFunct3_M;
logic [6:0] instrFunct7;
logic [4:0] rs1, rs1_E;
logic [4:0] rs2, rs2_E;
logic [4:0] rd, rd_D, rd_E, rd_M, rd_W;

logic [31:0] immU, immI, immB, immS, immJ;
logic [31:0] immISU, immISU_D, immISU_E, immISU_M, immISU_W;
logic [31:0] immBranch, immBranch_E;
logic [31:0] aluResult, aluResult_M, aluResult_W;
logic [31:0] rd1, rd1_E;
logic [31:0] rd2, rd2_E, writeData_M;
logic [31:0] srcA, srcB, wd, readData;
logic [31:0] data, data_W;

//controlUnit
logic [1:0] pcSrc;
logic immSrcBJ;
logic [1:0] immSrcISU;
logic [1:0] wdSrc, wdSrc_E, wdSrc_M, wdSrc_W;
logic aluSrcB, aluSrcB_E;
logic aluSrcA, aluSrcA_E;
logic regWrite, regWrite_E, regWrite_M, regWrite_W;
logic memWrite, memWrite_E, memWrite_M;
logic aluZero, aluSign, aluCarry, aluOverflow;
logic [4:0] aluControl, aluControl_E;
logic branch, branch_E;
logic jump, jump_E;
logic [1:0] j, j_E;

//hazard
logic [31:0] forwRd1_E, forwRd2_E;
logic [1:0] forwardA_E, forwardB_E;
logic stall_F, stall_D, flush_D, flush_E;

//*** Fetch ***
pcCounter inst_pcCounter(.clk (clk), .reset (reset), .enn(stall_F), .pcIn(pcIn), .pc(pcOut));
pcMux inst_pcMux (.pcPlus4 (pcPlus4), .pcBranch (pcBranch), .aluResult(aluResult), .pcSrc(pcSrc), .pc(pcIn));
instrMemory inst_instrMemory(.addr (pcOut), .rd(instr));
pcSum inst_pcSum (.pc(pcOut), .pcPlus4(pcPlus4));

regFetchDecode inst_regFetchDecode(.clk (clk), .reset (reset), .enn(stall_D), .clr(flush_D), .instr(instr), .pc(pcOut), .pcPlus4(pcPlus4), .instr_D(instr_D), .pc_D(pc_D), .pcPlus4_D(pcPlus4_D));

//*** Decode ***
instrDec inst_instrDec(.instr(instr_D) , .instrOpcode (instrOpcode), .instrFunct3(instrFunct3), .instrFunct7(instrFunct7), .rs1(rs1), .rs2(rs2), .rd(rd), .immU(immU), .immI(immI), .immB(immB), .immS(immS), .immJ(immJ));
regFile inst_regFile(.clk(clk), .we3(regWrite_W), .addr1(rs1), .addr2(rs2), .addr3(rd_W), .wd(wd), .rd1(rd1), .rd2(rd2));
pcImmMuxBJ inst_pcImmMuxBJ(.immB(immB), .immJ(immJ), .immSrcBJ(immSrcBJ), .immBranch(immBranch));
pcImmMuxISU inst_pcImmMuxISU(.immI(immI), .immS(immS), .immU(immU), .immSrcISU(immSrcISU), .immISU(immISU));

regDecodeExecute inst_regDecodeExecute(.clk (clk), .reset (reset), .clr(flush_E), .rd1(rd1), .rd2(rd2), .pc_D(pc_D), .rs1 (rs1), .rs2(rs2), .immISU(immISU), .immBranch(immBranch), .pcPlus4_D(pcPlus4_D), .rd_D(rd), .rd1_E(rd1_E), .rd2_E(rd2_E), .pc_E(pc_E), .rs1_E (rs1_E), .rs2_E(rs2_E), .immISU_E(immISU_E), .immBranch_E(immBranch_E), .pcPlus4_E(pcPlus4_E), .rd_E(rd_E));

controlUnit inst_controlUnit(.instrOpcode(instrOpcode), .instrFunct3(instrFunct3), .instrFunct7(instrFunct7), .aluControl(aluControl), .aluSrcA(aluSrcA), .aluSrcB(aluSrcB), .regWrite(regWrite), .wdSrc(wdSrc), .memWrite(memWrite),      .branch(branch), .jump(jump), .j(j), .immSrcBJ(immSrcBJ), .immSrcISU(immSrcISU));

regControlDecodeExecute inst_regControlDecodeExecute(.clk (clk), .reset (reset), .clr(flush_E), .regWrite(regWrite), .wdSrc(wdSrc), .memWrite(memWrite), .instrFunct3(instrFunct3),     .aluSrcA(aluSrcA), .aluSrcB(aluSrcB), .aluControl(aluControl), .branch(branch), .jump(jump), .j(j), .regWrite_E(regWrite_E), .wdSrc_E(wdSrc_E), .memWrite_E(memWrite_E), .instrFunct3_E(instrFunct3_E), .aluSrcA_E(aluSrcA_E), .aluSrcB_E(aluSrcB_E),        .aluControl_E(aluControl_E), .branch_E(branch_E), .jump_E(jump_E), .j_E(j_E) );

//*** Execute ***
forwardingMuxB inst_forwardingMuxB(.rd2_E(rd2_E), .wd(wd), .aluResult_M(aluResult_M), .forwardB_E(forwardB_E), .forwRd2_E(forwRd2_E));
forwardingMuxA inst_forwardingMuxA(.rd1_E(rd1_E), .wd(wd), .aluResult_M(aluResult_M), .forwardA_E(forwardA_E), .forwRd1_E(forwRd1_E));

aluMuxB inst_aluMuxB(.rd2(forwRd2_E), .imm(immISU_E), .aluSrcB(aluSrcB_E), .srcB(srcB));
aluMuxA inst_aluMuxA(.rd1(forwRd1_E), .pc(pc_E), .aluSrcA(aluSrcA_E), .srcA(srcA));
pcBranchSum inst_pcBranchSum(.imm(immBranch_E), .pc(pc_E), .pcBranch(pcBranch));
alu inst_alu(.srcA(srcA), .srcB(srcB), .aluControl(aluControl_E), .aluResult(aluResult), .aluZero(aluZero), .aluNeg(aluSign), .aluCarry(aluCarry), .aluOverflow(aluOverflow));

regExecuteMemory inst_regExecuteMemory(.clk (clk), .reset (reset), .aluResult(aluResult), .writeData(rd2_E), .immISU_E(immISU_E), .pcPlus4_E(pcPlus4_E), .rd_E(rd_E), .aluResult_M(aluResult_M), .writeData_M(writeData_M), .immISU_M(immISU_M), .pcPlus4_M(pcPlus4_M), .rd_M(rd_M));

controlBranch inst_controlBranch(.aluZero(aluZero), .aluSign(aluSign), .aluCarry (aluCarry), .aluOverflow(aluOverflow), .instrFunct3(instrFunct3_E), .branch(branch_E), .jump (jump_E), .j(j_E), .pcSrc(pcSrc));

regControlExecuteMemory inst_regControlExecuteMemory(.clk (clk), .reset (reset), .regWrite_E(regWrite_E), .wdSrc_E(wdSrc_E), .memWrite_E(memWrite_E), .instrFunct3_E(instrFunct3_E), .regWrite_M(regWrite_M), .wdSrc_M(wdSrc_M), .memWrite_M(memWrite_M), .instrFunct3_M(instrFunct3_M));

//*** Memory ***

dataMemory inst_dataMemory(.clk(clk), .dataAddr(aluResult_M), .writeData(writeData_M), .f3(instrFunct3_M), .we(memWrite_M), .readData(readData));
loadExt inst_loadExt(.readData(readData), .loadOp(instrFunct3_M), .data(data));

regMemoryWriteBack inst_regMemoryWriteBack(.clk (clk), .reset (reset), .data(data), .immISU_M(immISU_M), .aluResult_M(aluResult_M),.rd_M(rd_M), .pcPlus4_M(pcPlus4_M), .data_W(data_W), .immISU_W(immISU_W), .aluResult_W(aluResult_W), .rd_W(rd_W), .pcPlus4_W(pcPlus4_W));

regControlMemoryWriteBack inst_regControlMemoryWriteBack(.clk (clk), .reset (reset), .regWrite_M(regWrite_M), .wdSrc_M(wdSrc_M), .regWrite_W(regWrite_W), .wdSrc_W(wdSrc_W));

//*** WriteBack ***

wdMux inst_wdMux (.aluResult(aluResult_W), .immU(immISU_W), .readData(data_W), .pcPlus4(pcPlus4_W), .wdSrc(wdSrc_W), .wd(wd));


hazardUnit inst_hazardUnit(.rs1_D(rs1), .rs2_D(rs2), .rs1_E(rs1_E), .rs2_E(rs2_E), .rd_E(rd_E), .rd_M(rd_M), .rd_W(rd_W), .pcSrc(pcSrc), .wdSrc_E(wdSrc_E), .regWrite_M(regWrite_M), .regWrite_W(regWrite_W), .stall_F(stall_F), .stall_D(stall_D), .flush_D(flush_D), .flush_E(flush_E), .forwardA_E(forwardA_E), .forwardB_E(forwardB_E));

endmodule
