`timescale 1ns/1ps  
module testbench();

reg clk;
reg[8:0] cnt;
reg[1:0] x_value,numerator,divisor,b_value;
//wire[6:0] computation_cycle_mul,computation_cycle_div;
//wire[8:0] cnt_mul,cnt_div;

wire[1:0] product_one,q_value;
wire[1:0] sum;
wire read_indicator_mul,read_indicator_div;
//wire[1:0] STATE,STATE_div;
wire mul_output_ready,div_output_ready;
reg write_enable_mul,write_enable_div;
//wire[8:0] z_plus_dis,z_minus_dis;
integer data_in_file_mul;
integer scan_file_mul;
integer data_out_file_mul;
integer data_in_file_div;
integer scan_file_div;
integer data_out_file_div;
integer data_in_b_value;
integer scan_file_b_value;
Newton_method trial(
x_value,
b_value
numerator,
divisor,
clk,
product_one,
q_value,
sum,
read_indicator_mul,
read_indicator_div,
write_enable_mul,
write_enable_div,
mul_output_ready,
div_output_ready
);

initial begin
	clk=0;
	x_value=2'b0;
	numerator=2'b0;
	divisor=2'b0;
	write_enable_mul=1'b1;
	write_enable_div=1'b1;
	cnt=9'b0;
	
	while(1) begin
		#10 clk=~clk;
		cnt=cnt+1;
		/*if(cnt<=9'b1111) begin
		  write_enable=1'b1;  
		end
		else begin
		  write_enable=1'b0;
		end
		*/
  end
end
// clock module, 50Mhz clk



initial begin
  data_in_file_mul=$fopen("H:/UROP research/verilog/src_newton/x_value.txt","r");
  data_out_file_mul=$fopen("H:/UROP research/verilog/Newton_method/output_mul.dat","w");
  data_in_file_div=$fopen("H:/UROP research/verilog/Online_divider_arbitary_precision/sample.txt","r");
  data_out_file_div=$fopen("H:/UROP research/verilog/Newton_method/output_div.dat","w");
  data_in_b_value=$fopen("H:/UROP research/verilog/src_newton/constant.txt","r");
end

always@(posedge clk) begin
	if(read_indicator_mul)
		scan_file_mul=$fscanf(data_in_file_mul,"%b",x_value);
	 
	if(mul_output_ready)
		$fwrite(data_out_file_mul,"%b\n",product_one);
		
	if(read_indicator_div)begin
		scan_file_div=$fscanf(data_in_file_div,"%b %b",numerator,divisor);
	end
	if(div_output_ready) begin
		$fwrite(data_out_file_div,"%b\n",q_value);
	//	$fwrite(cycle_num_out_file,"%d\n",cycle_num);
	//	$fflush(cycle_num_out_file);
	end
		
		
		
end

endmodule
