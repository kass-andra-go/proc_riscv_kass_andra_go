module pcMux(
input logic [31:0] pcPlus4,
input logic [31:0] pcBranch,
input logic pcSrc,
output logic [31:0] pc
);
	assign pc = pcSrc ? pcBranch : pcPlus4;
endmodule

module wdMux(
input logic [31:0] aluResult,
input logic [31:0] immU,
input logic wdSrc,
output logic [31:0] wd
);
	assign wd = wdSrc ? immU : aluResult;
endmodule

module aluMux(
input logic [31:0] rd2,
input logic [31:0] immI,
input logic aluSrc,
output logic [31:0] srcB
);
	assign srcB = aluSrc ? immI : rd2;
endmodule
