module tb_mini();

logic clk, reset;
int cnt = 0;

top dut (.clk(clk), .reset(reset));

// initialize test
	initial begin
        reset <= 1; # 22; reset <= 0;
	end

	// generate clock to sequence tests
	always begin
		clk <= 1; # 5; clk <= 0; # 5;
	end
    always @(posedge clk) begin
        if (cnt > 20) $stop;
        cnt = cnt + 1;
    end

endmodule