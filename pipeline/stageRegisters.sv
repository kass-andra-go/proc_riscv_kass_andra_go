//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

module regFetchDecode(
    input logic clk,
    input logic reset,
    input logic enn,
    input logic clr,
    input logic [31:0] instr,
    input logic [31:0] pc,
    input logic [31:0] pcPlus4,
    output logic [31:0] instr_D,
    output logic [31:0] pc_D,
    output logic [31:0] pcPlus4_D
);

always_ff @( posedge clk ) begin
    if (reset | clr)
    begin
        instr_D <= 32'b0;
        pc_D <= 32'b0;
        pcPlus4_D <= 32'b0;
    end
    else if (~enn)
    begin
        instr_D <= instr;
        pc_D <= pc;
        pcPlus4_D <= pcPlus4;
    end
end

endmodule

//неархитектурный регистр для сохранения извлеченных из регистрового файла данных
//регистр между стадиями Decode и Execute 
module regDecodeExecute (
    input logic clk,
    input logic reset,
    input logic clr,
    input logic [31:0] rd1,
    input logic [31:0] rd2,
    input logic [31:0] pc_D,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [31:0] immISU,
    input logic [31:0] immBranch,
    input logic [31:0] pcPlus4_D,
    input logic [4:0] rd_D,
    output logic [31:0] rd1_E,
    output logic [31:0] rd2_E,
    output logic [31:0] pc_E,
    output logic [4:0] rs1_E,
    output logic [4:0] rs2_E,
    output logic [31:0] immISU_E,
    output logic [31:0] immBranch_E,
    output logic [31:0] pcPlus4_E,
    output logic [4:0] rd_E
);

always_ff @( posedge clk ) begin
    if (reset | clr) begin
        rd1_E <= 32'b0;
        rd2_E <= 32'b0;
        pc_E <= 32'b0;
        rs1_E <= 5'b0;
        rs2_E <= 5'b0;
        immISU_E <= 32'b0;
        immBranch_E <= 32'b0;
        pcPlus4_E <= 32'b0;
        rd_E <= 5'b0;
    end
    else begin
        rd1_E <= rd1;
        rd2_E <= rd2;
        pc_E <= pc_D;
        rs1_E <= rs1;
        rs2_E <= rs2;
        immISU_E <= immISU;
        immBranch_E <= immBranch;
        pcPlus4_E <= pcPlus4_D;
        rd_E <= rd_D;
    end
end
endmodule

module regExecuteMemory(
    input logic clk,
    input logic reset,
    input logic [31:0] aluResult,
    input logic [31:0] writeData,
    input logic [31:0] immISU_E,
    input logic [31:0] pcPlus4_E,
    input logic [4:0] rd_E,
    output logic [31:0] aluResult_M,
    output logic [31:0] writeData_M,
    output logic [31:0] immISU_M,
    output logic [31:0] pcPlus4_M,
    output logic [4:0] rd_M
);
always_ff @( posedge clk ) begin
if (reset) begin
        aluResult_M <= 32'b0;
        writeData_M <= 32'b0;
        immISU_M <= 32'b0;
        pcPlus4_M <= 32'b0;
        rd_M <= 5'b0;
    end
    else begin
        aluResult_M <= aluResult;
        writeData_M <= writeData;
        immISU_M <= immISU_E;
        pcPlus4_M <= pcPlus4_E;
        rd_M <= rd_E;
    end
    end
endmodule

module regMemoryWriteBack(
    input logic clk,
    input logic reset,
    input logic [31:0] data,
    input logic [31:0] immISU_M,
    input logic [31:0] aluResult_M,
    input logic [4:0] rd_M,
    input logic [31:0] pcPlus4_M,
    output logic [31:0] data_W,
    output logic [31:0] immISU_W,
    output logic [31:0] aluResult_W,
    output logic [4:0] rd_W,
    output logic [31:0] pcPlus4_W
);
always_ff @( posedge clk ) begin
if (reset) begin
        data_W <= 32'b0;
        immISU_W<= 32'b0;
        aluResult_W <= 32'b0;
        pcPlus4_W <= 32'b0;
        rd_W <= 5'b0;
    end
    else begin
        data_W <= data;
        immISU_W <= immISU_M;
        aluResult_W <= aluResult_M;
        pcPlus4_W <= pcPlus4_M;
        rd_W <= rd_M;
    end
end
endmodule
