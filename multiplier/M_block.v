module M_block(sample_plus,sample_minus,P_value,upper_bits_plus,upper_bits_minus);


input[3:0] sample_plus,sample_minus; // -1 postion of sample is not used 
input[1:0] P_value; // in signed redundant representation
output[2:0] upper_bits_plus,upper_bits_minus;
reg[2:0] upper_bits_plus,upper_bits_minus;

wire[2:0] w_value;
wire[3:0] sample_value;
assign sample_value=sample_plus-sample_minus;

assign w_value[2]=sample_value[2]^(P_value[1]^P_value[0]);
assign w_value[1:0]=sample_value[1:0];


genvar i;
generate
	for(i=0;i<3;i=i+1) begin:change_signed_rep
		always@(*) begin 
			case(w_value[i])
				1'b1:begin
					upper_bits_plus[i]<=1'b1;
					upper_bits_minus[i]<=1'b0;
				end
				default:begin
					upper_bits_plus[i]<=1'b0;
					upper_bits_minus[i]<=1'b0;
				end
			endcase
		end
	end
endgenerate
	


/*
assign upper_bits_plus[2]=sample_plus[2]^(P_value[1]^P_value[0]);
assign upper_bits_minus[2]=sample_minus[2]^(P_value[1]^P_value[0]);
 
assign upper_bits_plus[1:0]=sample_plus[1:0];
assign upper_bits_minus[1:0]=sample_minus[1:0];
*/

endmodule
