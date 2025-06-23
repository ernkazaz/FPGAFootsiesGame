module lfsr_16bit (
    input clk,
    input [15:0] seed,
    output [15:0] lfsr_out
);

    wire feedback;
    wire [15:0] shifted_reg;

    assign feedback = shifted_reg[5] ^ (shifted_reg[3] ^ (shifted_reg[2] ^ shifted_reg[0]));

    shift_register #(.W(16)) my_sr (
        .clk(clk),
        .control(2'b10),         // Right Shift
        .parallel_in(seed),      // No parallel load
        .serial_in_left(feedback),   // Tapped Feedback
        .serial_in_right(1'b0),  // No right-serial input
        .shifted_reg(shifted_reg)
    );

    assign lfsr_out = shifted_reg;

endmodule
