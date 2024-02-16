`include "alu.vh"
`include "controlUnit.vh"

//Устройство управления
module controlUnit(
input logic [6:0] instrOpcode,
input logic [2:0] instrFunct3,
input logic [6:0] instrFunct7,
input logic aluZero,
input logic aluSign, 
input logic aluCarry,
input logic aluOverflow,
output logic pcSrc,
output logic [4:0] aluControl,
output logic aluSrc,
output logic regWrite,
output logic wdSrc
);


logic branch, yesbranch;

logic [1:0] aluOp;

always_comb
begin
	case (instrOpcode)
			OP_IMM: begin aluOp<=2'b00; aluSrc<=1'b1; regWrite<=1'b1; wdSrc<=1'b0; branch <=1'b0; end
			OP: begin aluOp<=2'b00; aluSrc<=1'b0; regWrite<=1'b1; wdSrc<=1'b0; branch <=1'b0; end
			BRANCH: begin aluOp<=2'b01; aluSrc<=1'b0; regWrite<=1'b0; wdSrc<=1'b0; branch<=1'b1; end
			default: begin
				aluOp<=2'b00; aluSrc<=1'b0; wdSrc<=1'b0;regWrite<=1'b0; branch <= 1'b0;
			end
		endcase

end

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
		{2'b11, F3_DEF, 1'b?}: aluControl <= ALU_ADD; //LOAD and STORE (MISC_MEM)
		default: aluControl <= ALU_ADD;
	endcase
end

assign pcSrc=yesbranch&branch;

endmodule
