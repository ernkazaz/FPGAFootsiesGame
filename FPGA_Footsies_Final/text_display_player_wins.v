module text_display_player_wins (
    input wire clock,
    input wire reset,
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [7:0] bg_color,    // Background color from background module
    input wire player_select,     // 0 = Player 1 wins, 1 = Player 2 wins
    output reg [7:0] color_out    // Final color output
);

    // Text parameters
    parameter [9:0] CHAR_WIDTH = 10'd16;  // Character width in pixels (doubled)
    parameter [9:0] CHAR_HEIGHT = 10'd32; // Character height in pixels (doubled)
    parameter [9:0] TEXT_LENGTH = 10'd13; // "PLAYER X WINS" = 13 characters (including spaces)
    
    // Screen center calculations (positioned below GAME OVER)
    parameter [9:0] SCREEN_WIDTH = 10'd640;
    parameter [9:0] SCREEN_HEIGHT = 10'd480;
    parameter [9:0] TEXT_WIDTH = TEXT_LENGTH * CHAR_WIDTH;  // Total text width
    parameter [9:0] START_X = (SCREEN_WIDTH - TEXT_WIDTH) / 2;  // Center horizontally
    parameter [9:0] START_Y = (SCREEN_HEIGHT / 2) + 10'd40;    // Below center (below GAME OVER)
    
    // Colors
    parameter [7:0] PLAYER1_COLOR = 8'b00011100;  // Green for Player 1 (RRRGGGBB)
    parameter [7:0] PLAYER2_COLOR = 8'b00000011;  // Blue for Player 2 (RRRGGGBB)
    parameter [7:0] TRANSPARENT = 8'b00000000;    // Transparent (use background)
    
    // Character position within text
    wire [9:0] char_x = (pixel_x >= START_X) ? (pixel_x - START_X) : 10'd0;
    wire [9:0] char_y = (pixel_y >= START_Y) ? (pixel_y - START_Y) : 10'd0;
    wire [3:0] char_index = char_x / CHAR_WIDTH;  // Which character (0-12)
    wire [3:0] pixel_in_char_x = (char_x % CHAR_WIDTH) / 2;  // X position within character (0-7), scaled down
    wire [4:0] pixel_in_char_y = (char_y % CHAR_HEIGHT) / 2; // Y position within character (0-15), scaled down
    
    // Character ROM data - simple 8x16 bitmap font
    reg [7:0] char_data;
    wire char_pixel = char_data[7 - pixel_in_char_x[2:0]];  // Extract pixel from character data
    
    // Text: "PLAYER X WINS" (X changes based on player_select)
    always @(*) begin
        case (char_index)
            4'd0: begin // 'P'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11111100;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b11000110;
                    4'd3:  char_data = 8'b11111100;
                    4'd4:  char_data = 8'b11000000;
                    4'd5:  char_data = 8'b11000000;
                    4'd6:  char_data = 8'b11000000;
                    4'd7:  char_data = 8'b11000000;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd1: begin // 'L'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11000000;
                    4'd1:  char_data = 8'b11000000;
                    4'd2:  char_data = 8'b11000000;
                    4'd3:  char_data = 8'b11000000;
                    4'd4:  char_data = 8'b11000000;
                    4'd5:  char_data = 8'b11000000;
                    4'd6:  char_data = 8'b11000000;
                    4'd7:  char_data = 8'b11111110;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd2: begin // 'A'
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
            4'd3: begin // 'Y'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11000110;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b01101100;
                    4'd3:  char_data = 8'b00111000;
                    4'd4:  char_data = 8'b00010000;
                    4'd5:  char_data = 8'b00010000;
                    4'd6:  char_data = 8'b00010000;
                    4'd7:  char_data = 8'b00010000;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd4: begin // 'E'
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
            4'd5: begin // 'R'
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
            4'd6: begin // ' ' (Space)
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
            4'd7: begin // '1' or '2' based on player_select
                if (!player_select) begin // Player 1
                    case (pixel_in_char_y[3:0])
                        4'd0:  char_data = 8'b00110000;
                        4'd1:  char_data = 8'b01110000;
                        4'd2:  char_data = 8'b00110000;
                        4'd3:  char_data = 8'b00110000;
                        4'd4:  char_data = 8'b00110000;
                        4'd5:  char_data = 8'b00110000;
                        4'd6:  char_data = 8'b00110000;
                        4'd7:  char_data = 8'b11111100;
                        default: char_data = 8'b00000000;
                    endcase
                end
                else begin // Player 2
                    case (pixel_in_char_y[3:0])
                        4'd0:  char_data = 8'b01111100;
                        4'd1:  char_data = 8'b11000110;
                        4'd2:  char_data = 8'b00000110;
                        4'd3:  char_data = 8'b00001100;
                        4'd4:  char_data = 8'b00011000;
                        4'd5:  char_data = 8'b00110000;
                        4'd6:  char_data = 8'b01100000;
                        4'd7:  char_data = 8'b11111110;
                        default: char_data = 8'b00000000;
                    endcase
                end
            end
            4'd8: begin // ' ' (Space)
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
            4'd9: begin // 'W'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11000110;
                    4'd1:  char_data = 8'b11000110;
                    4'd2:  char_data = 8'b11000110;
                    4'd3:  char_data = 8'b11010110;
                    4'd4:  char_data = 8'b11111110;
                    4'd5:  char_data = 8'b11101110;
                    4'd6:  char_data = 8'b11000110;
                    4'd7:  char_data = 8'b11000110;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd10: begin // 'I'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b01111100;
                    4'd1:  char_data = 8'b00011000;
                    4'd2:  char_data = 8'b00011000;
                    4'd3:  char_data = 8'b00011000;
                    4'd4:  char_data = 8'b00011000;
                    4'd5:  char_data = 8'b00011000;
                    4'd6:  char_data = 8'b00011000;
                    4'd7:  char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd11: begin // 'N'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b11000110;
                    4'd1:  char_data = 8'b11100110;
                    4'd2:  char_data = 8'b11110110;
                    4'd3:  char_data = 8'b11011110;
                    4'd4:  char_data = 8'b11001110;
                    4'd5:  char_data = 8'b11000110;
                    4'd6:  char_data = 8'b11000110;
                    4'd7:  char_data = 8'b11000110;
                    default: char_data = 8'b00000000;
                endcase
            end
            4'd12: begin // 'S'
                case (pixel_in_char_y[3:0])
                    4'd0:  char_data = 8'b01111110;
                    4'd1:  char_data = 8'b11000000;
                    4'd2:  char_data = 8'b11000000;
                    4'd3:  char_data = 8'b01111100;
                    4'd4:  char_data = 8'b00000110;
                    4'd5:  char_data = 8'b00000110;
                    4'd6:  char_data = 8'b11000110;
                    4'd7:  char_data = 8'b01111100;
                    default: char_data = 8'b00000000;
                endcase
            end
            default: char_data = 8'b00000000;
        endcase
    end
    
    // Determine if we're in the text area and output appropriate color
    wire in_text_area = (pixel_x >= START_X) && (pixel_x < START_X + TEXT_WIDTH) &&
                       (pixel_y >= START_Y) && (pixel_y < START_Y + CHAR_HEIGHT);
    
    // Select color based on player
    wire [7:0] selected_color = player_select ? PLAYER2_COLOR : PLAYER1_COLOR;
    
    always @(posedge clock) begin
        if (reset) begin
            color_out <= 8'b00000000;
        end
        else begin
            if (in_text_area && char_pixel) begin
                color_out <= selected_color;  // Player-specific color
            end
            else begin
                color_out <= bg_color;    // Use background color
            end
        end
    end

endmodule