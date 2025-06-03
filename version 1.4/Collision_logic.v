module Collision_logic (
    input  [9:0] attacker_hitbox_x1,
    input  [9:0] attacker_hitbox_x2,
    input  [9:0] attacker_hitbox_y1,
    input  [9:0] attacker_hitbox_y2,
    input        attacker_hitbox_active,
    input        attacker_attack_flag,
    input        attacker_diratk_flag,

    input  [9:0] target_hurtbox_x1,
    input  [9:0] target_hurtbox_x2,
    input  [9:0] target_hurtbox_y1,
    input  [9:0] target_hurtbox_y2,
    input        target_hurtbox_active,
    input        target_is_blocking,

    output reg   got_hit_target,
    output reg   got_blocked_target
);

    wire x_overlap = (attacker_hitbox_x1 < target_hurtbox_x2) &&
                     (attacker_hitbox_x2 > target_hurtbox_x1);
    wire y_overlap = (attacker_hitbox_y1 < target_hurtbox_y2) &&
                     (attacker_hitbox_y2 > target_hurtbox_y1);
    wire hit_detected = attacker_hitbox_active && target_hurtbox_active &&
                        attacker_attack_flag && x_overlap && y_overlap;

    always @(*) begin
        if (hit_detected) begin
            if (target_is_blocking) begin
                got_hit_target     = 1'b0;
                got_blocked_target = 1'b1;
            end else begin
                got_hit_target     = 1'b1;
                got_blocked_target = 1'b0;
            end
        end else begin
            got_hit_target     = 1'b0;
            got_blocked_target = 1'b0;
        end
    end
endmodule
