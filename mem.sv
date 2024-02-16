module instrMemory(
  input logic [31:0] addr,
  output logic [31:0] rd
  );
  logic [31:0] ROM [63:0];
	initial
    $readmemb("program5.txt", ROM);

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
