//=======================================================
//  GameTime Module - Cleaned for Instantiation
//  VGA-based game timer with counter display
//=======================================================
module GameTime_Core(
    // Clock inputs
    input wire clk_50,              // 50MHz system clock
    
    // Reset and control
    input wire reset_n,             // Active-low reset
    input wire [9:0] switches,      // SW[9:0] - switch inputs
    input wire [3:0] keys,          // KEY[3:0] - button inputs
    
    // VGA outputs
    output wire vga_clk,
    output wire vga_blank_n,
    output wire vga_sync_n,
    output wire vga_hs,
    output wire vga_vs,
    output wire [7:0] vga_r,
    output wire [7:0] vga_g,
    output wire [7:0] vga_b,
    
    // GPIO (if needed for external connections)
    inout wire [35:0] gpio,
    
    // Optional LED outputs (for debugging)
    output wire [9:0] leds,
    
    // Timer value output (for other modules)
    output wire [6:0] timer_value
);

//=======================================================
//  Internal signals
//=======================================================
// Clock and reset signals
wire clk_25;
wire reset;

// VGA signals
wire [9:0] next_x, next_y;
wire [7:0] color_out;

// Counter signals
wire [6:0] counter_value;
wire counter_pixel_on;

//=======================================================
//  Reset logic (convert active-low to active-high)
//=======================================================
assign reset = ~reset_n;

//=======================================================
//  Clock divider for 25MHz VGA clock
//=======================================================
Clock_Divider #(
    .division(2), 
    .W(32)
) vga_clk_div (
    .clk_in(clk_50),
    .clk_bypass(switches[1]),       // Use SW[1] for clock bypass if needed
    .button(keys[1]),               // Use KEY[1] for manual clock
    .reset(reset),
    .clk_out(clk_25)
);

//=======================================================
//  VGA Driver
//=======================================================
vga_driver vga_inst (
    .clock(clk_25),
    .reset(reset),
    .color_in(color_out),
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

//=======================================================
//  Counter Controller
//=======================================================
counter_controller counter_ctrl (
    .clk(clk_50),
    .reset(reset),
    .enable(switches[0]),           // Use SW[0] to enable/disable counting
    .count(counter_value)
);

//=======================================================
//  Counter Display
//=======================================================
counter_display counter_disp (
    .count(counter_value),
    .pixel_x(next_x),
    .pixel_y(next_y),
    .pixel_on(counter_pixel_on)
);

//=======================================================
//  Color generation
//=======================================================
assign color_out = counter_pixel_on ? 8'b11111111 : 8'b00000000; // White digits on black background

//=======================================================
//  Output assignments
//=======================================================
assign timer_value = counter_value;    // Export timer value
assign leds = {3'b000, counter_value}; // Show counter value on LEDs (lower 7 bits)

endmodule


