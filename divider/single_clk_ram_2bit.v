module single_clk_ram_2bit(data,write_addr,read_addr,we,clk,q,write_enable
);

parameter DATA_WIDTH=2;
parameter ADDR_WIDTH=7;
input[(DATA_WIDTH-1):0] data;
input[(ADDR_WIDTH-1):0] write_addr;
input[(ADDR_WIDTH-1):0] read_addr;
input we,clk;
output[(DATA_WIDTH-1):0] q;
input write_enable;	


// this module creates a RAM of size (4*4)*128,with initially all zeros
reg[DATA_WIDTH-1:0] mem[2**ADDR_WIDTH-1:0];
reg[ADDR_WIDTH-1:0] addr_reg;

integer i;

initial begin
	for (i=0;i<2**ADDR_WIDTH;i=i+1) begin
		mem[i]<=2'b0;
	end
	addr_reg<=7'b0;
end


always@(posedge clk)begin
	if(write_enable==1'b1) begin
		if(we) begin
			mem[write_addr] <=data;
		end
		addr_reg<=read_addr;
	end
end
assign q = mem[addr_reg]; //q does not get d in this clock cycle if we is high


endmodule
