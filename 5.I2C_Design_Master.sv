module i2c_master( 	input scl, rst, wr,
					input [6:0] addr,
					input [7:0] din,
					inout sda,
					output reg done,
					output  [7:0] datard);
 
	reg sda_temp;	
	//reg scl;
	
	reg [7:0] addrt; //temporary register to store address & wr bit
	reg [8:0] temprd;
	reg en;
	integer count = 0;
	//reg update;  
	  
	typedef enum bit [3:0] {idle = 0, start = 1, send_addr = 2, get_ack1 = 3, send_data = 4, get_ack2= 5, read_data = 6, complete = 7} state_type;
	
	state_type master_state;
 
	////////////////////////////Master Controller/////////////////////////////
	always@(posedge scl) begin
		if(rst) begin
			addrt <= 0;
			temprd <= 0;
			en <= 0;
			sda_temp <= 0;
			count <= 0;
		end
		else begin
			case(master_state) 
				idle: begin
					en    <= 1'b1;
					sda_temp  <= 1'b1;
					master_state <= start;
					count <= 0;
					done <= 1'b0;
					temprd <= 0;
				end
		 
				start: begin
					sda_temp  <= 1'b0;
					addrt <= {addr,wr};
					master_state <= send_addr;
				end
			 
				send_addr: begin
					if(count <= 7) begin
						sda_temp <= addrt[count];
						count <= count + 1;
					end
					else begin
						master_state <= get_ack1;
						count <= 0;
						en    <= 1'b0;
					end 
				end
		 
				get_ack1: begin
					if(sda == 1'b0) begin	// Master release the sda_temp line by en = 0 in prev state looks for active low ack
						if(wr == 1'b1) begin
							master_state <= send_data;
							en    <= 1'b1;
						end
						else if (wr == 1'b0 ) begin
							master_state <= read_data;
							en    <= 1'b0;
						end
					end
					else
						master_state <= get_ack1;
				end
				
				send_data: begin
					if(count <= 7) begin
						sda_temp <= din[count];
						count <= count + 1;
					end
					else begin
						master_state <= get_ack2;
						count <= 0;
						en    <= 1'b0;
					end 
				end
				 
				get_ack2: begin
					if(sda == 1'b0)
						master_state <= complete;
					else
						master_state <= get_ack2;
				end
				 
				read_data: begin
					if(count <= 8) begin	//after count = 0 and 1 slave will start sending data because of sychronization
						//temprd[count] <= sda_temp;
						temprd[8:0] <= {sda, temprd[8:1]}; 
						count <= count + 1;
					end
					else begin
						master_state <= complete;
						count <= 0;
					end 
				end
				 
				complete: begin
					//if(update) begin
						done <= 1'b1;
						master_state <= idle;
					//end
					//else
						//master_state <= complete;
				end
				 
				default : master_state <= idle;
			endcase
		end
	end
	
	assign sda = en ? sda_temp : 1'bz;
	assign datard = temprd[8:1];
	
endmodule