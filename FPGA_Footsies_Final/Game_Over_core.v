module Game_Over_core (
	
	//Clock Input
	input wire clk_50,
	
	//Reset and Control
	input wire reset,
	input wire [9:0] switches,
	input wire [3:0] keys,
	input wire winner_player,  // NEW: 0 = Player 1 wins, 1 = Player 2 wins
	
	//VGA Outputs
	output wire vga_clk,
   output wire vga_blank_n,
   output wire vga_sync_n,
   output wire vga_hs,
   output wire vga_vs,
   output wire [7:0] vga_r,
   output wire [7:0] vga_g,
   output wire [7:0] vga_b,
	//LED Outputs
	output wire [9:0] leds
);
	wire clk_25MHz;
	wire [9:0] next_x, next_y;
	wire [7:0] bg_color;
	wire [7:0] game_over_color;
	wire [7:0] player_wins_color;
	wire [7:0] final_color;
	
	Clock_Divider #(
    .division(2),    // Divide by 2 to get 25MHz from 50MHz
    .W(32)
	) clk_div_inst (
		.clk_in(clk_50),
		.clk_bypass(1'b0),    // Use SW[1] to bypass clock divider
		.button(keys[1]),            // Use KEY[1] as manual clock in bypass mode
		.reset(reset),
		.clk_out(clk_25MHz)
	);
	
	vga_background bg_module (
		.clock(clk_25MHz),
		.reset(reset),
		.pixel_x(next_x),
		.pixel_y(next_y),
		.color_out(bg_color)
	);
	
	text_display_game_over text_module_game_over(
		.clock(clk_25MHz),
		.reset(reset),
		.pixel_x(next_x),
		.pixel_y(next_y),
		.bg_color(bg_color),
		.color_out(game_over_color)
	);
	
	text_display_player_wins text_module_player_wins(
		.clock(clk_25MHz),
		.reset(reset),
		.pixel_x(next_x),
		.pixel_y(next_y),
		.bg_color(game_over_color),  // Use game_over output as input
		.player_select(winner_player),
		.color_out(player_wins_color)
	);
	
	// Final color is from the player wins module (which already includes game over text)
	assign final_color = player_wins_color;
	
	vga_driver vga_ctrl (
    .clock(clk_25MHz),
    .reset(reset),
    .color_in(final_color),      // Use final combined color
    .next_x(next_x),
    .next_y(next_y),
    .hsync(vga_hs),
    .vsync(vga_vs),
    .red(vga_r),
    .green(vga_g),
    .blue(vga_b),
    .sync(vga_sync_n),
    .clk(vga_clk),
    .blank(vga_blank_n)
	);
	
	assign leds = {9'b0, winner_player};  // Show winner on LED
endmodule