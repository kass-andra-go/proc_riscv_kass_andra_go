//`include "top.vh"

module top(
input logic clk,reset
);
logic pcSrc;
logic [31:0] pcIn, pcOut, pcOutShift;
logic [31:0] pcPlus4, pcBranch;

pcCounter inst_pcCounter(.clk (clk), .reset (reset), .pcIn(pcIn), .pc(pcOut));
pcMux inst_pcMux (.pcPlus4 (pcPlus4), .pcBranch (pcBranch), .pcSrc(pcSrc), .pc(pcIn));
pcSum inst_pcSum (.pc(pcOut), .pcPlus4(pcPlus4));

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

instrMemory inst_instrMemory(.addr (pcOut), .rd(instr));
instrDec inst_instrDec(.instr(instr) , .instrOpcode (instrOpcode), .instrFunct3(instrFunct3), .instrFunct7(instrFunct7), .rs1(rs1), .rs2(rs2), .rd(rd), .immU(immU), .immI(immI), .immB(immB));
pcBranchSum inst_pcBranchSum(.immB(immB), .pc(pcOut), .pcBranch(pcBranch));

logic [31:0] aluResult, rd2, srcA, srcB, wd;
logic wdSrc, regWrite, aluSrc;
logic aluZero, aluSign, aluCarry, aluOverflow;
logic [4:0] aluControl;

wdMux inst_wdMux (.aluResult(aluResult), .immU(immU), .wdSrc(wdSrc), .wd(wd));

regFile inst_regFile(.clk(clk), .we3(regWrite), .addr1(rs1), .addr2(rs2), .addr3(rd), .wd(wd), .rd1(srcA), .rd2(rd2));

aluMux inst_aluMux(.rd2(rd2), .immI(immI), .aluSrc(aluSrc), .srcB(srcB));

controlUnit inst_controlUnit(.instrOpcode(instrOpcode), .instrFunct3(instrFunct3), .instrFunct7(instrFunct7), .aluZero(aluZero), .aluSign(aluSign),    .aluCarry (aluCarry), .aluOverflow(aluOverflow), .pcSrc(pcSrc),      .aluControl(aluControl), .aluSrc(aluSrc), .regWrite(regWrite), .wdSrc(wdSrc));

alu inst_alu(.srcA(srcA), .srcB(srcB), .aluControl(aluControl), .aluResult(aluResult), .aluZero(aluZero), .aluNeg(aluSign), .aluCarry(aluCarry), .aluOverflow(aluOverflow));

endmodule
