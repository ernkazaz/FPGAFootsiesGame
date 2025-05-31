module Sprite_renderer #(
    parameter IS_MIRRORED = 0
)(
    input clk,
    input [2:0] state,
    output reg [9:0] sprite_x,
    output reg [9:0] sprite_y,
    output reg [7:0] sprite_color
);

    localparam [2:0] 
        S_IDLE = 3'd0,
        S_Backward = 3'd1,
        S_Forward = 3'd2,
        S_Attack_start = 3'd3,
        S_Attack_active = 3'd4,
        S_Attack_recovery = 3'd5;

    localparam SCREEN_WIDTH = 640;
    localparam SPRITE_WIDTH = 64;

    initial begin
        sprite_x = IS_MIRRORED ? 640 - 100 - SPRITE_WIDTH : 100;
        sprite_y = 100;
        sprite_color = 8'hFF;
    end

    always @(posedge clk) begin
        case(state)
            S_IDLE: sprite_x <= sprite_x;

            S_Forward:
                if (IS_MIRRORED) begin
                    if (sprite_x > 3)
                        sprite_x <= sprite_x - 3;  // mirrored forward = left
                end else begin
                    if (sprite_x < (SCREEN_WIDTH - SPRITE_WIDTH - 2))
                        sprite_x <= sprite_x + 3;
                end

            S_Backward:
                if (IS_MIRRORED) begin
                    if (sprite_x < (SCREEN_WIDTH - SPRITE_WIDTH - 2))
                        sprite_x <= sprite_x + 2;
                end else begin
                    if (sprite_x > 3)
                        sprite_x <= sprite_x - 2;
                end

            default: sprite_x <= sprite_x;
        endcase

        sprite_y <= 100;

        case (state)
            S_IDLE,
            S_Forward,
            S_Backward: sprite_color <= 8'h03;  // Blue
            S_Attack_start: sprite_color <= 8'hE0; // Red
            S_Attack_active: sprite_color <= 8'hFC; // Yellow
            S_Attack_recovery: sprite_color <= 8'h1F; // Cyan
            default: sprite_color <= 8'hFF;
        endcase
    end

endmodule
