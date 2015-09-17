`timescale 1ns/1ps  
module testbench_test_handshake();
reg clk;
reg[1:0] x_value,subtraend_one,minuend_one,operand_two,numerator_one,divisor_one,subtraend_two,minuend_two,mul_three,subtrahend_three,minuend_three,mul_four,operand_four,numerator_two,divisor_two,subtrahend_four,minuend_four;
wire[1:0] product_one,diff_one,product_two,product_three,quotient_one,diff_two,diff_three,product_four,quotient_two,diff_four;

reg In_vd_mul_one,Out_rd_mul_one;
wire In_rd_mul_one,Out_vd_mul_one;

reg In_vd_sub_one,Out_rd_sub_one;
wire In_rd_sub_one,Out_vd_sub_one;

reg In_vd_mul_two,Out_rd_mul_two;
wire In_rd_mul_two,Out_vd_mul_two;

reg In_vd_div_one,Out_rd_div_one;
wire In_rd_div_one,Out_vd_div_one;

reg In_vd_sub_two,Out_rd_sub_two;
wire In_rd_sub_two,Out_vd_sub_two;

reg In_vd_mul_three,Out_rd_mul_three;
wire In_rd_mul_three,Out_vd_mul_three;

reg In_vd_sub_three,Out_rd_sub_three;
wire In_rd_sub_three,Out_vd_sub_three;

reg In_vd_mul_four,Out_rd_mul_four;
wire In_rd_mul_four,Out_vd_mul_four;

reg In_vd_div_two,Out_rd_div_two;
wire In_rd_div_two,Out_vd_div_two;

reg In_vd_sub_four,Out_rd_sub_four;
wire In_rd_sub_four,Out_vd_sub_four;

 Newton_method trail(
 // inputs
x_value,
operand_two,
subtraend_one,
minuend_one,

numerator_one,
divisor_one,

subtraend_two,
minuend_two,
mul_three,
subtrahend_three,
minuend_three,
mul_four,
operand_four,
numerator_two,
divisor_two,
subtrahend_four,
minuend_four,
clk,
//outputs
product_one,
product_two,
diff_one,
quotient_one,
diff_two,
product_three,
diff_three,
product_four,
quotient_two,
diff_four,


In_vd_mul_one,
Out_rd_mul_one,
In_rd_mul_one,
Out_vd_mul_one,

In_vd_sub_one,
Out_rd_sub_one,
In_rd_sub_one,
Out_vd_sub_one,

In_vd_mul_two,
Out_rd_mul_two,
In_rd_mul_two,
Out_vd_mul_two,

In_vd_div_one,
Out_rd_div_one,
In_rd_div_one,
Out_vd_div_one,

In_vd_sub_two, 
Out_rd_sub_two,
In_rd_sub_two,
Out_vd_sub_two,

In_vd_mul_three,
Out_rd_mul_three,
In_rd_mul_three,
Out_vd_mul_three,

In_vd_sub_three,
Out_rd_sub_three,
In_rd_sub_three,
Out_vd_sub_three,

In_vd_mul_four,
Out_rd_mul_four,
In_rd_mul_four,
Out_vd_mul_four,

In_vd_div_two,
Out_rd_div_two,
In_rd_div_two,
Out_vd_div_two,

In_vd_sub_four,
Out_rd_sub_four,
In_rd_sub_four,
Out_vd_sub_four,
);

//In_vd_mul_one is always 1


integer data_in_file_mul_one,scan_file_mul_one;
integer data_in_file_mul_two,scan_file_mul_two;
integer data_in_file_sub_one,scan_file_sub_one;
integer data_in_file_sub_two,scan_file_sub_two;
integer data_in_file_sub_three,scan_file_sub_three;
integer data_in_file_mul_four,scan_file_mul_four;
//
initial begin
  data_in_file_mul_one=$fopen("H:/UROP research/verilog/src_newton/x_value.txt","r");
  data_in_file_sub_one=$fopen("H:/UROP research/verilog/src_newton/b_value.txt","r");

  data_in_file_mul_two=$fopen("H:/UROP research/verilog/src_newton/operand_two_value.txt","r");
  
  data_in_file_sub_two=$fopen("H:/UROP research/verilog/src_newton/x_value_sub.txt","r"); 
  
  data_in_file_sub_three=$fopen("H:/UROP research/verilog/src_newton/b_value_stage_two.txt","r");
  data_in_file_mul_four=$fopen("H:/UROP research/verilog/src_newton/operand_four.txt","r");

  
  In_vd_mul_one<=1'b1; //input file always valid
  In_vd_mul_two<=1'b1;	//input file always valid
 
	//testing case
	Out_rd_sub_four<=1'b1;
	//end
  
  In_vd_sub_one<=1'b1;
  In_vd_div_one<=1'b1;
  
  //Out_rd_sub_one<=1'b1;

end
initial begin
	clk=0;
	subtraend_one=2'b0;
	numerator_one=2'b0;
	divisor_one=2'b0;
	minuend_two<=2'b0;
	mul_three<=2'b0;
	mul_four<=2'b0;
	subtrahend_four<=2'b0;
	minuend_four<=2'b0;
	scan_file_sub_two=$fscanf(data_in_file_sub_two,"%b",subtraend_two);
	scan_file_mul_one=$fscanf(data_in_file_mul_one,"%b",x_value);
	scan_file_mul_two=$fscanf(data_in_file_mul_two,"%b",operand_two);
	scan_file_sub_one=$fscanf(data_in_file_sub_one,"%b",minuend_one);
	scan_file_sub_three=$fscanf(data_in_file_sub_three,"%b",minuend_three);
	scan_file_mul_four=$fscanf(data_in_file_mul_four,"%b",operand_four);


	while(1) begin
		#10 clk=~clk;
  end
end
reg[1:0] tmp;
initial begin
	tmp<=2'b0;
end
always@(*) begin
	Out_rd_mul_one<=In_rd_sub_one;
	In_vd_sub_one<=Out_vd_mul_one;
	
	In_vd_div_one<=Out_vd_mul_two&&Out_vd_sub_one;
	Out_rd_sub_one<=In_rd_div_one;
	Out_rd_mul_two<=In_rd_div_one;
	
	Out_rd_div_one<=In_rd_sub_two;
	In_vd_sub_two<=Out_vd_div_one;

	//connnecting multiplier 3
	In_vd_mul_three<=Out_vd_sub_two;
	Out_rd_sub_two<=In_rd_mul_three; //&& In_rd_mul_four;
	
	//connecting subtraction three
	In_vd_sub_three<=Out_vd_mul_three;
	
	
	Out_rd_mul_three<=In_rd_sub_three;
	
	//connecting multiplier 4
	In_vd_mul_four<=Out_vd_sub_two;
	
	//connect divider 2
	In_vd_div_two<=Out_vd_sub_three;
	
	
	Out_rd_mul_four<=1;
	//In_rd_div_two;
	Out_rd_sub_three<=In_rd_div_two;
	
	// connect subtractor 4
	In_vd_sub_four<=Out_vd_sub_two && Out_vd_div_two;
	Out_rd_div_two<=In_rd_sub_four;
	
	
	
	subtraend_one<=product_one;
	numerator_one<=diff_one;
	divisor_one<=product_two;
	minuend_two<=quotient_one;
	mul_three<=diff_two;
	subtrahend_three<=product_three;
	mul_four<=diff_two;
	
	if(diff_three==2'b11) begin
		numerator_two<=2'b00;
	end
	else begin
		numerator_two<=diff_three;
	end
	
	//subtrahend_four<=diff_two;
	//minuend_four<=quotient_two;
	
	
end

integer cnt=12;

reg[1:0] reg_mul_one,reg_mul_two,reg_mul_three,reg_mul_four,reg_mul_five;
reg flag;
initial begin
	reg_mul_one <= 2'b0;
	reg_mul_two <= 2'b0;
	reg_mul_three <= 2'b0;
	reg_mul_four <= 2'b0;
	reg_mul_five <= 2'b0;
	flag <= 1'b0;
	divisor_two <=2'b0;
end

// controlling divisor two
always @ (posedge Out_vd_mul_four) begin
		reg_mul_one <= product_four;
		reg_mul_two <= reg_mul_one;
		reg_mul_three <= reg_mul_two;
		reg_mul_four <= reg_mul_three;
		reg_mul_five <= reg_mul_four;
		divisor_two <= reg_mul_five;
end
/*
always @ (posedge In_rd_mul_four) begin
		if (flag == 0) begin
			flag <= 1'b1;
		end
		else begin 
			reg_mul_one <= diff_two;
			reg_mul_two <= reg_mul_one;
			reg_mul_three <= reg_mul_two;
			reg_mul_four <= reg_mul_three;
			reg_mul_five <= reg_mul_four;
			mul_four <= reg_mul_five;
		end
end
*/
/*
reg wr_cs,rd_cs,rd_en,wr_en;
reg[1:0] data_in;
wire[1:0] data_out;
wire empty,full;
*/
//FIFO_micmic FIFO(clk,1'b0,wr_cs,rd_cs,data_in,rd_en,wr_en,data_out,empty,full);
reg[1:0] reg_one,reg_two,reg_three,reg_four,reg_five,reg_six,reg_seven;
reg [1:0] reg_q_one,reg_q_two;
reg full;
initial begin
	reg_one<=2'b0;
	reg_two<=2'b0;
	reg_three<=2'b0;
	reg_four<=2'b00;
	reg_five<=2'b00;
	reg_six<=2'b0;
	reg_seven<=2'b0;
	full =0;
	
	reg_q_one<=2'b00;
	reg_q_two<=2'b00;
end

always @ (posedge In_vd_sub_four) begin
	reg_q_one<=quotient_two;
	reg_q_two<=reg_q_one;
	minuend_four<=reg_q_two;
end

always @(posedge Out_vd_sub_two) begin
	if (full==0) begin
		reg_one<=diff_two;
		reg_two<=reg_one;
		reg_three<=reg_two;
		reg_four<= reg_three;
		reg_five<=reg_four;
		reg_six<= reg_five;
		reg_seven <= reg_six;
		if (reg_seven != 2'b00) begin
			full <= 1;
		end
	end
end

always @ (posedge In_vd_sub_four) begin
		reg_one<=diff_two;
		reg_two<=reg_one;
		reg_three<=reg_two;
		reg_four<= reg_three;
		reg_five<=reg_four;
		reg_six<= reg_five;
		reg_seven <= reg_six;
		subtrahend_four <= reg_seven;
end


always@(posedge clk) begin

	
	if(In_vd_mul_one==1'b1&&In_rd_mul_one==1'b1) begin
		scan_file_mul_one=$fscanf(data_in_file_mul_one,"%b",x_value);
	end
	
	
	if(In_vd_mul_two==1'b1&&In_rd_mul_two==1'b1) begin
		scan_file_mul_two=$fscanf(data_in_file_mul_two,"%b",operand_two);
	end
	
	if(In_vd_sub_one==1'b1&&In_rd_sub_one==1'b1&&Out_vd_mul_one==1'b1) begin
		scan_file_sub_one=$fscanf(data_in_file_sub_one,"%b",minuend_one);
	end
	
	if(In_vd_sub_two==1'b1 && In_rd_sub_two==1'b1 && Out_rd_div_one==1'b1) begin
	
		scan_file_sub_two=$fscanf(data_in_file_sub_two,"%b",subtraend_two);
	end
	
	if(In_vd_sub_three==1'b1 && In_rd_sub_three==1'b1 && Out_rd_mul_three==1'b1) begin
		scan_file_sub_three=$fscanf(data_in_file_sub_three,"%b",minuend_three);
	end
	
	if(In_vd_mul_four==1'b1 && In_rd_mul_four==1'b1) begin
		scan_file_mul_four=$fscanf(data_in_file_mul_four,"%b",operand_four);
	end
	
	
/*		tmp<=product_two;
		divisor_one<=tmp;
		*/
		
end

integer data_out_file;

initial begin
 data_out_file=$fopen("H:/UROP research/Matlab/output.dat","w");
end

always @(posedge Out_vd_div_two)begin
	$fwrite(data_out_file,"%b\n",diff_four);
end

/*
always @(negedge Out_vd_div_two)begin
	$fwrite(data_out_file,"%b\n",quotient_two);
end
*/
endmodule
