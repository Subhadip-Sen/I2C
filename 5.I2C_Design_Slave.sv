//////////////////////////////Slave Memory/////////////////////////////////
module i2c_slave( 	input scl, rst, wr,
					input [7:0] mem_dout,
					output reg [6:0] mem_addr,
					output reg [7:0] mem_din,
					inout sda);
 
	reg sda_temp;
	
	reg [7:0] addrn; //temporary register to store address & wr bit 

	integer countn = 0;
	reg [9:0] datan;
	reg en;
	logic [7:0] data_rd;	
    
	//////////////////////////////////////////////////////////////////////////////////
	
	typedef enum bit [3:0] {idle = 0, start = 1, get_addr = 2, send_ack1 = 3, get_data = 4, send_ack2 = 5, send_data = 6, complete = 7} state_type;
	
	state_type slave_state;	
	
	always@(posedge scl) begin
		if(rst) begin		
			addrn  <= 0;
			datan  <= 0;
			en <= 0;

		end
		else begin
			case(slave_state)
				idle: begin
					en <= 0;
					addrn  <= 0;
					datan  <= 0;
					//update <= 0;
					data_rd <= 0;

					if(scl && sda) //scl & sda both high
						slave_state <= start;
					else
						slave_state <= idle;
				end   

				start: begin
					if(scl && !sda) //sda goes low while scl is high
						slave_state <= get_addr;
					else
						slave_state <= start; 
					end
			 
				get_addr: begin 
					if(countn <= 7) begin
						addrn[countn] <= sda;
						countn <= countn + 1;
					end
					else begin
						slave_state  <= send_ack1;
					    en <= 1;	
						sda_temp <= 1'b0;
						countn <= 0;
						if(addrn[0] == 1'b0) begin //addrn[0] = 0 for read
							mem_addr <= addrn[7:1];
						end
					end
				end 
			 
				send_ack1:begin
					//en <= 1;
					//sda_temp <= 1'b0;
					if(addrn[0] == 1'b1) begin //Master want to send the data to slave memory
                      //@(posedge scl);
						slave_state <= get_data;
						en <= 0;
					end
					else if(addrn[0] == 1'b0) begin //Master wants to read data from slave memory
                      //@(posedge scl);
						data_rd <= mem_dout;						
						slave_state <= send_data;
						en <= 1;
					end
					else
						slave_state <= send_ack1;
				end
			 
				get_data: begin
					if(countn <= 8) begin
						datan[countn] <= sda;
						countn <= countn + 1;
					end
					else begin
						slave_state  <= send_ack2;
						countn <= 0;
						mem_addr <= addrn[7:1];
						mem_din <= datan[8:1];
					end
				end
						
				send_ack2:begin
					en <= 1;
					sda_temp  <= 1'b0;
					slave_state <= complete; 
				end				
				
				send_data: begin
					if(countn <= 7) begin
						sda_temp   <= data_rd[countn];
						countn <= countn + 1;
					end
					else begin
						slave_state  <= complete;
						countn <= 0;
					end
				end
						
				complete : begin
				   slave_state  <= idle;
				end
						
				default: slave_state <= idle; 
			endcase
		end
	end
	
	assign sda = en ? sda_temp : 1'bz;
	
endmodule