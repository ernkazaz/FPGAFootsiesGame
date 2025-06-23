
module Sprite_renderer #(
    parameter IS_MIRRORED = 0
)(
    input        clk,
    input  [3:0] state,
    input  [9:0] pixel_x,
    input  [9:0] pixel_y,
	 input  [9:0] opponent_x,
    output reg [9:0] sprite_x,
    output reg [9:0] sprite_y,
    output reg [7:0] sprite_color    // Can be removed, if changing state colors are unnecessary.
    //output wire      inside_bandana
);

    localparam [3:0] 
        S_IDLE             = 4'd0,
        S_Backward         = 4'd1,
        S_Forward          = 4'd2,
        S_Attack_start     = 4'd3,
        S_Attack_active    = 4'd4,
        S_Attack_recovery  = 4'd5,
        S_DirAtk_start     = 4'd6,
        S_DirAtk_active    = 4'd7,
        S_DirAtk_recovery  = 4'd8,
        S_Hitstun          = 4'd9,
        S_Blockstun        = 4'd10;

    localparam integer SCREEN_WIDTH = 640;
    localparam integer SPRITE_WIDTH = 64;
    localparam integer SPRITE_HEIGHT= 240;

    initial begin
        sprite_x    = IS_MIRRORED ? (SCREEN_WIDTH - 100 - SPRITE_WIDTH) : 100;
        sprite_y    = 180;
        sprite_color= 8'hFF; // (unused if VGA is drawn by higher-level color_out)
    end

    always @(posedge clk) begin
        case(state)
            S_Forward: begin
                if (IS_MIRRORED) begin
                    if ((sprite_x - 3) >= (opponent_x + SPRITE_WIDTH)) begin
                        sprite_x <= sprite_x - 3;
                    end else begin
                        sprite_x <= sprite_x; 
                    end
                end else begin
                    if ((sprite_x + SPRITE_WIDTH - 1 + 3) < opponent_x) begin
                        sprite_x <= sprite_x + 3;
                    end else begin
                        sprite_x <= sprite_x; 
                    end
                end
            end

            S_Backward: begin
                if (IS_MIRRORED) begin
                    if (sprite_x < (SCREEN_WIDTH - SPRITE_WIDTH - 2))
                        sprite_x <= sprite_x + 2;
                    else
                        sprite_x <= sprite_x;
                end else begin
                    if (sprite_x > 3)
                        sprite_x <= sprite_x - 2;
                    else
                        sprite_x <= sprite_x;
                end
            end

            default: begin
                sprite_x <= sprite_x;
            end
        endcase

        sprite_y <= 180;
    end

    always @(*) begin
        case (state)
            S_IDLE,
            S_Forward,
            S_Backward:        sprite_color = 8'h00; // Black
            S_Attack_start, 
            S_DirAtk_start:    sprite_color = 8'hFC; // Yellow
            S_Attack_active,
            S_DirAtk_active:   sprite_color = 8'hE0; // Red
            S_Attack_recovery,
            S_DirAtk_recovery: sprite_color = 8'h1C; // Green
            S_Hitstun:         sprite_color = 8'h88; // Purple
            S_Blockstun:       sprite_color = 8'h0F; // Pink/Light-Blue
            default:           sprite_color = 8'hFF; // White / fallback
        endcase
    end

    // Bandana overlay: a 10-pixel‐high stripe near the top of the sprite
   // assign inside_bandana = (pixel_x >= sprite_x) && (pixel_x < sprite_x + SPRITE_WIDTH) &&
   //                         (pixel_y >= sprite_y + 10) && (pixel_y < sprite_y + 20);

endmodule
