//Instruction Decode
module instrDec(
input logic [31:0] instr,
output logic [6:0] instrOpcode,
output logic [2:0] instrFunct3,
output logic [6:0] instrFunct7,
output logic [4:0] rs1,
output logic [4:0] rs2,
output logic [4:0] rd,
output logic [31:0] immU,
output logic [31:0] immI,
output logic [31:0] immB
);
	assign instrOpcode = instr[6:0];
	assign instrFunct3 = instr[14:12];
	assign instrFunct7 = instr[31:25];
	assign rs1 = instr[19:15];
	assign rs2 = instr[24:20];
	assign rd = instr[11:7];
	assign immU = {instr[31:12], {12{1'b0}}};
	assign immI = {{21{instr[31]}}, instr[30:20]};
	assign immB = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
endmodule
