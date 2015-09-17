module Multiplier_four(x,y,p,clk,STATE,computation_cycle_mul,cnt_mul,In_vd,Out_rd,In_rd,Out_vd);
input[1:0] x,y;
reg write_enable;
reg mul_output;
input clk;
output[1:0] p;
wire [1:0] p_result;
//output read_indicator;
//output[1:0] cout_four_bits_dis_one,cout_four_bits_dis_two;
//output[1:0] cin_four_bits_dis_one,cin_four_bits_dis_two;
//output[8:0] w_plus_dis,w_minus_dis;
//tesing 
//output[3:0] z_plus,z_minus;
//output[3:0] x_plus_dis,x_minus_dis,y_plus_dis,y_minus_dis;
output[6:0] computation_cycle_mul;
output[8:0] cnt_mul;
//output[6:0] write_addr,read_addr;
//output[15:0] tmp_read_data_dis;
//output[15:0] tmp_write_data_dis;
//output we_dis;
//output[6:0] cycle_num_dis;
output[1:0] STATE;
//output[8:0] z_plus_dis,z_minus_dis;
//testing finished
//output enable_shift_dis,enable_adder_dis;

// handshake
input In_vd,Out_rd;
output In_rd,Out_vd;
reg In_rd,Out_vd;
reg[1:0] online_delay_cnt;

reg[1:0] p;

//reg indicator;
initial begin
In_rd<=1'b0;
Out_vd<=1'b0;
write_enable <= 1'b0;
online_delay_cnt<=2'b00;
//indicator<=1'b1;

p <= 2'b00;
end
/*
always@(posedge clk)begin
	if(indicator==1'b1) begin
		In_rd<=1'b1;
		indicator<=1'b0;
	end
	
end
*/
//wire load;
wire enable;
wire[8:0] cnt_master;
wire[6:0] computation_cycle; 
wire[3:0] x_minus_delayed,y_plus,y_minus,x_plus,x_minus;
wire we;
wire[8:0] v_value_plus,v_value_minus;
//output[3:0] residue_plus,residue_minus;
wire[2:0] sample_V;
//wire[3:0] sample_M;
//wire[1:0] cout;
wire[3:0] x_plus_value,x_minus_value;
//wire[3:0] tmp_plus,tmp_minus;



// SECTION ONE design
//initializing the counter moduel and CA reg with aid of the controlling logic
//assign read_indicator=enable;
counter main_counter(enable,clk,cnt_master,write_enable);
computation_control_mul FSM(cnt_master,clk,computation_cycle,enable,we,STATE,write_enable);
generate_CA_REG_mul CA_REG(computation_cycle,x,y,x_plus,x_minus,y_plus,y_minus,clk,cnt_master,we,write_enable);
// section one design finished
//testing procedure for section one
/*assign x_plus_dis=x_plus;
assign x_minus_dis=x_minus;
assign y_plus_dis=y_plus;
assign y_minus_dis=y_minus;

assign we_dis=we;*/
//section one testing finished

assign computation_cycle_mul=computation_cycle;

assign cnt_mul=cnt_master;
//SECTION TWO
//design the selector and the delay, 
wire[3:0] x_plus_sel,x_minus_sel,y_plus_sel,y_minus_sel;
//wire[1:0] cin;
 
x_string_delay_control Delay_block(clk,x_plus,x_minus,STATE,x_plus_value,x_minus_value,write_enable);
SDVM_mul selector1(clk,STATE,x_plus_value,x_minus_value,y,x_plus_sel,x_minus_sel,write_enable);
SDVM_mul selector2(clk,STATE,y_plus,y_minus,x,y_plus_sel,y_minus_sel,write_enable);



//SECTION TWO testing
/*
output[3:0] x_plus_sel_dis,x_minus_sel_dis;
output[3:0] y_plus_sel_dis,y_minus_sel_dis;


assign x_plus_sel_dis=x_plus_sel;
assign x_minus_sel_dis=x_minus_sel;
assign y_plus_sel_dis=y_plus_sel;
assign y_minus_sel_dis=y_minus_sel;
*/
// finished SECTION TWO




//SECTION THREE: Change adder module 
// using the adder and RAM for v_value, in Adder control, the shifiting is finished 

Adder_control_logic adder_control_logic(cnt_master,clk,p_result,STATE,computation_cycle,x_plus_sel,x_minus_sel,y_plus_sel,y_minus_sel,v_value_plus,v_value_minus,write_enable);

Sample_V	Sample(v_value_plus,v_value_minus,sample_V);
Selection V_block(sample_V,p_result);


//testing
/*
output[8:0] v_value_plus_dis;
output[8:0] v_value_minus_dis;
output[2:0] sample_V_dis;
output[3:0] tmp_plus_dis,tmp_minus_dis;
assign tmp_minus_dis=tmp_minus;
assign tmp_plus_dis=tmp_plus;
assign v_value_plus_dis=v_value_plus;
assign v_value_minus_dis=v_value_minus;
assign sample_V_dis=sample_V;
*/

// when is output available
always@(*) begin
			if(STATE==2'b11||(STATE==2'b00&&cnt_master!=9'b0000&&computation_cycle!=7'b1)) begin
				mul_output<=1'b1; //finished one computation
			end
			else begin
				mul_output<=1'b0;
			end
end



//handshake protocol
always@(posedge clk) begin
	
	// clear 
	In_rd<=1'b0;	
	if (Out_vd==1'b1&&Out_rd==1'b1 ) begin //outputing state
		write_enable<=1'b0;  //go to rest state
		Out_vd<=1'b0;
	end
	
	// output handshake
	if(mul_output==1'b1 && write_enable ==1'b1) begin //if output is ready
		In_rd<=1'b0;
		if(online_delay_cnt==2'b00)begin 
			Out_vd<=1'b1;   //show that output is ready , output is held for two cycles
			p<=p_result;
		end
		else begin
			Out_vd<=1'b0;
			online_delay_cnt <= online_delay_cnt-2'b01;
		end
		
		write_enable<=1'b0; //stop computing, in case output is not ready
	end // this is when output is generated
	

	// input handshake
	if(Out_vd==1'b0 && write_enable ==1'b0) begin // resting state 
		if(In_rd == 1'b0 && In_vd == 1'b1) begin //starts to take input in next cycle
			In_rd <= 1'b1;
			write_enable<=1'b1;
		end
	/*	else if(In_rd==1'b1 && In_vd==1'b1) begin
			In_rd<=1'b0;
		end*/
	end
	
end
/*
always@(*) begin
	if(In_rd==1'b0&&In_vd==1'b1 && Out_vd==1'b0&&Out_rd) begin
		write_enable<=1'b1;
	end
	else begin
		write_enable<=1'b0;
	end
end
*/


endmodule



