`include "alu.vh"

module alu #(parameter XLEN=32)(
    input logic [XLEN-1 : 0] srcA,srcB,
    input logic [4:0] aluControl,
    output logic [XLEN-1 : 0] aluResult,
    output logic aluZero,
    output logic aluNeg,
    output logic aluCarry,
    output logic aluOverflow
);

logic [XLEN:0] sum;
assign sum = srcA + srcB;
//logic carry;
logic [XLEN:0] sll;
assign sll = srcA << srcB[4:0];
logic ov_sum, ov_sll;

always_comb begin
  case (aluControl)
    ALU_ADD: aluResult <= sum[XLEN-1:0];
	ALU_SUB: aluResult <= srcA - srcB;
	ALU_AND: aluResult <= srcA & srcB;
	ALU_OR: aluResult <= srcA | srcB;
	ALU_XOR: aluResult <= srcA ^ srcB;
	ALU_SLL: aluResult <= sll[XLEN-1:0];
    default: aluResult <= {XLEN{1'bx}};
endcase
end

assign ov_sum = (~srcA[XLEN-1]&~srcB[XLEN-1]&sum[XLEN-1]) | (srcA[XLEN-1]&srcB[XLEN-1]&~sum[XLEN-1]);
assign ov_sll = (sll[XLEN]&~srcA[XLEN-1]) | (~sll[XLEN]&srcA[XLEN-1]); 

assign aluCarry = (sum[XLEN] == 1'b1) ? 1'b1 : 1'b0;
assign aluOverflow = ov_sum; 0;
assign aluNeg = aluResult[XLEN-1];
assign aluZero = (aluResult == {XLEN{1'b0}}) ? 1'b1 : 1'b0; 

endmodule
