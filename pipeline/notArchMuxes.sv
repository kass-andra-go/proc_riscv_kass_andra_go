//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

module forwardingMuxA(
    input logic [31:0] rd1_E,
    input logic [31:0] wd,
    input logic [31:0] aluResult_M,
    input logic [1:0] forwardA_E,
    output logic [31:0] forwRd1_E
);
    always_comb begin
        case (forwardA_E)
        2'b00: forwRd1_E <= rd1_E;
        2'b01: forwRd1_E <= wd;
        2'b10: forwRd1_E <= aluResult_M;
        default: forwRd1_E <= 32'bx;
        endcase
    end
endmodule

module forwardingMuxB(
    input logic [31:0] rd2_E,
    input logic [31:0] wd,
    input logic [31:0] aluResult_M,
    input logic [1:0] forwardB_E,
    output logic [31:0] forwRd2_E
);
    always_comb begin
        case (forwardB_E)
        2'b00: forwRd2_E <= rd2_E;
        2'b01: forwRd2_E <= wd;
        2'b10: forwRd2_E <= aluResult_M;
        default: forwRd2_E <= 32'bx;
        endcase
    end
endmodule
