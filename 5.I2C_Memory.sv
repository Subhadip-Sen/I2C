///////////////////////////////Memory///////////////////////////////////////////////////////////////////
module i2c_mem (	input logic clk,
					input logic rst,
					input logic wr,
					input logic [6:0] addr,
					input logic [7:0] din,
					output logic [7:0] dout);

    logic [7:0] mem [0:127];

  always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 128; i++)
                mem[i] <= 8'd0;
        end else if (wr) begin
            mem[addr] <= din;
        end
    end

    assign dout = mem[addr];

endmodule