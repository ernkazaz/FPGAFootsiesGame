module shift_register #(parameter W = 4)(
    input clk,
    input [1:0] control,
    input [W-1:0] parallel_in,
    input serial_in_left,
    input serial_in_right,
    output reg [W-1:0] shifted_reg
);

    always @(posedge clk) begin
        case (control)
            2'b00: shifted_reg <= parallel_in;
            2'b01: shifted_reg <= {shifted_reg[W-2:0], serial_in_right};  // Left Shift
            2'b10: shifted_reg <= {serial_in_left, shifted_reg[W-1:1]}; // Right Shift
            default: shifted_reg <= shifted_reg;
        endcase
    end
endmodule
