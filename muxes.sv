module pcMux(
input logic [31:0] pcPlus4,
input logic [31:0] pcBranch,
input logic [31:0] aluResult,
input logic [1:0] pcSrc,
output logic [31:0] pc
);
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
input logic [31:0] immI,
input logic [31:0] immS,
input logic [31:0] immU,
input logic [1:0] aluSrcB,
output logic [31:0] srcB
);
	always_comb begin
		case (aluSrcB)
			2'b00: srcB <= rd2;
			2'b01: srcB <= immI;
			2'b10: srcB <= immS;
			2'b11: srcB <= immU;
			default: srcB <= 32'bx;
		endcase
	end
	
endmodule

module aluMuxA(
	input logic [31:0] rd1,
	input logic [31:0] pc,
	input logic aluSrcA,
	output logic [31:0] srcA
);
	assign srcA = aluSrcA ? pc : rd1;
endmodule

module pcImmMux(
	input logic [31:0] immB,
	input logic [31:0] immJ,
	input logic immSrc,
	output logic [31:0] immBranch
);
assign immBranch = immSrc ? immJ : immB;

endmodule
