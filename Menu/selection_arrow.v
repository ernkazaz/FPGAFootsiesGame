module selection_arrow (
    input wire clock,
    input wire reset,
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [7:0] bg_color,    // Background color from multi module
    input wire selection,         // SW[0] - 0 for Single Player, 1 for Multi Player
    output reg [7:0] color_out    // Final color output
);

    // Arrow parameters
    parameter [9:0] ARROW_WIDTH = 10'd20;   // Arrow width in pixels (increased)
    parameter [9:0] ARROW_HEIGHT = 10'd12;  // Arrow height in pixels (increased)
    
    // Screen and text positioning (matching your text modules)
    parameter [9:0] SCREEN_WIDTH = 10'd640;
    parameter [9:0] SCREEN_HEIGHT = 10'd480;
    parameter [9:0] TEXT_LENGTH = 10'd13;
    parameter [9:0] CHAR_WIDTH = 10'd8;
    parameter [9:0] TEXT_WIDTH = TEXT_LENGTH * CHAR_WIDTH;
    
    // Single Player position (Y = center + 40)
    parameter [9:0] SINGLE_START_X = (SCREEN_WIDTH - TEXT_WIDTH) / 2;
    parameter [9:0] SINGLE_START_Y = (SCREEN_HEIGHT / 2) + 10'd40;
    
    // Multi Player position (Y = center + 65)  
    parameter [9:0] MULTI_START_X = (SCREEN_WIDTH - TEXT_WIDTH) / 2;
    parameter [9:0] MULTI_START_Y = (SCREEN_HEIGHT / 2) + 10'd65;
    
    // Arrow positioning (20 pixels to the left of text, centered vertically)
    parameter [9:0] ARROW_OFFSET_X = 10'd25;  // Distance from text (increased)
    parameter [9:0] ARROW_OFFSET_Y = 10'd2;   // Center arrow vertically with text
    
    // Arrow colors
    parameter [7:0] ARROW_COLOR = 8'b11111111;  // White arrow
    
    // Calculate arrow position based on selection
    wire [9:0] arrow_x = selection ? (MULTI_START_X - ARROW_OFFSET_X) : (SINGLE_START_X - ARROW_OFFSET_X);
    wire [9:0] arrow_y = selection ? (MULTI_START_Y + ARROW_OFFSET_Y) : (SINGLE_START_Y + ARROW_OFFSET_Y);
    
    // Check if current pixel is within arrow bounds
    wire in_arrow_area = (pixel_x >= arrow_x) && (pixel_x < arrow_x + ARROW_WIDTH) &&
                        (pixel_y >= arrow_y) && (pixel_y < arrow_y + ARROW_HEIGHT);
    
    // Calculate relative position within arrow
    wire [4:0] rel_x = pixel_x - arrow_x;  // Changed to 5 bits for larger width
    wire [3:0] rel_y = pixel_y - arrow_y;  // Changed to 4 bits for larger height
    
    // Triangle arrow pattern (pointing right) - Larger size
    // Arrow shape: ►
    reg arrow_pixel;
    always @(*) begin
        case (rel_y)
            4'd0:  arrow_pixel = (rel_x == 5'd0);                                                           // •
            4'd1:  arrow_pixel = (rel_x == 5'd0) || (rel_x == 5'd1);                                      // ••
            4'd2:  arrow_pixel = (rel_x == 5'd0) || (rel_x == 5'd1) || (rel_x == 5'd2);                  // •••
            4'd3:  arrow_pixel = (rel_x == 5'd0) || (rel_x == 5'd1) || (rel_x == 5'd2) || (rel_x == 5'd3); // ••••
            4'd4:  arrow_pixel = (rel_x == 5'd0) || (rel_x == 5'd1) || (rel_x == 5'd2) || (rel_x == 5'd3) || (rel_x == 5'd4); // •••••
            4'd5:  arrow_pixel = (rel_x == 5'd0) || (rel_x == 5'd1) || (rel_x == 5'd2) || (rel_x == 5'd3) || (rel_x == 5'd4) || (rel_x == 5'd5); // ••••••
            4'd6:  arrow_pixel = (rel_x == 5'd0) || (rel_x == 5'd1) || (rel_x == 5'd2) || (rel_x == 5'd3) || (rel_x == 5'd4); // •••••
            4'd7:  arrow_pixel = (rel_x == 5'd0) || (rel_x == 5'd1) || (rel_x == 5'd2) || (rel_x == 5'd3); // ••••
            4'd8:  arrow_pixel = (rel_x == 5'd0) || (rel_x == 5'd1) || (rel_x == 5'd2);                  // •••
            4'd9:  arrow_pixel = (rel_x == 5'd0) || (rel_x == 5'd1);                                      // ••
            4'd10: arrow_pixel = (rel_x == 5'd0);                                                           // •
            4'd11: arrow_pixel = 1'b0;                                                                      // 
            default: arrow_pixel = 1'b0;
        endcase
    end
    
    always @(posedge clock) begin
        if (reset) begin
            color_out <= 8'b00000000;
        end
        else begin
            if (in_arrow_area && arrow_pixel) begin
                color_out <= ARROW_COLOR;  // White arrow
            end
            else begin
                color_out <= bg_color;     // Use background color
            end
        end
    end

endmodule