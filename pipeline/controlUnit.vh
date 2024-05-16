//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

`ifndef __CONTROLUNIT_VH__
`define __CONTROLUNIT_VH__

//opcode
parameter OP =          7'b0110011;
parameter OP_IMM =      7'b0010011;
parameter LUI =         7'b0110111;
parameter AUIPC =       7'b0010111;
parameter BRANCH =      7'b1100011; // BEQ, BNE, BLT, BGE, BLTU, BGEU
parameter LOAD =        7'b0000011; // LB, LH, LW, LBU, LHU
parameter STORE =       7'b0100011; // SB, SH, SW
parameter MISC_MEM =    7'b0001111; // ???
parameter JAL =         7'b1101111; // JAL
parameter JALR =        7'b1100111;
parameter SYSTEM =      7'b1110011;

//funct3 OP/OP_IMM
parameter F3_ADD = 3'b000; // ADD + SUB 
parameter F3_SLL = 3'b001;
parameter F3_SLT = 3'b010;
parameter F3_SLTU = 3'b011;
parameter F3_XOR = 3'b100;
parameter F3_SRL = 3'b101; // SRL + SRA
parameter F3_OR  = 3'b110;
parameter F3_AND = 3'b111;

parameter F3_DEF = 3'bxxx; //default

//funct3 branch instructions
parameter BF3_BEQ = 3'b000;
parameter BF3_BNE = 3'b001;
parameter BF3_BLT = 3'b100;
parameter BF3_BGE = 3'b101;
parameter BF3_BLTU = 3'b110;
parameter BF3_BGEU = 3'b111;

`endif 

