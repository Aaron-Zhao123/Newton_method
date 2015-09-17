module subtraction_three(
clk,
x,
y,
res,
In_vld,
In_rdy,
Out_vld,
Out_rdy
);

input clk;
input[1:0] x,y;
reg write_enable;
output[1:0] res;
reg[1:0] res;
wire[1:0] res_nxt;
//handshake

input In_vld,Out_rdy;
output In_rdy,Out_vld;
reg In_rdy,Out_vld;
reg[2:0] online_delay_cnt;


initial begin
In_rdy<=1'b1;
Out_vld<=1'b0;
write_enable <= 1'b0;
online_delay_cnt<=3'b10;
res<=2'b0;
end

wire[1:0] inverted_y;
assign inverted_y=~y;

On_line_adder adder(clk,write_enable,x,inverted_y,res_nxt);


//handshake protocol 
always@(posedge clk)begin
	In_rdy <= 1'b0;
	
	if(Out_vld==1'b1&&Out_rdy==1'b1 ) begin
		write_enable<=1'b0;
		Out_vld<=1'b0;
		In_rdy<=1'b0;
	end
	
	
	if(write_enable==1'b1) begin  //if output is ready
		In_rdy<=1'b0;
		if(online_delay_cnt==2'b00)begin 
			Out_vld<=1'b1;   //show that output is ready , output is held for two cycles
			res<=res_nxt;
		end
		else begin
			Out_vld<=1'b0;
			online_delay_cnt<=online_delay_cnt-2'b1;
		end
		write_enable<=1'b0;
	end
	

	
	if(Out_vld==1'b0&& write_enable==1'b0) begin
		if(In_rdy == 1'b0 && In_vld == 1'b1) begin //starts to take input in next cycle
			In_rdy <= 1'b1;
			write_enable<=1'b1;
		end
	end
end

endmodule
