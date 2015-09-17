module four_to_two_adder(a,b,w_sum,w_carry,sum,carry);
//a typical 4:2 module, which is a combination of two full adders to implement a carry save adder
//this would be a parallel adder to add 13 bits
//cx&cy==1 is finished on another block

parameter Num_bits=8;
parameter on_line_delay=3;
input[Num_bits+on_line_delay-1:-2] a,b; //input is 8 bits a and b
input[Num_bits+on_line_delay-1:-2] w_sum,w_carry;

output[Num_bits+on_line_delay-1:-2] sum,carry;
wire[Num_bits+on_line_delay-1:-2] cin_tmp,cout,sum_tmp,carry_tmp;
wire[Num_bits+on_line_delay-1:-2] input1, input2;


assign cin_tmp={cout[Num_bits+on_line_delay-2:-2],1'b0}; //wire the cout to next stage cin, assume cin0=0

assign carry= {carry_tmp[Num_bits+on_line_delay-2:-2],1'b0};
// lowest bit of carry is from cin, however, the whole carry is therefore shifted to the left by 1 bit




// thus we need 11 adders to perform parallel addition
genvar i;
generate
	for (i=Num_bits+on_line_delay-1;i>-3;i=i-1) begin:adder_chain
		full_adder FA1(a[i],b[i],w_sum[i],cout[i],sum_tmp[i]);
		full_adder FA2(sum_tmp[i],w_carry[i],cin_tmp[i],carry_tmp[i],sum[i]);
	end

endgenerate

endmodule
