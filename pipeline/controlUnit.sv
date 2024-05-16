//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

`include "alu.vh"
`include "controlUnit.vh"

//Устройство управления
module controlUnit(
input logic [6:0] instrOpcode,
input logic [2:0] instrFunct3,
input logic [6:0] instrFunct7,

output logic [4:0] 	aluControl,
output logic 		aluSrcA,
output logic	 	aluSrcB,
output logic 		regWrite,
output logic [1:0] 	wdSrc,
output logic 		memWrite,
output logic 		immSrcBJ,
output logic [1:0]	immSrcISU,
output logic [1:0]	j, 
output logic 		branch,
output logic 		jump
);

logic [1:0] aluOp;

always_comb
begin
	case (instrOpcode)
			OP_IMM: begin aluOp<=2'b00; aluSrcA <= 1'b0; aluSrcB<=1'b1; regWrite<=1'b1; wdSrc<=2'b00; memWrite = 1'b0; branch <=1'b0; jump <= 1'b0; j <= 2'b00; immSrcISU <= 2'b00; end
			OP: begin aluOp<=2'b00; aluSrcA <= 1'b0; aluSrcB<=1'b0; regWrite<=1'b1; wdSrc<=2'b00; memWrite = 1'b0; branch <=1'b0; jump <= 1'b0; j <= 2'b00; immSrcISU <= 2'b00; end
			LUI: begin aluOp<=2'b10; aluSrcA <= 1'b0; aluSrcB<=1'b0; regWrite<=1'b1; wdSrc<=2'b10; memWrite = 1'b0; branch <=1'b0; jump <= 1'b0; j <= 2'b00; immSrcISU <= 2'b10; end 
			AUIPC: begin aluOp<=2'b10; aluSrcA <= 1'b1; aluSrcB<=1'b1; regWrite<=1'b1; wdSrc<=2'b00; memWrite = 1'b0; branch <=1'b0; jump <= 1'b0; j <= 2'b00; immSrcISU <= 2'b10;end
			BRANCH: begin aluOp<=2'b01; aluSrcA <= 1'b0; aluSrcB<=1'b0; regWrite<=1'b0; wdSrc<=2'b00; memWrite = 1'b0; branch<=1'b1; jump <= 1'b0; j <= 2'b11; immSrcISU <= 2'b00;end
			LOAD: begin aluOp<=2'b11; aluSrcA <= 1'b0; aluSrcB<=1'b1; regWrite<=1'b1; wdSrc<=2'b01; memWrite = 1'b0; branch <=1'b0; jump <= 1'b0; j <= 2'b00; immSrcISU <= 2'b00; end
			STORE: begin aluOp<=2'b11; aluSrcA <= 1'b0; aluSrcB<=1'b1; regWrite<=1'b0; wdSrc<=2'b01; memWrite = 1'b1; branch <=1'b0; jump <= 1'b0; j <= 2'b00; immSrcISU <= 2'b01; end
			JAL: begin aluOp<=2'b10; aluSrcA <= 1'b0; aluSrcB<=1'b0; regWrite<=1'b1; wdSrc<=2'b11; memWrite = 1'b0; branch<=1'b0; jump <= 1'b1; j <= 2'b01; immSrcISU <= 2'b00; end
			JALR: begin aluOp<=2'b10; aluSrcA <= 1'b0; aluSrcB<=1'b1; regWrite<=1'b1; wdSrc<=2'b11; memWrite = 1'b0; branch<=1'b0; jump <= 1'b1; j <= 2'b10; immSrcISU <= 2'b00; end
			default: begin
				aluOp<=2'b00; aluSrcA <= 1'b0; aluSrcB<=1'b0; wdSrc<=2'b00; regWrite<=1'b0; memWrite <= 1'b0; branch <= 1'b0; jump <= 1'b0; j <= 2'b00; immSrcISU <= 2'b00;
			end
		endcase

end

always_comb
begin
	casex ({aluOp, instrFunct3, instrFunct7[5]})
		{2'b00, F3_ADD, 1'b0}: aluControl <= ALU_ADD;
		{2'b00, F3_ADD, 1'b1}: aluControl <= ALU_SUB;
		{2'b00, F3_XOR, 1'b0}: aluControl <= ALU_XOR;
		{2'b00, F3_OR, 1'b0}: aluControl <= ALU_OR;
		{2'b00, F3_AND, 1'b0}: aluControl <= ALU_AND;
		{2'b00, F3_SLL, 1'b0}: aluControl <= ALU_SLL;
		{2'b00, F3_SRL, 1'b0}: aluControl <= ALU_SRL;
		{2'b00, F3_SRL, 1'b1}: aluControl <= ALU_SRA;
		{2'b00, F3_SLT, 1'b0}: aluControl <= ALU_SLT;
		{2'b00, F3_SLTU, 1'b0}: aluControl <= ALU_SLTU;
		{2'b01, F3_DEF, 1'b?}: aluControl <= ALU_SUB; //BRANCH
		{2'b10, F3_DEF, 1'b?}: aluControl <= ALU_ADD; //LUI, AUIPC
		{2'b11, F3_DEF, 1'b?}: aluControl <= ALU_ADD; //LOAD and STORE (MISC_MEM)
		
		default: aluControl <= ALU_ADD;
	endcase
end

assign immSrcBJ = jump;

endmodule

module controlBranch(
	input logic aluZero,
	input logic aluSign,
	input logic aluCarry,
	input logic aluOverflow,
	input logic [2:0] instrFunct3,
	input logic branch, jump,
	input logic [1:0] j,
	output logic [1:0] pcSrc
);

logic yesbranch;

always_comb
begin
	case (instrFunct3)
		BF3_BEQ: yesbranch <= aluZero; //=
		BF3_BNE: yesbranch <= ~aluZero; //≠
		BF3_BLT: yesbranch <= aluSign ^ aluOverflow; //< signed
		BF3_BLTU: yesbranch <= ~aluCarry; //< unsigned
		BF3_BGE: yesbranch <= ~(aluSign ^ aluOverflow); // ≥ signed
		BF3_BGEU: yesbranch <= aluCarry; // ≥ unsigned
		default: yesbranch <= 1'b0;
	endcase
end

assign pcSrc = { j[1] ^ j[1]&j[0] ^ branch&yesbranch&j[1]&j[0], jump };

endmodule
