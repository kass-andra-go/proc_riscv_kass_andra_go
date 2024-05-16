//
// Pipeline processor RISC-V RV32I
// 
// author: Gontsova Aleksandra
//

`include "loadmemExt.vh"

module instrMemory(
  input logic [31:0] addr,
  output logic [31:0] rd
  );
  logic [31:0] ROM [63:0];
	initial
		//$readmemh("program2.txt", ROM);
    $readmemb("outm.txt", ROM);

  assign rd = ROM[addr[31:2]];

endmodule

module regFile(
  input logic clk, we3,
  input logic [4:0] addr1, addr2, addr3,
  input logic [31:0] wd,
  output logic [31:0] rd1,
  output logic [31:0] rd2
  );

  logic [31:0] RF [31:0];
  always @ ( posedge clk ) begin
    if (we3)
      RF[addr3]=wd;
  end
  assign rd1 = (addr1 == 32'b0) ? 32'b0: RF[addr1];
  assign rd2 = (addr2 == 32'b0) ? 32'b0: RF[addr2];

endmodule


module dataMemory(
  input logic clk,
  input logic [31:0] dataAddr,
  input logic [31:0] writeData,
  input logic [2:0] f3,
  input logic we,
  output logic [31:0] readData
);
logic [7:0] RAM [63:0];

//initial
//	$readmemh("data_init.txt", RAM);

logic [31:0] da;
logic [31:0] rd;

always @( posedge clk ) begin : writeDataBlock
  if (we)
    begin
      case (f3)
          SF3_SW: begin RAM [dataAddr] <= writeData[7:0];
                        RAM [dataAddr+32'b01] <= writeData[15:8];
                        RAM [dataAddr+32'b10] <= writeData[23:16];
                        RAM [dataAddr+32'b11] <= writeData[31:24]; end
          SF3_SH: begin RAM [dataAddr] <= writeData[7:0]; 
                        RAM [dataAddr+32'b01] <= writeData[15:8]; end
          SF3_SB: begin RAM [dataAddr] <= writeData[7:0]; end
          default: RAM [dataAddr] <= 8'bx;
      endcase
    end
end

assign da = {dataAddr[31:2], 2'b00};
assign rd = {RAM[da+32'b11], RAM[da+32'b10], RAM[da+32'b01], RAM[da]};
assign readData = rd >> ({dataAddr[1:0], 3'b000});

endmodule
