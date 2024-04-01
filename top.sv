//`include "top.vh"

module top(
input logic clk,reset
);
logic [1:0] pcSrc;
logic [31:0] pcIn, pcOut, pcOutShift;
logic [31:0] pcPlus4, pcBranch, pc;

logic [31:0] instr;
logic [6:0] instrOpcode;
logic [2:0] instrFunct3;
logic [6:0] instrFunct7;
logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic [31:0] immU;
logic [31:0] immI;
logic [31:0] immB;
logic [31:0] immS;
logic [31:0] immJ;
logic [31:0] immBranch;
logic immSrc;

logic [31:0] aluResult, rd1, rd2, srcA, srcB, wd, readData, data;
logic [1:0] wdSrc;
logic [1:0] aluSrcB;
logic aluSrcA;
logic regWrite, memWrite;
logic aluZero, aluSign, aluCarry, aluOverflow;
logic [4:0] aluControl;
logic [2:0] loadOp;

pcCounter inst_pcCounter(.clk (clk), .reset (reset), .pcIn(pcIn), .pc(pcOut));
pcMux inst_pcMux (.pcPlus4 (pcPlus4), .pcBranch (pcBranch), .aluResult(aluResult), .pcSrc(pcSrc), .pc(pcIn));
pcSum inst_pcSum (.pc(pcOut), .pcPlus4(pcPlus4));

instrMemory inst_instrMemory(.addr (pcOut), .rd(instr));
instrDec inst_instrDec(.instr(instr) , .instrOpcode (instrOpcode), .instrFunct3(instrFunct3), .instrFunct7(instrFunct7), .rs1(rs1), .rs2(rs2), .rd(rd), .immU(immU), .immI(immI), .immB(immB), .immS(immS), .immJ(immJ));
pcBranchSum inst_pcBranchSum(.imm(immBranch), .pc(pcOut), .pcBranch(pcBranch));
pcImmMux inst_pcImmMux (.immB(immB), .immJ(immJ), .immSrc(immSrc), .immBranch(immBranch));

wdMux inst_wdMux (.aluResult(aluResult), .immU(immU), .readData(data), .pcPlus4(pcPlus4), .wdSrc(wdSrc), .wd(wd));

regFile inst_regFile(.clk(clk), .we3(regWrite), .addr1(rs1), .addr2(rs2), .addr3(rd), .wd(wd), .rd1(rd1), .rd2(rd2));

aluMuxB inst_aluMuxB(.rd2(rd2), .immI(immI), .immS(immS), .immU(immU), .aluSrcB(aluSrcB), .srcB(srcB));
aluMuxA inst_aluMuxA(.rd1(rd1), .pc(pcOut), .aluSrcA(aluSrcA), .srcA(srcA));

controlUnit inst_controlUnit(.instrOpcode(instrOpcode), .instrFunct3(instrFunct3), .instrFunct7(instrFunct7), .aluZero(aluZero), .aluSign(aluSign),    .aluCarry (aluCarry), .aluOverflow(aluOverflow), .pcSrc(pcSrc),      .aluControl(aluControl), .aluSrcA(aluSrcA), .aluSrcB(aluSrcB), .regWrite(regWrite), .wdSrc(wdSrc), .memWrite(memWrite), .loadOp(loadOp), .immSrc(immSrc));

alu inst_alu(.srcA(srcA), .srcB(srcB), .aluControl(aluControl), .aluResult(aluResult), .aluZero(aluZero), .aluNeg(aluSign), .aluCarry(aluCarry), .aluOverflow(aluOverflow));

dataMemory inst_dataMemory(.clk(clk), .dataAddr(aluResult), .writeData(rd2), .f3 (instrFunct3), .we(memWrite), .readData(readData));

loadExt inst_loadExt(.readData(readData), .loadOp(loadOp), .data(data));

endmodule
