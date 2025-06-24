module LFSR_16bit #(parameter W=16) (
	input clk,
	input reset,	
	output [W-1:0] lfsr_out
);
	
wire feedback;
wire [W-1:0] lfsr_state;
reg [1:0] shift_reg_control;

assign feedback = lfsr_state[0] ^ lfsr_state[2] ^ lfsr_state[3] ^ lfsr_state[5];
assign lfsr_out = lfsr_state;

always@(posedge clk or posedge reset) begin
	if (reset) begin
	shift_reg_control <= 2'b11;
	end else begin
	shift_reg_control <= 2'b10;
	end
end


Shift_Register #(.W(W)) shift(
	.clk(clk),
	.reset(reset),
	.mode(shift_reg_control),
	.serial_in_right(feedback),
	.serial_in_left(1'b0),
	.parallel_in(16'hACE1),
	.data_out(lfsr_state)
);
	

endmodule