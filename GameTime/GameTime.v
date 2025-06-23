module GameTime(
    //////////// CLOCK //////////
    input                     CLOCK2_50,
    input                     CLOCK3_50,
    input                     CLOCK4_50,
    input                     CLOCK_50,
    //////////// SEG7 //////////
    output        [6:0]       HEX0,
    output        [6:0]       HEX1,
    output        [6:0]       HEX2,
    output        [6:0]       HEX3,
    output        [6:0]       HEX4,
    output        [6:0]       HEX5,
    //////////// KEY //////////
    input         [3:0]       KEY,
    //////////// LED //////////
    output        [9:0]       LEDR,
    //////////// SW //////////
    input         [9:0]       SW,
    //////////// VGA //////////
    output                    VGA_BLANK_N,
    output        [7:0]       VGA_B,
    output                    VGA_CLK,
    output        [7:0]       VGA_G,
    output                    VGA_HS,
    output        [7:0]       VGA_R,
    output                    VGA_SYNC_N,
    output                    VGA_VS,
    //////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
    inout         [35:0]      GPIO
);

//=======================================================
//  REG/WIRE declarations
//=======================================================

//=======================================================
//  Structural coding
//=======================================================
 GameTime_Core gametime_inst (
    // Clock
    .clk_50(CLOCK_50),
    
    // Reset and control
    .reset_n(KEY[0]),           // KEY[0] as reset (active-low)
    .switches(SW),              // All switches
    .keys(KEY),                 // All keys
    
    // VGA outputs
    .vga_clk(VGA_CLK),
    .vga_blank_n(VGA_BLANK_N),
    .vga_sync_n(VGA_SYNC_N),
    .vga_hs(VGA_HS),
    .vga_vs(VGA_VS),
    .vga_r(VGA_R),
    .vga_g(VGA_G),
    .vga_b(VGA_B),
    
    // GPIO
    .gpio(GPIO),
    
    // LED outputs
    .leds(LEDR),
    
    // Timer value output
    .timer_value(game_timer_value)
);

endmodule
