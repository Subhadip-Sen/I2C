////////////////////////////Top/////////////////////////////////////////////////////////////////////////

module top( input scl, rst, wr,
				input [6:0] addr,
				input [7:0] din,
				output  [7:0] datard,
				output reg done);
	
	wire sda;
	wire [6:0] mem_addr;
	wire [7:0] mem_dout;
	wire [7:0] mem_din;
	
	i2c_master master(.scl(scl), .rst(rst), .wr(wr), .addr(addr), .din(din), .sda(sda), .datard(datard), .done(done));
	
	i2c_slave slave(.scl(scl), .rst(rst), .wr(wr), .mem_addr(mem_addr), .mem_din(mem_din), .mem_dout(mem_dout), .sda(sda));
  	
	i2c_mem memory(.clk(scl), .rst(rst), .wr(wr), .addr(mem_addr), .din(mem_din), .dout(mem_dout));
	
endmodule
