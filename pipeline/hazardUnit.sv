//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

module hazardUnit(
    input logic [4:0] rs1_D,
    input logic [4:0] rs2_D,
    input logic [4:0] rs1_E,
    input logic [4:0] rs2_E,
    input logic [4:0] rd_E,
    input logic [4:0] rd_M,
    input logic [4:0] rd_W,
    input logic [1:0] pcSrc,
    input logic [1:0] wdSrc_E,
    input logic regWrite_M,
    input logic regWrite_W,
    output logic stall_F,
    output logic stall_D,
    output logic flush_D,
    output logic flush_E,
    output logic [1:0] forwardA_E,
    output logic [1:0] forwardB_E
);
logic A_EM, A_EW, B_EM, B_EW;
logic lwStall;
logic bj;

//bypass
assign A_EM = ((rs1_E != 5'b0) & (rd_M == rs1_E)) & regWrite_M;
assign B_EM = ((rs2_E != 5'b0) & (rd_M == rs2_E)) & regWrite_M;

assign A_EW = ((rs1_E != 5'b0) & (rd_W == rs1_E)) & regWrite_W;
assign B_EW = ((rs2_E != 5'b0) & (rd_W == rs2_E)) & regWrite_W;

assign forwardA_E = {A_EM, A_EW};
assign forwardB_E = {B_EM, B_EW};

//stall lw
assign lwStall = (wdSrc_E == 2'b01) & ((rs1_D == rd_E) | (rs2_E == rd_E));
assign stall_F = lwStall;
assign stall_D = lwStall;

//branch prediction
assign bj = (pcSrc != 2'b00);
assign flush_D = bj;
assign flush_E = lwStall | bj;

endmodule
