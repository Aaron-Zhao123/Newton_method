module D_FF_four_bits(in_plus,in_minus,clk,out_plus,out_minus);

input clk;
input[3:0] in_minus,in_plus;
output[3:0] out_minus,out_plus;
reg[3:0] out_minus,out_plus;

initial begin
	out_minus<=3'b0;
	out_plus<=3'b0;
end

always@(posedge clk) begin
		out_minus<=in_minus;
		out_plus<=in_plus;
end

endmodule
