module Sample_V (positive_vec,negative_vec,sample_for_P);
// the sample procedure outputs 4 MSD of D for the later selection process
parameter Num_bits=4;
parameter on_line_delay=3;

input[Num_bits+on_line_delay+1:0] positive_vec,negative_vec;
output[2:0] sample_for_P;
wire[Num_bits+on_line_delay+1:0] v_value;


assign v_value=positive_vec-negative_vec;
assign sample_for_P=v_value[Num_bits+on_line_delay+1:Num_bits+on_line_delay-1];

endmodule
