//
// Single-cycle processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

`ifndef __LOADSTOREEXT_VH__
`define __LOADSTOREEXT_VH__

//funct3 load instructions
parameter LF3_LW = 3'b000;
parameter LF3_LH = 3'b001;
parameter LF3_LB = 3'b010;
parameter LF3_LHU = 3'b101;
parameter LF3_LBU = 3'b110;

//funct3 store instructions
parameter SF3_SW = 3'b000;
parameter SF3_SH = 3'b001;
parameter SF3_SB = 3'b010;

`endif 
