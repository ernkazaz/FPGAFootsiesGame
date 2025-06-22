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
    output reg [9:0] hurtbox_rec_x1,
    output reg [9:0] hurtbox_rec_x2,
    output reg [9:0] hurtbox_rec_y1,
    output reg [9:0] hurtbox_rec_y2,
    output reg [9:0] visible_box_x1,
    output reg [9:0] visible_box_x2,
    output reg [9:0] visible_box_y1,
    output reg [9:0] visible_box_y2,
    output reg       hitbox_active,
    output reg       hurtbox_active,
    output reg       recovery_hurtbox_active,
    output reg       visible_box_active
);

    localparam [3:0]
        S_Attack_active    = 4'd4,
        S_Attack_recovery  = 4'd5,
        S_DirAtk_active    = 4'd7,
        S_DirAtk_recovery  = 4'd8;

    localparam integer SPRITE_WIDTH           = 64;
    localparam integer SPRITE_HEIGHT          = 240;
     
    localparam integer HURTBOX_MARGIN         = 3;
    localparam integer HURTBOX_REC_WIDTH      = 50;
    localparam integer HURTBOX_REC_HEIGHT     = 45;
    localparam integer HURTBOX_DIR_REC_WIDTH  = 35;
    localparam integer HURTBOX_DIR_REC_HEIGHT = 120;
     
    localparam integer HITBOX_WIDTH_BASIC     = 50;
    localparam integer HITBOX_HEIGHT_BASIC    = 45;
    localparam integer HITBOX_WIDTH_DIR       = 40;
    localparam integer HITBOX_HEIGHT_DIR      = 120;

    // Temporary variables for calculations
    reg [9:0] temp_hurtbox_x1, temp_hurtbox_x2;
    reg [9:0] temp_hitbox_x1, temp_hitbox_x2;

    always @(*) begin
        // Initialize all outputs to default values
        hitbox_x1 = 10'd0;
        hitbox_x2 = 10'd0;
        hitbox_y1 = 10'd0;
        hitbox_y2 = 10'd0;
        hurtbox_x1 = 10'd0;
        hurtbox_x2 = 10'd0;
        hurtbox_y1 = 10'd0;
        hurtbox_y2 = 10'd0;
        hurtbox_rec_x1 = 10'd0;
        hurtbox_rec_x2 = 10'd0;
        hurtbox_rec_y1 = 10'd0;
        hurtbox_rec_y2 = 10'd0;
        visible_box_x1 = 10'd0;
        visible_box_x2 = 10'd0;
        visible_box_y1 = 10'd0;
        visible_box_y2 = 10'd0;
        hitbox_active = 1'b0;
        hurtbox_active = 1'b0;
        recovery_hurtbox_active = 1'b0;
        visible_box_active = 1'b0;

        // Calculate common hurtbox coordinates
        temp_hurtbox_x1 = sprite_x + HURTBOX_MARGIN;
        temp_hurtbox_x2 = sprite_x + SPRITE_WIDTH - HURTBOX_MARGIN;

        // Main hurtbox is always active (except during recovery states)
        case (state)
            S_Attack_recovery, S_DirAtk_recovery: begin
                hurtbox_active = 1'b0;  // Main hurtbox disabled during recovery
            end
            default: begin
                hurtbox_active = 1'b1;  // Main hurtbox active in all other states
                hurtbox_x1 = temp_hurtbox_x1;
                hurtbox_x2 = temp_hurtbox_x2;
                hurtbox_y1 = sprite_y;
                hurtbox_y2 = sprite_y + SPRITE_HEIGHT;
            end
        endcase

        // State-specific logic
        case (state)
            S_Attack_active: begin
                hitbox_active = 1'b1;
                visible_box_active = 1'b1;
                
                if (IS_MIRRORED) begin
                    temp_hitbox_x1 = sprite_x - HITBOX_WIDTH_BASIC;
                    temp_hitbox_x2 = sprite_x;
                end else begin
                    temp_hitbox_x1 = sprite_x + SPRITE_WIDTH;
                    temp_hitbox_x2 = sprite_x + SPRITE_WIDTH + HITBOX_WIDTH_BASIC;
                end
                
                hitbox_x1 = temp_hitbox_x1;
                hitbox_x2 = temp_hitbox_x2;
                hitbox_y1 = sprite_y + (SPRITE_HEIGHT - HITBOX_HEIGHT_BASIC) / 2;
                hitbox_y2 = hitbox_y1 + HITBOX_HEIGHT_BASIC;
                
                visible_box_x1 = hitbox_x1;
                visible_box_x2 = hitbox_x2;
                visible_box_y1 = hitbox_y1;
                visible_box_y2 = hitbox_y2;
            end

            S_Attack_recovery: begin
                recovery_hurtbox_active = 1'b1;
                visible_box_active = 1'b1;
                
                if (IS_MIRRORED) begin
                    hurtbox_rec_x1 = temp_hurtbox_x1 - HURTBOX_REC_WIDTH;
                    hurtbox_rec_x2 = temp_hurtbox_x1;
                    visible_box_x1 = sprite_x - HITBOX_WIDTH_BASIC;
                    visible_box_x2 = sprite_x;
                end else begin
                    hurtbox_rec_x1 = temp_hurtbox_x2;
                    hurtbox_rec_x2 = temp_hurtbox_x2 + HURTBOX_REC_WIDTH;
                    visible_box_x1 = sprite_x + SPRITE_WIDTH;
                    visible_box_x2 = sprite_x + SPRITE_WIDTH + HITBOX_WIDTH_BASIC;
                end
                
                hurtbox_rec_y1 = sprite_y + (SPRITE_HEIGHT - HURTBOX_REC_HEIGHT) / 2;
                hurtbox_rec_y2 = hurtbox_rec_y1 + HURTBOX_REC_HEIGHT;
                visible_box_y1 = hurtbox_rec_y1;
                visible_box_y2 = hurtbox_rec_y2;
            end

            S_DirAtk_active: begin
                hitbox_active = 1'b1;
                visible_box_active = 1'b1;
                
                if (IS_MIRRORED) begin
                    temp_hitbox_x1 = sprite_x - HITBOX_WIDTH_DIR;
                    temp_hitbox_x2 = sprite_x;
                end else begin
                    temp_hitbox_x1 = sprite_x + SPRITE_WIDTH;
                    temp_hitbox_x2 = sprite_x + SPRITE_WIDTH + HITBOX_WIDTH_DIR;
                end
                
                hitbox_x1 = temp_hitbox_x1;
                hitbox_x2 = temp_hitbox_x2;
                hitbox_y1 = sprite_y + SPRITE_HEIGHT - HITBOX_HEIGHT_DIR;
                hitbox_y2 = sprite_y + SPRITE_HEIGHT;
                
                visible_box_x1 = hitbox_x1;
                visible_box_x2 = hitbox_x2;
                visible_box_y1 = hitbox_y1;
                visible_box_y2 = hitbox_y2;
            end

            S_DirAtk_recovery: begin
                recovery_hurtbox_active = 1'b1;
                visible_box_active = 1'b1;
                
                if (IS_MIRRORED) begin
                    hurtbox_rec_x1 = temp_hurtbox_x1 - HURTBOX_DIR_REC_WIDTH;
                    hurtbox_rec_x2 = temp_hurtbox_x1;
                    visible_box_x1 = sprite_x - HITBOX_WIDTH_DIR;
                    visible_box_x2 = sprite_x;
                end else begin
                    hurtbox_rec_x1 = temp_hurtbox_x2;
                    hurtbox_rec_x2 = temp_hurtbox_x2 + HURTBOX_DIR_REC_WIDTH;
                    visible_box_x1 = sprite_x + SPRITE_WIDTH;
                    visible_box_x2 = sprite_x + SPRITE_WIDTH + HITBOX_WIDTH_DIR;
                end
                
                hurtbox_rec_y1 = sprite_y + SPRITE_HEIGHT - HURTBOX_DIR_REC_HEIGHT;
                hurtbox_rec_y2 = sprite_y + SPRITE_HEIGHT;
                visible_box_y1 = hurtbox_rec_y1;
                visible_box_y2 = hurtbox_rec_y2;
            end

            default: begin
                // Default state - only main hurtbox active (already handled above)
                // All other boxes remain inactive with default values
            end
        endcase
    end
endmodule