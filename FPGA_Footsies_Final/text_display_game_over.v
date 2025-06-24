module text_display_game_over (
    input wire clock,
    input wire reset,
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [7:0] bg_color,    // Background color from background module
    output reg [7:0] color_out    // Final color output
);

    // Text parameters
    parameter [9:0] CHAR_WIDTH = 10'd16;  // Character width in pixels (doubled)
    parameter [9:0] CHAR_HEIGHT = 10'd32; // Character height in pixels (doubled)
    parameter [9:0] TEXT_LENGTH = 10'd9;  // "GAME OVER" = 9 characters (including space)
    
    // Screen center calculations (positioned in center)
    parameter [9:0] SCREEN_WIDTH = 10'd640;
    parameter [9:0] SCREEN_HEIGHT = 10'd480;
    parameter [9:0] TEXT_WIDTH = TEXT_LENGTH * CHAR_WIDTH;  // Total text width
    parameter [9:0] START_X = (SCREEN_WIDTH - TEXT_WIDTH) / 2;  // Center horizontally
    parameter [9:0] START_Y = (SCREEN_HEIGHT - CHAR_HEIGHT) / 2; // Center vertically
    
    // Colors
    parameter [7:0] TEXT_COLOR = 8'b00000000;  // Red text (RRRGGGBB)
    parameter [7:0] TRANSPARENT = 8'b00000000; // Transparent (use background)
    
    // Character position within text
    wire [9:0] char_x = (pixel_x >= START_X) ? (pixel_x - START_X) : 10'd0;
    wire [9:0] char_y = (pixel_y >= START_Y) ? (pixel_y - START_Y) : 10'd0;
    wire [3:0] char_index = char_x / CHAR_WIDTH;  // Which character (0-8)
    wire [3:0] pixel_in_char_x = (char_x % CHAR_WIDTH) / 2;  // X position within character (0-7), scaled down
    wire [4:0] pixel_in_char_y = (char_y % CHAR_HEIGHT) / 2; // Y position within character (0-15), scaled down
    
    // Character ROM data - simple 8x16 bitmap font
    reg [7:0] char_data;
    wire char_pixel = char_data[7 - pixel_in_char_x[2:0]];  // Extract pixel from character data
    
    // Text: "GAME OVER"
    always @(*) begin
        case (char_index)
            4'd0: begin // 'G'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b01111100;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b11000000;
                    4'd3:  char_data = 8'b11000000;
                    4'd4:  char_data = 8'b11001110;
                    4'd5:  char_data = 8'b11000110;
                    4'd6:  char_data = 8'b11000110;
                    4'd7:  char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd1: begin // 'A'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b01111100;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b11000110;
                    4'd3:  char_data = 8'b11111110;
                    4'd4:  char_data = 8'b11000110;
                    4'd5:  char_data = 8'b11000110;
                    4'd6:  char_data = 8'b11000110;
                    4'd7:  char_data = 8'b11000110;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd2: begin // 'M'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11000110;
                    4'd1:  char_data = 8'b11101110;
                    4'd2:  char_data = 8'b11111110;
                    4'd3:  char_data = 8'b11010110;
                    4'd4:  char_data = 8'b11000110;
                    4'd5:  char_data = 8'b11000110;
                    4'd6:  char_data = 8'b11000110;
                    4'd7:  char_data = 8'b11000110;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd3: begin // 'E'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11111110;
                    4'd1:  char_data = 8'b11000000;
                    4'd2:  char_data = 8'b11000000;
                    4'd3:  char_data = 8'b11111100;
                    4'd4:  char_data = 8'b11000000;
                    4'd5:  char_data = 8'b11000000;
                    4'd6:  char_data = 8'b11000000;
                    4'd7:  char_data = 8'b11111110;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd4: begin // ' ' (Space)
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b00000000;
                    4'd1:  char_data = 8'b00000000;
                    4'd2:  char_data = 8'b00000000;
                    4'd3:  char_data = 8'b00000000;
                    4'd4:  char_data = 8'b00000000;
                    4'd5:  char_data = 8'b00000000;
                    4'd6:  char_data = 8'b00000000;
                    4'd7:  char_data = 8'b00000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd5: begin // 'O'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b01111100;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b11000110;
                    4'd3:  char_data = 8'b11000110;
                    4'd4:  char_data = 8'b11000110;
                    4'd5:  char_data = 8'b11000110;
                    4'd6:  char_data = 8'b11000110;
                    4'd7:  char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd6: begin // 'V'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11000110;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b11000110;
                    4'd3:  char_data = 8'b11000110;
                    4'd4:  char_data = 8'b11000110;
                    4'd5:  char_data = 8'b01101100;
                    4'd6:  char_data = 8'b00111000;
                    4'd7:  char_data = 8'b00010000;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd7: begin // 'E'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11111110;
                    4'd1:  char_data = 8'b11000000;
                    4'd2:  char_data = 8'b11000000;
                    4'd3:  char_data = 8'b11111100;
                    4'd4:  char_data = 8'b11000000;
                    4'd5:  char_data = 8'b11000000;
                    4'd6:  char_data = 8'b11000000;
                    4'd7:  char_data = 8'b11111110;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd8: begin // 'R'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11111100;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b11000110;
                    4'd3:  char_data = 8'b11111100;
                    4'd4:  char_data = 8'b11011000;
                    4'd5:  char_data = 8'b11001100;
                    4'd6:  char_data = 8'b11000110;
                    4'd7:  char_data = 8'b11000110;
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
                color_out <= TEXT_COLOR;
            end
            else begin
                color_out <= bg_color;    // Use background color
            end
        end
    end

endmodule