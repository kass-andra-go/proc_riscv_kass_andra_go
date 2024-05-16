//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

`include "alu.vh"

module alu #(parameter XLEN=32)(
    input logic [XLEN-1 : 0] srcA, srcB,
    input logic [4:0] aluControl,
    output logic [XLEN-1 : 0] aluResult,
    output logic aluZero,
    output logic aluNeg,
    output logic aluCarry,
    output logic aluOverflow
);
localparam SLEN = 2;
logic [XLEN:0] sum;
logic [XLEN-1:0] maybeinvertedB;

assign maybeinvertedB = aluControl[3] ? ~srcB : srcB;
assign sum = srcA + maybeinvertedB + aluControl[3];

logic [XLEN:0] sll;
assign sll = srcA << srcB[SLEN-1:0];

always_comb begin
  case (aluControl)
    ALU_ADD: begin aluResult <= sum[XLEN-1:0]; aluOverflow <= (~srcA[XLEN-1]&~srcB[XLEN-1]&sum[XLEN-1]) | (srcA[XLEN-1]&srcB[XLEN-1]&~sum[XLEN-1]); aluCarry <= sum[XLEN]; end
	ALU_SUB: begin aluResult <= sum[XLEN-1:0]; aluOverflow <= srcA[XLEN-1] & sum[XLEN-1]; aluCarry <= sum [XLEN]; end
	ALU_AND: begin aluResult <=  srcA & srcB; aluOverflow <= 1'b0; aluCarry <= 1'b0; end
	ALU_OR: begin aluResult <=  srcA | srcB; aluOverflow <= 1'b0; aluCarry <= 1'b0; end
	ALU_XOR: begin aluResult <=  srcA ^ srcB; aluOverflow <= 1'b0; aluCarry <= 1'b0; end
	ALU_SLL: begin aluResult <=  sll[XLEN-1:0]; aluOverflow <= 1'b0; aluCarry <= sll[XLEN]; end //srcA << srcB[4:0];
    ALU_SRL: begin aluResult <= srcA >> srcB[SLEN-1:0]; aluOverflow <= 1'b0; aluCarry <= srcA[srcB[SLEN-1:0]-1]; end
	ALU_SRA: begin aluResult <= $signed(srcA) >>> srcB[SLEN-1:0]; aluOverflow <= 1'b0; aluCarry <= 1'b0; end
    ALU_SLT: begin aluResult <= ($signed(srcA) < $signed(srcB))?1:0; aluOverflow <= 1'b0; aluCarry <= 1'b0; end
    ALU_SLTU: begin aluResult <= (srcA < srcB)?1:0; aluOverflow <= 1'b0; aluCarry <= 1'b0; end
    default: begin aluResult <= {XLEN{1'bx}}; aluOverflow <= 1'bx; aluCarry <= 1'bx; end
endcase
end

assign aluNeg = aluResult[XLEN-1];
assign aluZero = (aluResult == {XLEN{1'b0}}) ? 1'b1 : 1'b0; 

endmodule
