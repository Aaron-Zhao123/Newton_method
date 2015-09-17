module x_string_delay_control(clk,x_plus,x_minus,STATES,x_plus_value,x_minus_value);

input clk;
input[3:0] x_plus,x_minus;
input[1:0] STATES;
output[3:0] x_plus_value,x_minus_value;
reg[3:0] x_plus_value,x_minus_value;
wire[3:0] x_plus_delayed,x_minus_delayed;
wire[1:0] prev_STATE;


initial begin
x_plus_value=4'b0;
x_minus_value=4'b0;
end

D_FF_four_bits D_FF(x_plus,x_minus,clk,x_plus_delayed,x_minus_delayed);
D_FF_two_bits D_state(STATES,prev_STATE,clk,1'b1);


always@(*) begin

	if(STATES==2'b00||(STATES==2'b01&&prev_STATE==2'b10))begin
		x_plus_value<=x_plus_delayed;
		x_minus_value<=x_minus_delayed;
	end
	
	else begin
		x_plus_value=x_plus;
		x_minus_value=x_minus;
	end
end


endmodule
