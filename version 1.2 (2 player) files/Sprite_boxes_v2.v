module Sprite_boxes #(
    parameter IS_MIRRORED = 0
)(
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

    localparam [2:0]
        S_Attack_active = 3'd4;

    localparam SPRITE_WIDTH = 64;
    localparam SPRITE_HEIGHT = 128;
    localparam HURTBOX_MARGIN = 10;
    localparam HITBOX_WIDTH = 30;
    localparam HITBOX_HEIGHT = 60;

    always @(*) begin
        // Hurtbox (always visible)
        hurtbox_x1 = sprite_x + HURTBOX_MARGIN;
        hurtbox_x2 = sprite_x + SPRITE_WIDTH - HURTBOX_MARGIN;
        hurtbox_y1 = sprite_y;
        hurtbox_y2 = sprite_y + SPRITE_HEIGHT;
        hurtbox_active = 1;

        if (state == S_Attack_active) begin
            if (IS_MIRRORED) begin
                hitbox_x2 = sprite_x;
                hitbox_x1 = sprite_x - HITBOX_WIDTH;
            end else begin
                hitbox_x1 = sprite_x + SPRITE_WIDTH;
                hitbox_x2 = hitbox_x1 + HITBOX_WIDTH;
            end
            hitbox_y1 = sprite_y + (SPRITE_HEIGHT - HITBOX_HEIGHT)/2;
            hitbox_y2 = hitbox_y1 + HITBOX_HEIGHT;
            hitbox_active = 1;
        end else begin
            hitbox_x1 = 0;
            hitbox_x2 = 0;
            hitbox_y1 = 0;
            hitbox_y2 = 0;
            hitbox_active = 0;
        end
    end
endmodule
