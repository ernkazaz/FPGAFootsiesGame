module Sprite_Boxes (
    input [2:0] state,
    input [9:0] sprite_x,
    input [9:0] sprite_y,

    output reg [9:0] hitbox_x1, hitbox_x2,
    output reg [9:0] hitbox_y1, hitbox_y2,
    output reg [9:0] hurtbox_x1, hurtbox_x2,
    output reg [9:0] hurtbox_y1, hurtbox_y2,
    output reg hitbox_active,
    output reg hurtbox_active
);

    // Constants
    localparam [2:0]
        S_IDLE = 3'd0,
        S_Backward = 3'd1,
        S_Forward = 3'd2,
        S_Attack_start = 3'd3,
        S_Attack_active = 3'd4,
        S_Attack_recovery = 3'd5;

    localparam SPRITE_WIDTH = 64;
    localparam SPRITE_HEIGHT = 128;
    localparam HURTBOX_MARGIN = 10;
    localparam HITBOX_WIDTH = 30;
    localparam HITBOX_HEIGHT = 60;

    always @(*) begin
        // Hurtbox (always visible, centered in the sprite)
        hurtbox_x1 = sprite_x + HURTBOX_MARGIN;
        hurtbox_x2 = sprite_x + SPRITE_WIDTH - HURTBOX_MARGIN;
        hurtbox_y1 = sprite_y;
        hurtbox_y2 = sprite_y + SPRITE_HEIGHT;
        hurtbox_active = 1'b1;

        // Hitbox (only active during ATTACK_ACTIVE)
        if (state == S_Attack_active) begin
            hitbox_x1 = sprite_x + SPRITE_WIDTH;
            hitbox_x2 = hitbox_x1 + HITBOX_WIDTH;
            hitbox_y1 = sprite_y + (SPRITE_HEIGHT - HITBOX_HEIGHT)/2;
            hitbox_y2 = hitbox_y1 + HITBOX_HEIGHT;
            hitbox_active = 1'b1;
        end else begin
            hitbox_x1 = 0;
            hitbox_x2 = 0;
            hitbox_y1 = 0;
            hitbox_y2 = 0;
            hitbox_active = 1'b0;
        end
    end

endmodule
