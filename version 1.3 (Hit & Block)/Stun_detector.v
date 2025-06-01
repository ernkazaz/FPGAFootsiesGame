module Stun_detector(
    input [9:0] hitbox_x1, hitbox_x2, hitbox_y1, hitbox_y2,
    input hitbox_active,
    input [9:0] opponent_hurtbox_x1, opponent_hurtbox_x2,
    input [9:0] opponent_hurtbox_y1, opponent_hurtbox_y2,
    input hurtbox_active,
    input is_blocking,
    output reg got_hit,
    output reg got_blocked
);

    wire overlapping = hitbox_active && hurtbox_active &&
                       (hitbox_x2 > opponent_hurtbox_x1 && hitbox_x1 < opponent_hurtbox_x2) &&
                       (hitbox_y2 > opponent_hurtbox_y1 && hitbox_y1 < opponent_hurtbox_y2);

    always @(*) begin
        if (overlapping) begin
            if (is_blocking) begin
                got_hit = 0;
                got_blocked = 1;
            end else begin
                got_hit = 1;
                got_blocked = 0;
            end
        end else begin
            got_hit = 0;
            got_blocked = 0;
        end
    end

endmodule
