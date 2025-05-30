module Sprite_renderer(
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

    // Initialization (optional but helpful)
    initial begin
        sprite_x = 100;
        sprite_y = 100;
        sprite_color = 8'hFF;
    end

   always @(posedge clk) begin
    case(state)
        S_IDLE: begin
            sprite_x <= sprite_x; // hold position
        end 
			S_Forward: begin
				 if (sprite_x < (640 - 66))
					  sprite_x <= sprite_x + 3;
			end

        S_Backward: begin
            if (sprite_x > 3)
                sprite_x <= sprite_x - 2;
        end
        default: begin
            sprite_x <= sprite_x;
        end
    endcase

    // Set fixed y
    sprite_y <= 100;

    // Set color based on state
    case (state)
        S_IDLE,
        S_Forward,
        S_Backward: sprite_color <= 8'h03;  // Blue
        S_Attack_start: sprite_color <= 8'hE0; // Red
        S_Attack_active: sprite_color <= 8'hFC; // Yellow
        S_Attack_recovery: sprite_color <= 8'h1F; // Cyan
        default: sprite_color <= 8'hFF; // White / off
    endcase
end

endmodule 
