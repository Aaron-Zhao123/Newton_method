module Multiplier(x,y,p,clk,read_indicator,x_plus_dis,x_minus_dis,y_plus_dis,y_minus_dis,computation_cycle_dis,cnt_dis,we_dis,STATE,v_value_plus_dis,v_value_minus_dis,x_plus_sel_dis,x_minus_sel_dis,y_plus_sel_dis,y_minus_sel_dis,sample_V_dis,residue_plus,residue_minus,cout_four_bits_dis_one,cout_four_bits_dis_two,cin_four_bits_dis_one,cin_four_bits_dis_two,w_plus_dis,w_minus_dis,tmp_plus_dis,tmp_minus_dis,z_plus,z_minus,enable_shift_dis,enable_adder_dis,write_addr,read_addr);
input[1:0] x,y;
input clk;
output[1:0] p;
output read_indicator;
output[1:0] cout_four_bits_dis_one,cout_four_bits_dis_two;
output[1:0] cin_four_bits_dis_one,cin_four_bits_dis_two;
output[8:0] w_plus_dis,w_minus_dis;
//tesing 
output[3:0] z_plus,z_minus;
output[3:0] x_plus_dis,x_minus_dis,y_plus_dis,y_minus_dis;
output[6:0] computation_cycle_dis;
output[8:0] cnt_dis;
output[6:0] write_addr,read_addr;
//output[15:0] tmp_read_data_dis;
//output[15:0] tmp_write_data_dis;
output we_dis;
//output[6:0] cycle_num_dis;
output[1:0] STATE;
//output[8:0] z_plus_dis,z_minus_dis;
//testing finished
output enable_shift_dis,enable_adder_dis;

wire load;
wire enable;
wire[8:0] cnt_master;
wire[6:0] computation_cycle; 
wire[3:0] x_plus_delayed,x_minus_delayed,y_plus,y_minus,x_plus,x_minus;
wire we;
wire[8:0] v_value_plus,v_value_minus;
output[3:0] residue_plus,residue_minus;
wire[2:0] sample_V;
wire[3:0] sample_M;
wire[1:0] cout;
wire[3:0] x_plus_value,x_minus_value;
wire[3:0] tmp_plus,tmp_minus;



// SECTION ONE design
//initializing the counter moduel and CA reg with aid of the controlling logic
assign read_indicator=enable;
counter main_counter(enable,clk,cnt_master);
computation_control FSM(cnt_master,clk,computation_cycle,enable,we,STATE);
generate_CA_REG CA_REG(computation_cycle,x,y,x_plus,x_minus,y_plus,y_minus,clk,cnt_master,we);
// section one design finished
//testing procedure for section one
assign x_plus_dis=x_plus;
assign x_minus_dis=x_minus;
assign y_plus_dis=y_plus;
assign y_minus_dis=y_minus;
assign computation_cycle_dis=computation_cycle;
assign cnt_dis=cnt_master;
assign we_dis=we;
//section one testing finished



//SECTION TWO
//design the selector and the delay, 
wire[3:0] x_plus_sel,x_minus_sel,y_plus_sel,y_minus_sel;
wire[1:0] cin;
 
x_string_delay_control Delay_block(clk,x_plus,x_minus,STATE,x_plus_value,x_minus_value);
SDVM selector1(clk,STATE,x_plus_value,x_minus_value,y,x_plus_sel,x_minus_sel);
SDVM selector2(clk,STATE,y_plus,y_minus,x,y_plus_sel,y_minus_sel);



//SECTION TWO testing

output[3:0] x_plus_sel_dis,x_minus_sel_dis;
output[3:0] y_plus_sel_dis,y_minus_sel_dis;


assign x_plus_sel_dis=x_plus_sel;
assign x_minus_sel_dis=x_minus_sel;
assign y_plus_sel_dis=y_plus_sel;
assign y_minus_sel_dis=y_minus_sel;
// finished SECTION TWO




//SECTION THREE: Change adder module 
// using the adder and RAM for v_value, in Adder control, the shifiting is finished 

Adder_control_logic adder_control_logic(cnt_master,clk,p,STATE,computation_cycle,x_plus_sel,x_minus_sel,y_plus_sel,y_minus_sel,v_value_plus,v_value_minus,residue_plus,residue_minus,cout_four_bits_dis_one,cout_four_bits_dis_two,cin_four_bits_dis_one,cin_four_bits_dis_two,w_plus_dis,w_minus_dis,tmp_plus,tmp_minus,z_plus,z_minus,enable_shift_dis,enable_adder_dis,write_addr,read_addr);

Sample_V	Sample(v_value_plus,v_value_minus,sample_V);
Selection V_block(sample_V,p);


//testing
output[8:0] v_value_plus_dis;
output[8:0] v_value_minus_dis;
output[2:0] sample_V_dis;
output[3:0] tmp_plus_dis,tmp_minus_dis;
assign tmp_minus_dis=tmp_minus;
assign tmp_plus_dis=tmp_plus;
assign v_value_plus_dis=v_value_plus;
assign v_value_minus_dis=v_value_minus;
assign sample_V_dis=sample_V;



endmodule



