module D_FF_four_bits_enable(in_plus,in_minus,enable,clk,out_plus,out_minus);

input clk;
input enable;
input[3:0] in_minus,in_plus;
output[3:0] out_minus,out_plus;
reg[3:0] out_minus,out_plus;

initial begin
	out_minus<=4'b0;
	out_plus<=4'b0;
end

always@(posedge clk) begin
	if(enable==1'b1) begin
		out_minus<=in_minus;
		out_plus<=in_plus;
	end
end

endmodule
