module Adder_control_logic(cnt_master,clk,p,STATE,comp_cycle,x_plus,x_minus,y_plus,y_minus,v_value_plus,v_value_minus,write_enable);

input write_enable;
input [8:0] cnt_master;
input clk;
input[1:0] p;
input[1:0] STATE;
input[6:0] comp_cycle;


input[3:0] x_plus,x_minus,y_plus,y_minus;
output[8:0] v_value_minus,v_value_plus;
//output[1:0] cout_four_bits_dis_one,cout_four_bits_dis_two;
//output[1:0] cin_four_bits_dis_one,cin_four_bits_dis_two;
//output[8:0] w_plus_dis,w_minus_dis;
//output enable_shift_dis,enable_adder_dis;
//output[6:0] write_addr,read_addr;
wire[3:0] residue_plus,residue_minus;


//output[3:0] z_plus,z_minus;
wire[3:0] tmp_plus,tmp_minus;
wire[2:0] w_upper_plus,w_upper_minus;

//output[3:0] tmp_plus_dis,tmp_minus_dis;

reg[1:0] tmp_add_one,tmp_add_two;
reg[8:0] w_plus_shifted,w_minus_shifted;
reg[4:0] v_upper_plus,v_upper_minus,v_upper_plus_tmp,v_upper_minus_tmp;
reg[6:0] write_addr,read_addr;

wire[1:0] cin_four_bits_one,cin_four_bits_two;
wire[1:0] cout_four_bits_one,cout_four_bits_two;
reg we;
reg enable_shift,enable_adder;
reg shift_plus,shift_minus;

/*output[3:0] residue_plus_dis,residue_minus_dis;
assign residue_plus_dis=residue_plus;
assign residue_minus_dis=residue_minus;
assign cout_four_bits_dis_one=cout_four_bits_one;
assign cout_four_bits_dis_two=cout_four_bits_two;
assign cin_four_bits_dis_one=cin_four_bits_one;
assign cin_four_bits_dis_two=cin_four_bits_two;


assign w_plus_dis=w_plus_shifted;
assign w_minus_dis=w_minus_shifted;
*/

initial begin
w_plus_shifted<=9'b0;
w_minus_shifted<=9'b0;
v_upper_plus_tmp<=4'b0;
v_upper_minus_tmp<=4'b0;
enable_adder<=1'b0;
enable_shift<=1'b1;
shift_plus<=1'b0;
shift_minus<=1'b0;
end


four_bits_parallel_adder adder1(x_plus,x_minus,y_plus,y_minus,residue_plus,residue_minus,tmp_plus,tmp_minus,cin_four_bits_one,cin_four_bits_two,cout_four_bits_one,cout_four_bits_two);
//D_FF_four_bits_enable D(tmp_plus,tmp_minus,enable_shift,clk,z_plus,z_minus);
D_FF_two_bits D2(cout_four_bits_one,cin_four_bits_one,clk,enable_adder);
D_FF_two_bits D3(cout_four_bits_two,cin_four_bits_two,clk,enable_adder);



always@(enable_shift,cout_four_bits_one,cout_four_bits_two,v_upper_plus_tmp,v_upper_minus_tmp,tmp_add_one,tmp_add_two) begin

	if(enable_shift) begin
		tmp_add_one<=cout_four_bits_one;
		tmp_add_two<=cout_four_bits_two;
	end
	else begin
		tmp_add_one<=2'b00;
		tmp_add_two<=2'b00;
	end
	v_upper_plus<=v_upper_plus_tmp+tmp_add_one[1]+tmp_add_two[1];
	v_upper_minus<=v_upper_minus_tmp+tmp_add_one[0]+tmp_add_two[0];	
end
/*
assign tmp_plus_dis=tmp_plus;
assign tmp_minus_dis=tmp_minus;
assign enable_shift_dis=enable_shift;
assign enable_adder_dis=enable_adder;
*/

assign v_value_plus={v_upper_plus,tmp_plus};
assign v_value_minus={v_upper_minus,tmp_minus}; // this is the current v value


M_block M(v_value_plus[8:5],v_value_minus[8:5],p,w_upper_plus,w_upper_minus);//passing current v value to M block to generate W value

always@(v_value_plus,v_value_minus,w_upper_plus,w_upper_minus,shift_plus,shift_minus) begin //shift the W values

	w_plus_shifted<={w_upper_plus,v_value_plus[4:0],shift_plus};
	w_minus_shifted<={w_upper_minus,v_value_minus[4:0],shift_minus};
end

	
always@(posedge clk) begin  //loop back the w values to feed back to v values again
	if(write_enable==1'b1) begin
		if(enable_shift) begin
			v_upper_plus_tmp<=w_plus_shifted[8:4];
			v_upper_minus_tmp<=w_minus_shifted[8:4];	

		end
		if(STATE==2'b01||STATE==2'b11) begin
			shift_plus<=v_value_plus[3];
			shift_minus<=v_value_minus[3];
		end
		
		else begin
			shift_plus<=1'b0;
			shift_minus<=1'b0;
		end
	end
end



//-------------------equivalent m block--------------------------

always@(comp_cycle,STATE,residue_minus,residue_plus) begin


		enable_shift<=1'b1;
		enable_adder<=1'b0;
		we<=1'b1;
		write_addr<=comp_cycle;
		read_addr<=comp_cycle;

	if(STATE==2'b00)begin	 
		enable_adder<=1'b0;
		enable_shift<=1'b1;
		we<=1'b1;			
		if(comp_cycle==7'b1)begin 
			we<=1'b0;
			enable_shift<=1'b0;
		end
	end
	if(STATE==2'b11)begin //producing results, data_out
		enable_adder<=1'b0;
		we<=1'b1;
		enable_shift<=1'b1;
		write_addr<=7'b0;
		read_addr<=comp_cycle;
	end
	/*if(STATE==2'b00&&(cnt_master==9'b11||cnt_master==9'b100))begin
		enable_shift<=1'b0;
		enable_adder<=1'b1;
		we<=1'b0;	
	
	end*/
	if(STATE==2'b01) begin
		enable_adder<=1'b1;
		enable_shift<=1'b0;
		write_addr<=comp_cycle+1'b1;
		read_addr<=comp_cycle;
		we<=1'b1;

		

	end
	if(STATE==2'b10) begin // read the lsd numbers
		enable_shift<=1'b0;
		enable_adder<=1'b0;
		we<=1'b0;
		read_addr<=comp_cycle;




	end
end


//-------------------------------------------------------------------



v_value_ram	v_ram({w_plus_shifted[3:0],w_minus_shifted[3:0]},write_addr,read_addr,we,clk,{residue_plus,residue_minus});


/*
always@(posedge clk) begin
	

	if(STATE==2'b00&&cnt_master!=9'b11) begin
		we<=1'b1;
		cin_four_bits<=2'b0;
	end
	if(STATE==2'b00&&(cnt_master==9'b11||cnt_master==9'b100)) begin
		we<=1'b0;
		cin_four_bits<=2'b0;
	end
	
	if(STATE==2'b01) begin
		we<=1'b1;
		cin_four_bits<=2'b0;
	end
	if(STATE==2'b11) begin
		we<=1'b1;
		cin_four_bits<=cout_four_bits;
	end
end
*/

endmodule
