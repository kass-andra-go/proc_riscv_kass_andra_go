//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

//module regControlFetchDecode();
//endmodule

module regControlDecodeExecute(
    input logic clk,
    input logic reset,
    input logic clr,
    input logic regWrite,
    input logic [1:0] wdSrc,
    input logic memWrite,
    input logic [2:0] instrFunct3,
    input logic aluSrcA,
    input logic aluSrcB,
    input logic [4:0] aluControl,
    input logic branch,
    input logic jump,
    input logic [1:0] j,
    output logic regWrite_E,
    output logic [1:0] wdSrc_E,
    output logic memWrite_E,
    output logic [2:0] instrFunct3_E,
    output logic aluSrcA_E,
    output logic aluSrcB_E,
    output logic [4:0] aluControl_E,
    output logic branch_E,
    output logic jump_E,
    output logic [1:0] j_E
);

always_ff @( posedge clk ) begin
if (reset | clr) begin
        regWrite_E <= 1'b0;
        wdSrc_E <= 2'b0;
        memWrite_E <= 1'b0;
        instrFunct3_E <= 3'b0;
        aluSrcA_E <= 1'b0;
        aluSrcB_E <= 1'b0;
        aluControl_E <= 5'b0;
        branch_E <= 1'b0;
        jump_E <= 1'b0;
        j_E <= 2'b0;
    end
    else begin
        regWrite_E <= regWrite;
        wdSrc_E <= wdSrc;
        memWrite_E <= memWrite;
        instrFunct3_E <= instrFunct3;
        aluSrcA_E <= aluSrcA;
        aluSrcB_E <= aluSrcB;
        aluControl_E <= aluControl;
        branch_E <= branch;
        jump_E <= jump;
        j_E <= j;
    end
end
endmodule

module regControlExecuteMemory(
    input logic clk,
    input logic reset,
    input logic regWrite_E,
    input logic [1:0] wdSrc_E,
    input logic memWrite_E,
    input logic [2:0] instrFunct3_E,
    output logic regWrite_M,
    output logic [1:0] wdSrc_M,
    output logic memWrite_M,
    output logic [2:0] instrFunct3_M
);

always_ff @( posedge clk ) begin
if (reset) begin
        regWrite_M <= 1'b0;
        wdSrc_M <= 2'b0;
        memWrite_M <= 1'b0;
        instrFunct3_M <= 3'b0;
    end
    else begin
        regWrite_M <= regWrite_E;
        wdSrc_M <= wdSrc_E;
        memWrite_M <= memWrite_E;
        instrFunct3_M <= instrFunct3_E;
    end
end
endmodule

module regControlMemoryWriteBack(
    input logic clk,
    input logic reset,
    input logic regWrite_M,
    input logic [1:0] wdSrc_M,
    output logic regWrite_W,
    output logic [1:0] wdSrc_W
);

always_ff @( posedge clk ) begin
if (reset) begin
        regWrite_W <= 1'b0;
        wdSrc_W <=1'b0;
    end
    else begin
        regWrite_W <= regWrite_M;
        wdSrc_W <= wdSrc_M;
    end
end
endmodule
