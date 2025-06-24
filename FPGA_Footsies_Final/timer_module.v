// Timer module that combines counter controller and display
module timer_module (
    input clk,              // System clock
    input reset,            // Reset signal
    input enable,           // Enable timer counting
    input [9:0] pixel_x,    // Current pixel x coordinate
    input [9:0] pixel_y,    // Current pixel y coordinate
    output [6:0] count,     // Current timer count (for external use)
    output pixel_on         // 1 if pixel should be on for timer display
);

    // Internal counter value
    wire [6:0] internal_count;
    
    // Instantiate counter controller
    counter_controller counter_ctrl (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(internal_count)
    );
    
    // Instantiate counter display
    counter_display counter_disp (
        .count(internal_count),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .pixel_on(pixel_on)
    );
    
    // Output the count for external use
    assign count = internal_count;

endmodule