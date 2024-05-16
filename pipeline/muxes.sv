//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

module pcMux(
input logic [31:0] pcPlus4,
input logic [31:0] pcBranch,
input logic [31:0] aluResult,
input logic [1:0] pcSrc,
output logic [31:0] pc
);
	//assign pc = pcSrc ? pcBranch : pcPlus4;
	always_comb begin
		case (pcSrc)
		2'b00: pc <= pcPlus4;
		2'b01: pc <= pcBranch;
		2'b10: pc <= pcBranch;
		2'b11: pc <= aluResult;
		default: pc <= 32'bx;
		endcase
	end
endmodule

module wdMux(
input logic [31:0] aluResult,
input logic [31:0] immU,
input logic [31:0] readData,
input logic [31:0] pcPlus4,
input logic [1:0] wdSrc,
output logic [31:0] wd
);
	//assign wd = wdSrc ? immU : aluResult;
	always_comb begin
		case (wdSrc)
		2'b00: wd <= aluResult;
		2'b01: wd <= readData;
		2'b10: wd <= immU;
		2'b11: wd <= pcPlus4;
		default: wd <= 32'bx;
		endcase
	end
endmodule

module aluMuxB(
input logic [31:0] rd2,
input logic [31:0] imm,
input logic aluSrcB,
output logic [31:0] srcB
);
	assign srcB = aluSrcB ? imm : rd2;

endmodule

module aluMuxA(
	input logic [31:0] rd1,
	input logic [31:0] pc,
	input logic aluSrcA,
	output logic [31:0] srcA
);
	assign srcA = aluSrcA ? pc : rd1;
endmodule

module pcImmMuxBJ(
	input logic [31:0] immB,
	input logic [31:0] immJ,
	input logic immSrcBJ,
	output logic [31:0] immBranch
);
assign immBranch = immSrcBJ ? immJ : immB;

endmodule

module pcImmMuxISU(
	input logic [31:0] immI,
	input logic [31:0] immS,
	input logic [31:0] immU,
	input logic [1:0] immSrcISU,
	output logic [31:0] immISU
);
always_comb begin
		case (immSrcISU)
			2'b00: immISU <= immI;
			2'b01: immISU <= immS;
			2'b10: immISU <= immU;
			default: immISU <= 32'bx;
		endcase
	end
endmodule
