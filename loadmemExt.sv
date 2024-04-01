`include "loadmemExt.vh"

module loadExt(
input logic [31:0] readData,
input logic [2:0] loadOp,
output logic [31:0] data
);
	always_comb begin
		case (loadOp)
			LF3_LW: data <= readData;
			LF3_LH: data <= {{16{readData[15]}}, readData[15:0]};
			LF3_LB: data <= {{24{readData[7]}}, readData[7:0]};
			LF3_LHU: data <= {{16{1'b0}}, readData[15:0]};
			LF3_LBU: data <= {{24{1'b0}}, readData[7:0]};
			default: data <= 32'bx;
		endcase
	end
	
endmodule
