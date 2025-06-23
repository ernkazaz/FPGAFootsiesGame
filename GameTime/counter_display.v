// Module to display a 2-digit counter (00-99)
module counter_display (
    input [6:0] count,      // Counter value (0-99)
    input [9:0] pixel_x,    // Current pixel x coordinate
    input [9:0] pixel_y,    // Current pixel y coordinate
    output reg pixel_on     // 1 if pixel should be on
);
    
    // Position for digits (center-top of screen)
    parameter DIGIT_X_TENS = 10'd310;  // Tens digit position
    parameter DIGIT_X_ONES = 10'd330;  // Ones digit position  
    parameter DIGIT_Y = 10'd50;        // Top of screen with some margin
    
    // Extract tens and ones digits
    wire [3:0] tens_digit = count / 10;
    wire [3:0] ones_digit = count % 10;
    
    // Pixel enable signals from each digit
    wire tens_pixel_on, ones_pixel_on;
    
    // Instantiate digit displays
    digit_display tens_display (
        .digit(tens_digit),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .digit_x(DIGIT_X_TENS),
        .digit_y(DIGIT_Y),
        .pixel_on(tens_pixel_on)
    );
    
    digit_display ones_display (
        .digit(ones_digit),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .digit_x(DIGIT_X_ONES),
        .digit_y(DIGIT_Y),
        .pixel_on(ones_pixel_on)
    );
    
    // Combine outputs
    always @(*) begin
        pixel_on = tens_pixel_on | ones_pixel_on;
    end
endmodule
