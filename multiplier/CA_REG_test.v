module CA_REG_test(computation_cycles,x_input,y_input,x_plus,x_minus,y_plus,y_minus,clk,cnt);

//This module makes use of a RAM, for which it writes single values of x and y
// reads the x_string and y_string


parameter Num_bits=4;
output[Num_bits-1:0] x_plus,x_minus,y_plus,y_minus;
input clk;
input[6:0] cnt;
input[4:0] computation_cycles;
input[1:0] x_input,y_input;

wire[6:0] addr;
reg[15:0] tmp_write_data;
wire[15:0] tmp_read_data;
reg[Num_bits-1:0] x_plus,x_minus,y_plus,y_minus;




assign addr={computation_cycles,1'b0,1'b0};
single_clk_ram	ram1(tmp_read_data,tmp_write_data,addr,addr,1'd1,clk); //read and write to ram at the same time

always@(*) begin
case(cnt[1:0])
	2'b00:begin
		tmp_write_data<={tmp_read_data[15:4],{x_input[1:0],y_input[1:0]}};
	end
	2'b01:begin
		tmp_write_data<={tmp_read_data[15:8],{x_input[1:0],y_input[1:0]},tmp_read_data[3:0]};
	end
	2'b10:begin
		tmp_write_data<={tmp_read_data[15:12],{x_input[1:0],y_input[1:0]},tmp_read_data[7:0]};
	end
	2'b11:begin
		tmp_write_data<={{x_input[1:0],y_input[1:0]},tmp_read_data[11:0]};
	end
endcase
end



integer i,j;


always@(posedge clk) begin
	for(i=0;i<4;i=i+1) begin:computes_output
		x_plus[j]<=tmp_write_data[i*4];
		x_minus[j]<=tmp_write_data[i*4+1];
		y_plus[j]<=tmp_write_data[i*4+2];
		y_minus[j]<=tmp_write_data[i*4+3];
		j=j-1;
	end	
end

endmodule
