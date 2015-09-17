module D_flipflop (clk,in,out,enable_output);
	input enable_output;
	input in,clk;
	output out;
	reg out;
	
	initial begin
		out<=1'b0;
	end

	
	always@(posedge clk) begin
		if(enable_output==1'b1) begin
			out<=in;
		end
		
	end
	
	
	endmodule
	
	