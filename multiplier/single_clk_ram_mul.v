module single_clk_ram_mul(data,addr,we,clk,q,write_enable
);

parameter DATA_WIDTH=16;
parameter ADDR_WIDTH=7;
input[(DATA_WIDTH-1):0] data;
input[(ADDR_WIDTH-1):0] addr;
input we,clk;
output[(DATA_WIDTH-1):0] q;
	
input write_enable;

// this module creates a RAM of size (4*4)*128,with initially all zeros
reg[DATA_WIDTH-1:0] mem[2**ADDR_WIDTH-1:0];
reg[ADDR_WIDTH-1:0] addr_reg;

integer i;

initial begin
	for (i=0;i<2**ADDR_WIDTH;i=i+1) begin
		mem[i]<=16'b0;
	end
	addr_reg<=7'b0;
end


always@(posedge clk)begin
	if(write_enable==1'b1) begin
		if(we)
			mem[addr] <=data;
		addr_reg<=addr;
	end
end
assign q = mem[addr_reg]; //q does not get d in this clock cycle if we is high


endmodule
