module text_display_start (
    input wire clock,
    input wire reset,
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [7:0] bg_color,    // Background color from arrow module
    output reg [7:0] color_out    // Final color output
);

    // Text parameters
    parameter [9:0] CHAR_WIDTH = 10'd8;   // Character width in pixels
    parameter [9:0] CHAR_HEIGHT = 10'd16; // Character height in pixels
    parameter [9:0] TEXT_LENGTH = 10'd25; // "Press Any Button to Start" = 25 characters (including spaces)
    
    // Screen positioning (bottom of screen)
    parameter [9:0] SCREEN_WIDTH = 10'd640;
    parameter [9:0] SCREEN_HEIGHT = 10'd480;
    parameter [9:0] TEXT_WIDTH = TEXT_LENGTH * CHAR_WIDTH;  // Total text width
    parameter [9:0] START_X = (SCREEN_WIDTH - TEXT_WIDTH) / 2;  // Center horizontally
    parameter [9:0] START_Y = SCREEN_HEIGHT - 10'd60;          // Near bottom of screen
    
    // Colors
    parameter [7:0] TEXT_COLOR = 8'b00000000;  // White text (RRRGGGBB)
    parameter [7:0] TRANSPARENT = 8'b00000000; // Transparent (use background)
    
    // Character position within text
    wire [9:0] char_x = (pixel_x >= START_X) ? (pixel_x - START_X) : 10'd0;
    wire [9:0] char_y = (pixel_y >= START_Y) ? (pixel_y - START_Y) : 10'd0;
    wire [4:0] char_index = char_x / CHAR_WIDTH;  // Which character (0-24) - 5 bits for 25 chars
    wire [2:0] pixel_in_char_x = char_x % CHAR_WIDTH;  // X position within character (0-7)
    wire [3:0] pixel_in_char_y = char_y % CHAR_HEIGHT; // Y position within character (0-15)
    
    // Character ROM data - 8x8 bitmap font (using top 8 rows of 16)
    reg [7:0] char_data;
    wire char_pixel = char_data[7 - pixel_in_char_x];  // Extract pixel from character data
    
    always @(*) begin
        case (char_index)
            5'd0: begin // 'P'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b11111100;
                    3'd1: char_data = 8'b11000110;
                    3'd2: char_data = 8'b11000110;
                    3'd3: char_data = 8'b11111100;
                    3'd4: char_data = 8'b11000000;
                    3'd5: char_data = 8'b11000000;
                    3'd6: char_data = 8'b11000000;
                    3'd7: char_data = 8'b11000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd1: begin // 'r'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b11000110;
                    3'd4: char_data = 8'b11000000;
                    3'd5: char_data = 8'b11000000;
                    3'd6: char_data = 8'b11000000;
                    3'd7: char_data = 8'b11000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd2: begin // 'e'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b11000110;
                    3'd4: char_data = 8'b11111110;
                    3'd5: char_data = 8'b11000000;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd3: begin // 's'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b11000000;
                    3'd4: char_data = 8'b01111100;
                    3'd5: char_data = 8'b00000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd4: begin // 's'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b11000000;
                    3'd4: char_data = 8'b01111100;
                    3'd5: char_data = 8'b00000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd5: begin // ' ' (space)
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b00000000;
                    3'd3: char_data = 8'b00000000;
                    3'd4: char_data = 8'b00000000;
                    3'd5: char_data = 8'b00000000;
                    3'd6: char_data = 8'b00000000;
                    3'd7: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd6: begin // 'A'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00111000;
                    3'd1: char_data = 8'b01101100;
                    3'd2: char_data = 8'b11000110;
                    3'd3: char_data = 8'b11000110;
                    3'd4: char_data = 8'b11111110;
                    3'd5: char_data = 8'b11000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b11000110;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd7: begin // 'n'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b11000110;
                    3'd4: char_data = 8'b11000110;
                    3'd5: char_data = 8'b11000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b11000110;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd8: begin // 'y'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b11000110;
                    3'd3: char_data = 8'b11000110;
                    3'd4: char_data = 8'b11000110;
                    3'd5: char_data = 8'b01111110;
                    3'd6: char_data = 8'b00000110;
                    3'd7: char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd9: begin // ' ' (space)
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b00000000;
                    3'd3: char_data = 8'b00000000;
                    3'd4: char_data = 8'b00000000;
                    3'd5: char_data = 8'b00000000;
                    3'd6: char_data = 8'b00000000;
                    3'd7: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd10: begin // 'B'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b11111100;
                    3'd1: char_data = 8'b11000110;
                    3'd2: char_data = 8'b11000110;
                    3'd3: char_data = 8'b11111100;
                    3'd4: char_data = 8'b11111100;
                    3'd5: char_data = 8'b11000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b11111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd11: begin // 'u'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b00000000;
                    3'd3: char_data = 8'b01100110;
                    3'd4: char_data = 8'b01100110;
                    3'd5: char_data = 8'b01100110;
                    3'd6: char_data = 8'b01100110;
                    3'd7: char_data = 8'b00111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd12: begin // 't'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00011000;
                    3'd1: char_data = 8'b00011000;
                    3'd2: char_data = 8'b01111110;
                    3'd3: char_data = 8'b00011000;
                    3'd4: char_data = 8'b00011000;
                    3'd5: char_data = 8'b00011000;
                    3'd6: char_data = 8'b00011000;
                    3'd7: char_data = 8'b00011110;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd13: begin // 't'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00011000;
                    3'd1: char_data = 8'b00011000;
                    3'd2: char_data = 8'b01111110;
                    3'd3: char_data = 8'b00011000;
                    3'd4: char_data = 8'b00011000;
                    3'd5: char_data = 8'b00011000;
                    3'd6: char_data = 8'b00011000;
                    3'd7: char_data = 8'b00011110;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd14: begin // 'o'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b11000110;
                    3'd4: char_data = 8'b11000110;
                    3'd5: char_data = 8'b11000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd15: begin // 'n'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b11000110;
                    3'd4: char_data = 8'b11000110;
                    3'd5: char_data = 8'b11000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b11000110;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd16: begin // ' ' (space)
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b00000000;
                    3'd3: char_data = 8'b00000000;
                    3'd4: char_data = 8'b00000000;
                    3'd5: char_data = 8'b00000000;
                    3'd6: char_data = 8'b00000000;
                    3'd7: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd17: begin // 't'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00011000;
                    3'd1: char_data = 8'b00011000;
                    3'd2: char_data = 8'b01111110;
                    3'd3: char_data = 8'b00011000;
                    3'd4: char_data = 8'b00011000;
                    3'd5: char_data = 8'b00011000;
                    3'd6: char_data = 8'b00011000;
                    3'd7: char_data = 8'b00011110;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd18: begin // 'o'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b11000110;
                    3'd4: char_data = 8'b11000110;
                    3'd5: char_data = 8'b11000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd19: begin // ' ' (space)
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b00000000;
                    3'd3: char_data = 8'b00000000;
                    3'd4: char_data = 8'b00000000;
                    3'd5: char_data = 8'b00000000;
                    3'd6: char_data = 8'b00000000;
                    3'd7: char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd20: begin // 'S'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b01111110;
                    3'd1: char_data = 8'b11000000;
                    3'd2: char_data = 8'b11000000;
                    3'd3: char_data = 8'b01111100;
                    3'd4: char_data = 8'b00000110;
                    3'd5: char_data = 8'b00000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd21: begin // 't'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00011000;
                    3'd1: char_data = 8'b00011000;
                    3'd2: char_data = 8'b01111110;
                    3'd3: char_data = 8'b00011000;
                    3'd4: char_data = 8'b00011000;
                    3'd5: char_data = 8'b00011000;
                    3'd6: char_data = 8'b00011000;
                    3'd7: char_data = 8'b00011110;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd22: begin // 'a'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b00000110;
                    3'd4: char_data = 8'b01111110;
                    3'd5: char_data = 8'b11000110;
                    3'd6: char_data = 8'b11000110;
                    3'd7: char_data = 8'b01111110;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd23: begin // 'r'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00000000;
                    3'd1: char_data = 8'b00000000;
                    3'd2: char_data = 8'b01111100;
                    3'd3: char_data = 8'b11000110;
                    3'd4: char_data = 8'b11000000;
                    3'd5: char_data = 8'b11000000;
                    3'd6: char_data = 8'b11000000;
                    3'd7: char_data = 8'b11000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            5'd24: begin // 't'
                case (pixel_in_char_y[3:1])
                    3'd0: char_data = 8'b00011000;
                    3'd1: char_data = 8'b00011000;
                    3'd2: char_data = 8'b01111110;
                    3'd3: char_data = 8'b00011000;
                    3'd4: char_data = 8'b00011000;
                    3'd5: char_data = 8'b00011000;
                    3'd6: char_data = 8'b00011000;
                    3'd7: char_data = 8'b00011110;
                    default: char_data = 8'b00000000;
                endcase
            end
            default: char_data = 8'b00000000;
        endcase
    end
    
    // Determine if we're in the text area and output appropriate color
    wire in_text_area = (pixel_x >= START_X) && (pixel_x < START_X + TEXT_WIDTH) &&
                       (pixel_y >= START_Y) && (pixel_y < START_Y + CHAR_HEIGHT);
    
    always @(posedge clock) begin
        if (reset) begin
            color_out <= 8'b00000000;
        end
        else begin
            if (in_text_area && char_pixel) begin
                color_out <= TEXT_COLOR;  // White text
            end
            else begin
                color_out <= bg_color;    // Use background color
            end
        end
    end

endmodule