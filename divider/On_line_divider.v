module On_line_divider(clk,x_value,d_value,STATE,cnt_master,computation_cycle,q_value,enable_input,fixing_dis,In_vd,In_rd,Out_vd,Out_rd);
reg write_enable;
//output error_flag_dis;
input clk;
input[1:0] x_value,d_value;
reg[1:0] x_reg_one,d_reg_one,x_reg_two,d_reg_two;
output[1:0] q_value;

wire[1:0] q_value_nxt;
reg[1:0] q_value;

wire[3:0] q_plus_vec,q_minus_vec,d_plus_vec,d_minus_vec;
output enable_input;
wire[1:0] d_delayed,x_delayed;
wire[3:0] q_plus_selected,q_minus_selected,d_plus_selected,d_minus_selected;
wire we_input_ram;
wire[3:0] residue_plus,residue_minus,w_value_plus,w_value_minus;
wire[3:0] v_plus,v_minus,v_plus_new,v_minus_new;
wire[3:0] residue_upper_plus,residue_upper_minus;
wire[3:0] v_upper_plus_result,v_upper_minus_result;
wire[3:0] q_vec_out_plus,q_vec_out_minus;
output[1:0] STATE;
output[8:0] cnt_master;
output[6:0] computation_cycle;
wire carry_feedback;
reg div_output_ready;

// handshake
input In_vd,Out_rd;
output In_rd,Out_vd;
reg In_rd,Out_vd;
reg[1:0] online_delay_cnt;
//reg hk_en;

//reg indicator;
initial begin
In_rd<=1'b0;
Out_vd<=1'b0;
//hk_en <= 1'b0;
online_delay_cnt<=2'b11;
q_value<=2'b0;
d_reg_one<=2'b0;
d_reg_two<=2'b0;
x_reg_one<=2'b0;
x_reg_two<=2'b0;
write_enable<=1'b0;
//indicator<=1'b1;
end



//output[7:0] tmp_read_data_dis;
//output[7:0] tmp_write_data_dis;
//wire[8:0] cnt_d,cnt_p;

//output[6:0] addr_p_write;
//output[1:0] sel_dis;
//output[1:0] d_upper_plus_dis,d_upper_minus_dis;
//output[3:0] residue_upper_plus_dis,residue_upper_minus_dis;
//assign residue_upper_plus_dis=residue_upper_plus;
//assign residue_upper_minus_dis=residue_upper_minus;
wire[1:0] cin_one,cout_one,cin_two,cout_two;
wire[1:0] d_upper_plus,d_upper_minus;
//assign d_upper_plus_dis=d_upper_plus;
//assign d_upper_minus_dis=d_upper_minus;
wire borrower_up;
//output borrower_up_dis;
//assign borrower_up_dis=borrower_up;
wire error_flag;
//assign error_flag_dis=error_flag;
//-------------------------- STAGE 1-----------------------------------------------
//testing for STAGE 1
//output[15:0] tmp_read_data_dis;
//output[15:0] tmp_write_data_dis;
//output[1:0] sel_dis;
//output[8:0] cnt_dis;
// test declarations finished

// stage one: storing a input and outputing input vecs
output fixing_dis;
wire fixing;
wire[6:0] rd_addr,wr_addr;
wire[3:0] d_plus_add,d_minus_add;

assign fixing_dis=fixing;
wire[1:0] prev_q;




counter count(enable_input,clk,cnt_master,write_enable);
computation_control FSM(cnt_master,clk,computation_cycle,enable_input,we_input_ram,STATE,q_value_nxt,error_flag,fixing,prev_q,write_enable);

generate_CA_REG	CA_REG(STATE,rd_addr,computation_cycle,d_reg_two,q_value_nxt,d_plus_vec,d_minus_vec,q_plus_vec,q_minus_vec,clk,cnt_master,error_flag,we_input_ram,d_upper_plus,d_upper_minus,fixing,write_enable);
// -----------------------------STAGE 1 finished------------------------------


//----------------------------STAGE 2-----------------------------
//stage two includes SDVM block,a [2:1]ADDER and also V_upper_bits reg and corresponding adder_logic block
// 4 bits wide addition of three numbers is performed, includes the effect of x_value as well

// testing procedures
/*
output[3:0] q_plus_sel_dis,q_minus_sel_dis;
output[3:0] d_plus_sel_dis,d_minus_sel_dis;
assign q_plus_sel_dis=q_vec_out_plus;
assign q_minus_sel_dis=q_vec_out_minus;
assign d_plus_sel_dis=d_plus_selected;
assign d_minus_sel_dis=d_minus_selected;
 
output[3:0] v_upper_plus_dis,v_upper_minus_dis;  
assign v_upper_plus_dis=v_upper_plus_result;
assign v_upper_minus_dis=v_upper_minus_result;
output[3:0] v_plus_dis,v_minus_dis;
assign v_plus_dis=v_plus_new;
assign v_minus_dis=v_minus_new;
output[1:0] cin_dis,cout_dis;
assign cin_dis=cin_two;
assign cout_dis=cout_one;
output carry_feedback,carry_propogate;
*/
//finished testing


// because q[j] value is used, q_vec_control provides this vec available
//q_vec_control vec_control(cnt_master,computation_cycle,clk,q_plus_vec,q_minus_vec,d_value,STATE,q_vec_out_plus,q_vec_out_minus);

SDVM selector1(q_plus_vec,q_minus_vec,~d_reg_two,q_vec_out_plus,q_vec_out_minus,write_enable);

four_bits_adder adder1(q_vec_out_plus,q_vec_out_minus,residue_plus,residue_minus,v_plus,v_minus,cin_one,cout_one);

D_FF_two_bits D2(x_reg_two,x_delayed,clk,write_enable);

V_value_logic adder1_logic(cnt_master,x_delayed,v_plus,v_minus,v_plus_new,v_minus_new,clk,cnt_master,computation_cycle,STATE,residue_upper_plus,residue_upper_minus,cout_one,v_upper_plus_result,v_upper_minus_result,cin_one,borrower_up,write_enable,carry_feedback);

//--------------------------STAGE 2 finished----------------------------

//-------------------------------------STAGE 3----------------------------------
// stage three contains V block, SELD bolck, thus the output qj+1 could be calculated

SDVM selector2(d_plus_vec,d_minus_vec,~q_value_nxt,d_plus_selected,d_minus_selected,write_enable);
V_block Sample(v_upper_plus_result,v_upper_minus_result,q_value_nxt,borrower_up,fixing,prev_q);

//-------------------------------STAGE 4----------------------------------
// [2:1] adder and residue ram
//wired shift before storing to the ram
//testing procedures
//output[3:0] w_upper_plus,w_upper_minus;
//output[3:0] d_plus_add_dis,d_minus_add_dis;
//output carry_feedback_two,carry_propogte_two;
//output[3:0] d_upper_plus_add_dis,d_upper_minus_add_dis;

//assign d_plus_add_dis=d_plus_add;
//assign d_minus_add_dis=d_minus_add;
//assign w_plus=w_value_plus;
//assign w_minus=w_value_minus;
//assign residue_minus_dis=residue_minus;
//assign residue_plus_dis=residue_plus;

four_bits_adder adder2(v_plus_new,v_minus_new,d_plus_add,d_minus_add,w_value_plus,w_value_minus,cin_two,cout_two);

w_value_logic_fix W_block(STATE,cnt_master,computation_cycle,clk,carry_feedback,v_upper_plus_result,v_upper_minus_result,d_plus_selected,d_minus_selected,w_value_plus,w_value_minus,d_plus_add,d_minus_add,residue_plus,residue_minus,residue_upper_plus,residue_upper_minus,cout_two,cin_two,rd_addr,wr_addr,d_upper_plus,d_upper_minus,q_value_nxt,error_flag,write_enable);


//output detection

always@(*)begin
		if((STATE==2'b11&&fixing!=1'b1)||(STATE==2'b10)) begin
			div_output_ready<=1'b1;
		end
		else begin
			div_output_ready<=1'b0;
		end
end
/*
always@(*) begin
	if((STATE==2'b01&&computation_cycle==7'b0) || (STATE==2'b10&&(cnt_master==9'b11||cnt_master==9'b10))) begin
			div_output_ready<=1'b1;
		end
		else begin
			div_output_ready<=1'b0;
		end	
	&&(cnt_master==9'b100||cnt_master==9'b11))

end

*/


reg flag;
initial begin
	flag<=1'b0;
end





//handshake protocol
//assign write_enable = (~div_output_ready) & write_enable;

always@(posedge clk) begin
	

	//clear

	if ( Out_vd==1'b1 && Out_rd==1'b1 ) begin //outputing state
		write_enable<=1'b0;  //go to rest state
		Out_vd<=1'b0;
		In_rd<=1'b0;
	end
	
		// output state
	if(div_output_ready==1'b1 && write_enable ==1'b1) begin //if output is ready
		In_rd<=1'b0;
		if(online_delay_cnt==2'b00)begin 
			Out_vd<=1'b1;   //show that output is ready , output is held for two cycles
			q_value<=q_value_nxt;
		end
		else begin
			Out_vd<=1'b0;
			online_delay_cnt<=online_delay_cnt-2'b1;
		end
		
		write_enable<=1'b0; //stop computing, in case output is not ready
	end // this is when output is generated
	
	// input 
	if(In_rd==1'b1 && In_vd==1'b1 && write_enable==1'b1) begin
		flag<=1'b0;
		x_reg_two<=x_reg_one;
		d_reg_two<=d_reg_one;
			
	end
	In_rd<=1'b0;
	//
	if(Out_vd==1'b0 && write_enable ==1'b0) begin // resting state 
		if(In_rd == 1'b0 && In_vd == 1'b1) begin //starts to take input in next cycle
			In_rd <= 1'b1;
			
			x_reg_one<=x_value;
			d_reg_one<=d_value;
			
			x_reg_two<=x_reg_one;
			d_reg_two<=d_reg_one;
			
			if (flag==1'b1) begin
				write_enable<=1'b1;
			end
		
			
			if(flag==1'b0) begin
				flag<=1'b1;
			end
			
		end
	/*	else if(In_rd==1'b1 && In_vd==1'b1) begin
			In_rd<=1'b0;
		end*/
	end
	
end


endmodule
