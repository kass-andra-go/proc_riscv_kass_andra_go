//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

module pcCounter(
input logic clk,
input logic reset,
input logic enn,
input logic [31:0] pcIn,
output logic [31:0] pc
);

always_ff @ (posedge clk or posedge reset)
begin
	if (reset==1'b1)
		pc <= 32'b0;
	else if (~enn)
		pc <= pcIn;
end

endmodule

module pcSum(
input logic [31:0] pc,
output logic [31:0] pcPlus4
);
	assign pcPlus4 = pc + 32'h4;
endmodule

module pcBranchSum(
input logic [31:0] imm,
input logic [31:0] pc,
output logic [31:0] pcBranch
);
	assign pcBranch = imm + pc;
endmodule

