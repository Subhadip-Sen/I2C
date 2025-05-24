////////////////////////////Interface/////////////////////////////////////////////////////////////////////
 
interface i2c_i;
  	logic scl, rst, wr;
	logic [6:0] addr;
	logic [7:0] din;
	logic  [7:0] datard;
	logic done;
endinterface