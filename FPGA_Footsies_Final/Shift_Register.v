module Shift_Register #(parameter W=4) (
	input clk,
	input reset,
	input [1:0] mode,
	input serial_in_right,
	input serial_in_left,
	input [W-1:0] parallel_in,
	output reg [W-1:0] data_out
);

localparam Hold = 2'b00, Shift_left = 2'b01, Shift_right = 2'b10, Load = 2'b11;

always@(posedge clk or posedge reset) begin
	if (reset) begin
		data_out <= 0;
	end else begin
		case(mode)
			Hold: data_out <= data_out;
			Shift_left: data_out <= {data_out[W-2:0],serial_in_left};
			Shift_right: data_out <= {serial_in_right,data_out[W-1:1]};
			Load: data_out <= parallel_in;
			default: data_out <= data_out;
		endcase
	end
end


endmodule