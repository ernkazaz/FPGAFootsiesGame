module countdown_core (
    input wire clk,
    input wire reset,
    input wire go,                 // Start countdown signal
    input wire [9:0] pixel_x,      // Current pixel X coordinate
    input wire [9:0] pixel_y,      // Current pixel Y coordinate
    input wire [7:0] bg_color,     // Background color
    output wire [7:0] color_out,   // Final color output for display
    output wire done               // Countdown completion signal
);

    // Internal signals connecting FSM to display
    wire [1:0] digit;
    wire active;
	 
	 wire clk_25MHz;
	 wire clk_60Hz;
	 
Clock_Divider #(.division(2), .W(32)) clk_25MHz (
    .clk_in(clk),
    .clk_bypass(1'b0),
    .button(1'b0),
    .reset(1'b0),
    .clk_out(clk_25MHz)
);

Clock_Divider #(.division(833334), .W(32)) clk_60Hz (
    .clk_in(clk),
    .clk_bypass(1'b0),
    .button(1'b0),
    .reset(1'b0),
    .clk_out(clk_60Hz)
);
	 
    countdown_fsm fsm_inst (
        .clk(clk_60Hz),
        .reset(reset),
        .go(go),
        .digit(digit),
        .active(active),
        .done(done)
    );
    
    countdown_display display_inst (
        .clk(clk_25MHz),
        .reset(reset),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .digit(digit),
        .active(active),
        .bg_color(bg_color),
        .color_out(color_out)
    );

endmodule

