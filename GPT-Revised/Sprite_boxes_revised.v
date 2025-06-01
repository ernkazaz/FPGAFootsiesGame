//=========================================================
// Sprite_boxes (computes hitbox/hurtbox based on state)
//=========================================================
module Sprite_boxes #(
    parameter IS_MIRRORED = 0
)(
    input      [3:0] state,
    input      [9:0] sprite_x,
    input      [9:0] sprite_y,
    output reg [9:0] hitbox_x1,
    output reg [9:0] hitbox_x2,
    output reg [9:0] hitbox_y1,
    output reg [9:0] hitbox_y2,
    output reg [9:0] hurtbox_x1,
    output reg [9:0] hurtbox_x2,
    output reg [9:0] hurtbox_y1,
    output reg [9:0] hurtbox_y2,
    output reg       hitbox_active,
    output reg       hurtbox_active
);

    localparam [3:0]
        S_Attack_active    = 4'd4,
        S_Attack_recovery  = 4'd5,
        S_DirAtk_active    = 4'd7,
        S_DirAtk_recovery  = 4'd8;

    localparam integer SPRITE_WIDTH        = 64;
    localparam integer SPRITE_HEIGHT       = 128;
    localparam integer HURTBOX_MARGIN      = 10;
    localparam integer RECOVERY_MARGIN     = 5;

    localparam integer HITBOX_WIDTH_BASIC  = 30;
    localparam integer HITBOX_HEIGHT_BASIC = 60;
    localparam integer HITBOX_WIDTH_DIR    = 40;
    localparam integer HITBOX_HEIGHT_DIR   = 48;

    always @(*) begin
        // By default, hurtbox exists, hitbox is inactive
        hurtbox_active = 1'b1;
        hitbox_active  = 1'b0;

        // Stretch the hurtbox-wide during recovery (slightly smaller horizontally)
        case (state)
            S_Attack_recovery,
            S_DirAtk_recovery: begin
                hurtbox_x1 = sprite_x + RECOVERY_MARGIN;
                hurtbox_x2 = sprite_x + SPRITE_WIDTH - RECOVERY_MARGIN;
            end

            default: begin
                hurtbox_x1 = sprite_x + HURTBOX_MARGIN;
                hurtbox_x2 = sprite_x + SPRITE_WIDTH - HURTBOX_MARGIN;
            end
        endcase

        hurtbox_y1 = sprite_y;
        hurtbox_y2 = sprite_y + SPRITE_HEIGHT;

        // Only activate & define hitbox when in active‐frames of attack
        case (state)
            S_Attack_active: begin
                hitbox_active = 1'b1;
                if (IS_MIRRORED) begin
                    hitbox_x2 = sprite_x;
                    hitbox_x1 = sprite_x - HITBOX_WIDTH_BASIC;
                end else begin
                    hitbox_x1 = sprite_x + SPRITE_WIDTH;
                    hitbox_x2 = hitbox_x1 + HITBOX_WIDTH_BASIC;
                end
                hitbox_y1 = sprite_y + (SPRITE_HEIGHT - HITBOX_HEIGHT_BASIC) / 2;
                hitbox_y2 = hitbox_y1 + HITBOX_HEIGHT_BASIC;
            end

            S_DirAtk_active: begin
                hitbox_active = 1'b1;
                if (IS_MIRRORED) begin
                    hitbox_x2 = sprite_x;
                    hitbox_x1 = sprite_x - HITBOX_WIDTH_DIR;
                end else begin
                    hitbox_x1 = sprite_x + SPRITE_WIDTH;
                    hitbox_x2 = hitbox_x1 + HITBOX_WIDTH_DIR;
                end
                hitbox_y1 = sprite_y + (SPRITE_HEIGHT - HITBOX_HEIGHT_DIR) / 2;
                hitbox_y2 = hitbox_y1 + HITBOX_HEIGHT_DIR;
            end

            default: begin
                hitbox_x1 = 0;
                hitbox_x2 = 0;
                hitbox_y1 = 0;
                hitbox_y2 = 0;
                hitbox_active = 1'b0;
            end
        endcase
    end
endmodule
