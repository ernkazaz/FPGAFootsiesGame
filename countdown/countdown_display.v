module countdown_display (
    input wire clk,
    input wire reset,
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [1:0] digit,        // 3=3, 2=2, 1=1, 0=START
    input wire active,             // Display countdown when active
    input wire [7:0] bg_color,     // Background color
    output reg [7:0] color_out     // Final color output
);

    // Character parameters
    parameter [9:0] CHAR_WIDTH_BITMAP = 10'd8;   // Original bitmap width
    parameter [9:0] CHAR_HEIGHT_BITMAP = 10'd16; // Original bitmap height
    parameter [9:0] SCALE_FACTOR = 10'd6;        // Scale factor (8*6=48, 16*6=96)
    parameter [9:0] CHAR_WIDTH = CHAR_WIDTH_BITMAP * SCALE_FACTOR;   // 48 pixels wide
    parameter [9:0] CHAR_HEIGHT = CHAR_HEIGHT_BITMAP * SCALE_FACTOR; // 96 pixels tall
    
    // Screen parameters
    parameter [9:0] SCREEN_WIDTH = 10'd640;
    parameter [9:0] SCREEN_HEIGHT = 10'd480;
    
    // Colors
    parameter [7:0] TEXT_COLOR = 8'b00000000;  // Black numbers (RRRGGGBB)
    parameter [7:0] START_COLOR = 8'b11100000; // Red for START text
    
    // Position calculations for single character/word (centered)
    wire [9:0] single_char_start_x = (SCREEN_WIDTH - CHAR_WIDTH) / 2;
    wire [9:0] single_char_start_y = (SCREEN_HEIGHT - CHAR_HEIGHT) / 2;
    
    // Position calculations for "START" (5 characters)
    parameter [9:0] START_LENGTH = 10'd5;
    parameter [9:0] START_SPACING = 10'd4;  // 4 pixels between characters
    parameter [9:0] START_TOTAL_WIDTH = START_LENGTH * CHAR_WIDTH + (START_LENGTH - 1) * START_SPACING;
    wire [9:0] start_start_x = (SCREEN_WIDTH - START_TOTAL_WIDTH) / 2;
    wire [9:0] start_start_y = (SCREEN_HEIGHT - CHAR_HEIGHT) / 2;
    
    // Determine which character we're displaying and its position
    wire displaying_start = (digit == 2'd0);
    wire [9:0] display_start_x = displaying_start ? start_start_x : single_char_start_x;
    wire [9:0] display_start_y = displaying_start ? start_start_y : single_char_start_y;
    wire [9:0] display_width = displaying_start ? START_TOTAL_WIDTH : CHAR_WIDTH;
    
    // Check if we're in the display area
    wire in_display_area = (pixel_x >= display_start_x) && 
                          (pixel_x < display_start_x + display_width) &&
                          (pixel_y >= display_start_y) && 
                          (pixel_y < display_start_y + CHAR_HEIGHT);
    
    // Calculate position within display area
    wire [9:0] local_x = pixel_x - display_start_x;
    wire [9:0] local_y = pixel_y - display_start_y;
    
    // For START text, determine which character we're in
    wire [2:0] start_char_index = displaying_start ? 
                                 (local_x / (CHAR_WIDTH + START_SPACING)) : 3'd0;
    wire [9:0] char_local_x = displaying_start ? 
                             (local_x % (CHAR_WIDTH + START_SPACING)) : local_x;
    
    // Skip spacing pixels for START
    wire in_char_area = displaying_start ? 
                       (char_local_x < CHAR_WIDTH) : 1'b1;
    
    // Scale down to bitmap coordinates
    wire [2:0] bitmap_x = char_local_x / SCALE_FACTOR;
    wire [3:0] bitmap_y = local_y / SCALE_FACTOR;
    
    // Character ROM data
    reg [7:0] char_data;
    wire char_pixel = char_data[7 - bitmap_x];
    
    // Character selection logic
    reg [2:0] selected_char;
    always @(*) begin
        if (displaying_start) begin
            selected_char = start_char_index;
        end else begin
            case (digit)
                2'd3: selected_char = 3'd5;  // '3'
                2'd2: selected_char = 3'd6;  // '2'
                2'd1: selected_char = 3'd7;  // '1'
                default: selected_char = 3'd0; // Default to 'S'
            endcase
        end
    end
    
    // Character bitmap ROM
    always @(*) begin
        case (selected_char)
            3'd0: begin // 'S' (for START)
                case (bitmap_y)
                    4'd0:  char_data = 8'b01111110;
                    4'd1:  char_data = 8'b11000000;
                    4'd2:  char_data = 8'b11000000;
                    4'd3:  char_data = 8'b11000000;
                    4'd4:  char_data = 8'b01111100;
                    4'd5:  char_data = 8'b00000110;
                    4'd6:  char_data = 8'b00000110;
                    4'd7:  char_data = 8'b00000110;
                    4'd8:  char_data = 8'b11000110;
                    4'd9:  char_data = 8'b11000110;
                    4'd10: char_data = 8'b11000110;
                    4'd11: char_data = 8'b01111100;
                    4'd12: char_data = 8'b00000000;
                    4'd13: char_data = 8'b00000000;
                    4'd14: char_data = 8'b00000000;
                    4'd15: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            3'd1: begin // 'T' (for START)
                case (bitmap_y)
                    4'd0:  char_data = 8'b11111110;
                    4'd1:  char_data = 8'b00011000;
                    4'd2:  char_data = 8'b00011000;
                    4'd3:  char_data = 8'b00011000;
                    4'd4:  char_data = 8'b00011000;
                    4'd5:  char_data = 8'b00011000;
                    4'd6:  char_data = 8'b00011000;
                    4'd7:  char_data = 8'b00011000;
                    4'd8:  char_data = 8'b00011000;
                    4'd9:  char_data = 8'b00011000;
                    4'd10: char_data = 8'b00011000;
                    4'd11: char_data = 8'b00011000;
                    4'd12: char_data = 8'b00000000;
                    4'd13: char_data = 8'b00000000;
                    4'd14: char_data = 8'b00000000;
                    4'd15: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            3'd2: begin // 'A' (for START)
                case (bitmap_y)
                    4'd0:  char_data = 8'b00111000;
                    4'd1:  char_data = 8'b01111100;
                    4'd2:  char_data = 8'b11000110;
                    4'd3:  char_data = 8'b11000110;
                    4'd4:  char_data = 8'b11000110;
                    4'd5:  char_data = 8'b11000110;
                    4'd6:  char_data = 8'b11111110;
                    4'd7:  char_data = 8'b11111110;
                    4'd8:  char_data = 8'b11000110;
                    4'd9:  char_data = 8'b11000110;
                    4'd10: char_data = 8'b11000110;
                    4'd11: char_data = 8'b11000110;
                    4'd12: char_data = 8'b00000000;
                    4'd13: char_data = 8'b00000000;
                    4'd14: char_data = 8'b00000000;
                    4'd15: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            3'd3: begin // 'R' (for START)
                case (bitmap_y)
                    4'd0:  char_data = 8'b11111100;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b11000110;
                    4'd3:  char_data = 8'b11000110;
                    4'd4:  char_data = 8'b11111100;
                    4'd5:  char_data = 8'b11111000;
                    4'd6:  char_data = 8'b11011000;
                    4'd7:  char_data = 8'b11001100;
                    4'd8:  char_data = 8'b11000110;
                    4'd9:  char_data = 8'b11000110;
                    4'd10: char_data = 8'b11000110;
                    4'd11: char_data = 8'b11000110;
                    4'd12: char_data = 8'b00000000;
                    4'd13: char_data = 8'b00000000;
                    4'd14: char_data = 8'b00000000;
                    4'd15: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            3'd4: begin // Second 'T' (for START)
                case (bitmap_y)
                    4'd0:  char_data = 8'b11111110;
                    4'd1:  char_data = 8'b00011000;
                    4'd2:  char_data = 8'b00011000;
                    4'd3:  char_data = 8'b00011000;
                    4'd4:  char_data = 8'b00011000;
                    4'd5:  char_data = 8'b00011000;
                    4'd6:  char_data = 8'b00011000;
                    4'd7:  char_data = 8'b00011000;
                    4'd8:  char_data = 8'b00011000;
                    4'd9:  char_data = 8'b00011000;
                    4'd10: char_data = 8'b00011000;
                    4'd11: char_data = 8'b00011000;
                    4'd12: char_data = 8'b00000000;
                    4'd13: char_data = 8'b00000000;
                    4'd14: char_data = 8'b00000000;
                    4'd15: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            3'd5: begin // '3'
                case (bitmap_y)
                    4'd0:  char_data = 8'b01111100;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b00000110;
                    4'd3:  char_data = 8'b00000110;
                    4'd4:  char_data = 8'b00111100;
                    4'd5:  char_data = 8'b00111100;
                    4'd6:  char_data = 8'b00000110;
                    4'd7:  char_data = 8'b00000110;
                    4'd8:  char_data = 8'b00000110;
                    4'd9:  char_data = 8'b00000110;
                    4'd10: char_data = 8'b11000110;
                    4'd11: char_data = 8'b01111100;
                    4'd12: char_data = 8'b00000000;
                    4'd13: char_data = 8'b00000000;
                    4'd14: char_data = 8'b00000000;
                    4'd15: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            3'd6: begin // '2'
                case (bitmap_y)
                    4'd0:  char_data = 8'b01111100;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b00000110;
                    4'd3:  char_data = 8'b00000110;
                    4'd4:  char_data = 8'b00001100;
                    4'd5:  char_data = 8'b00011000;
                    4'd6:  char_data = 8'b00110000;
                    4'd7:  char_data = 8'b01100000;
                    4'd8:  char_data = 8'b11000000;
                    4'd9:  char_data = 8'b11000000;
                    4'd10: char_data = 8'b11000110;
                    4'd11: char_data = 8'b11111110;
                    4'd12: char_data = 8'b00000000;
                    4'd13: char_data = 8'b00000000;
                    4'd14: char_data = 8'b00000000;
                    4'd15: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            3'd7: begin // '1'
                case (bitmap_y)
                    4'd0:  char_data = 8'b00011000;
                    4'd1:  char_data = 8'b00111000;
                    4'd2:  char_data = 8'b01111000;
                    4'd3:  char_data = 8'b00011000;
                    4'd4:  char_data = 8'b00011000;
                    4'd5:  char_data = 8'b00011000;
                    4'd6:  char_data = 8'b00011000;
                    4'd7:  char_data = 8'b00011000;
                    4'd8:  char_data = 8'b00011000;
                    4'd9:  char_data = 8'b00011000;
                    4'd10: char_data = 8'b00011000;
                    4'd11: char_data = 8'b01111110;
                    4'd12: char_data = 8'b00000000;
                    4'd13: char_data = 8'b00000000;
                    4'd14: char_data = 8'b00000000;
                    4'd15: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            default: char_data = 8'b00000000;
        endcase
    end
    
    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            color_out <= 8'b00000000;
        end
        else begin
            if (active && in_display_area && in_char_area && char_pixel) begin
                // Use green for START, red for numbers
                color_out <= displaying_start ? START_COLOR : TEXT_COLOR;
            end
            else begin
                color_out <= bg_color;    // Use background color
            end
        end
    end

endmodule