module Counter #(parameter W=4) (
	input clk,
	input [1:0] control,
	output reg [W-1:0] counter
);

	localparam Reset = 2'b00, Increment=2'b01,
				Decrement=2'b10, Hold = 2'b11;

always@(posedge clk)begin
	case(control)
		Hold: counter <= counter;
		Increment: counter <= counter + 1;
		Decrement: counter <= counter -1;
		Reset: counter <= 0;
		default: counter <= 0;
	endcase
end

endmodule 