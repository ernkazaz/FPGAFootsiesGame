// Module to generate pixel data for a single digit (0-9)
module digit_display (
    input [3:0] digit,      // 0-9
    input [9:0] pixel_x,    // Current pixel x coordinate
    input [9:0] pixel_y,    // Current pixel y coordinate
    input [9:0] digit_x,    // Top-left x coordinate of digit
    input [9:0] digit_y,    // Top-left y coordinate of digit
    output reg pixel_on     // 1 if pixel should be on for this digit
);

    // Digit is 8x12 pixels
    parameter DIGIT_WIDTH = 8;
    parameter DIGIT_HEIGHT = 12;
    
    // Check if current pixel is within digit bounds
    wire in_digit_x = (pixel_x >= digit_x) && (pixel_x < digit_x + DIGIT_WIDTH);
    wire in_digit_y = (pixel_y >= digit_y) && (pixel_y < digit_y + DIGIT_HEIGHT);
    wire in_digit = in_digit_x && in_digit_y;
    
    // Relative position within digit
    wire [2:0] rel_x = pixel_x - digit_x;
    wire [3:0] rel_y = pixel_y - digit_y;
    
    // Digit patterns (8x12 bitmap for each digit)
    always @(*) begin
        pixel_on = 0;
        if (in_digit) begin
            case (digit)
                4'd0: begin // Digit 0
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd1:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd2:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd3:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd4:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd5:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd6:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd7:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd8:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd9:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd10: pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd11: pixel_on = (rel_x >= 1 && rel_x <= 6);
                        default: pixel_on = 0;
                    endcase
                end
                4'd1: begin // Digit 1
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x >= 2 && rel_x <= 4);
                        4'd1:  pixel_on = (rel_x == 1 || rel_x == 3);
                        4'd2:  pixel_on = (rel_x == 3);
                        4'd3:  pixel_on = (rel_x == 3);
                        4'd4:  pixel_on = (rel_x == 3);
                        4'd5:  pixel_on = (rel_x == 3);
                        4'd6:  pixel_on = (rel_x == 3);
                        4'd7:  pixel_on = (rel_x == 3);
                        4'd8:  pixel_on = (rel_x == 3);
                        4'd9:  pixel_on = (rel_x == 3);
                        4'd10: pixel_on = (rel_x == 3);
                        4'd11: pixel_on = (rel_x >= 0 && rel_x <= 7);
                        default: pixel_on = 0;
                    endcase
                end
                4'd2: begin // Digit 2
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd1:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd2:  pixel_on = (rel_x == 7);
                        4'd3:  pixel_on = (rel_x == 7);
                        4'd4:  pixel_on = (rel_x == 6);
                        4'd5:  pixel_on = (rel_x >= 3 && rel_x <= 5);
                        4'd6:  pixel_on = (rel_x >= 1 && rel_x <= 2);
                        4'd7:  pixel_on = (rel_x == 0);
                        4'd8:  pixel_on = (rel_x == 0);
                        4'd9:  pixel_on = (rel_x == 0);
                        4'd10: pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd11: pixel_on = (rel_x >= 1 && rel_x <= 6);
                        default: pixel_on = 0;
                    endcase
                end
                4'd3: begin // Digit 3
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd1:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd2:  pixel_on = (rel_x == 7);
                        4'd3:  pixel_on = (rel_x == 7);
                        4'd4:  pixel_on = (rel_x == 6);
                        4'd5:  pixel_on = (rel_x >= 2 && rel_x <= 5);
                        4'd6:  pixel_on = (rel_x == 6);
                        4'd7:  pixel_on = (rel_x == 7);
                        4'd8:  pixel_on = (rel_x == 7);
                        4'd9:  pixel_on = (rel_x == 7);
                        4'd10: pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd11: pixel_on = (rel_x >= 1 && rel_x <= 6);
                        default: pixel_on = 0;
                    endcase
                end
                4'd4: begin // Digit 4
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x == 0 || rel_x == 6);
                        4'd1:  pixel_on = (rel_x == 0 || rel_x == 6);
                        4'd2:  pixel_on = (rel_x == 0 || rel_x == 6);
                        4'd3:  pixel_on = (rel_x == 0 || rel_x == 6);
                        4'd4:  pixel_on = (rel_x == 0 || rel_x == 6);
                        4'd5:  pixel_on = (rel_x >= 1 && rel_x <= 7);
                        4'd6:  pixel_on = (rel_x == 6);
                        4'd7:  pixel_on = (rel_x == 6);
                        4'd8:  pixel_on = (rel_x == 6);
                        4'd9:  pixel_on = (rel_x == 6);
                        4'd10: pixel_on = (rel_x == 6);
                        4'd11: pixel_on = (rel_x == 6);
                        default: pixel_on = 0;
                    endcase
                end
                4'd5: begin // Digit 5
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd1:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd2:  pixel_on = (rel_x == 0);
                        4'd3:  pixel_on = (rel_x == 0);
                        4'd4:  pixel_on = (rel_x == 0);
                        4'd5:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd6:  pixel_on = (rel_x == 7);
                        4'd7:  pixel_on = (rel_x == 7);
                        4'd8:  pixel_on = (rel_x == 7);
                        4'd9:  pixel_on = (rel_x == 7);
                        4'd10: pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd11: pixel_on = (rel_x >= 1 && rel_x <= 6);
                        default: pixel_on = 0;
                    endcase
                end
                4'd6: begin // Digit 6
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd1:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd2:  pixel_on = (rel_x == 0);
                        4'd3:  pixel_on = (rel_x == 0);
                        4'd4:  pixel_on = (rel_x == 0);
                        4'd5:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd6:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd7:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd8:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd9:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd10: pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd11: pixel_on = (rel_x >= 1 && rel_x <= 6);
                        default: pixel_on = 0;
                    endcase
                end
                4'd7: begin // Digit 7
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd1:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd2:  pixel_on = (rel_x == 7);
                        4'd3:  pixel_on = (rel_x == 6);
                        4'd4:  pixel_on = (rel_x == 5);
                        4'd5:  pixel_on = (rel_x == 4);
                        4'd6:  pixel_on = (rel_x == 3);
                        4'd7:  pixel_on = (rel_x == 3);
                        4'd8:  pixel_on = (rel_x == 3);
                        4'd9:  pixel_on = (rel_x == 3);
                        4'd10: pixel_on = (rel_x == 3);
                        4'd11: pixel_on = (rel_x == 3);
                        default: pixel_on = 0;
                    endcase
                end
                4'd8: begin // Digit 8
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd1:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd2:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd3:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd4:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd5:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd6:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd7:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd8:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd9:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd10: pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd11: pixel_on = (rel_x >= 1 && rel_x <= 6);
                        default: pixel_on = 0;
                    endcase
                end
                4'd9: begin // Digit 9
                    case (rel_y)
                        4'd0:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd1:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd2:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd3:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd4:  pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd5:  pixel_on = (rel_x >= 1 && rel_x <= 6);
                        4'd6:  pixel_on = (rel_x == 7);
                        4'd7:  pixel_on = (rel_x == 7);
                        4'd8:  pixel_on = (rel_x == 7);
                        4'd9:  pixel_on = (rel_x == 7);
                        4'd10: pixel_on = (rel_x == 0 || rel_x == 7);
                        4'd11: pixel_on = (rel_x >= 1 && rel_x <= 6);
                        default: pixel_on = 0;
                    endcase
                end
                default: pixel_on = 0;
            endcase
        end
    end
endmodule


