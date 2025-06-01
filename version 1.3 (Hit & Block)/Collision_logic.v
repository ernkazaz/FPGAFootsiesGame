module Collision_logic (
    input [9:0] hitbox_x1_p1, hitbox_x2_p1, hitbox_y1_p1, hitbox_y2_p1,
    input       hitbox_active_p1,
    input       attack_flag_p1,
    input       dir_attack_flag_p1,

    input [9:0] hurtbox_x1_p2, hurtbox_x2_p2, hurtbox_y1_p2, hurtbox_y2_p2,
    input       hurtbox_active_p2,
    input       is_blocking_p2,

    output      got_hit_p2,
    output      got_blocked_p2
);

    wire overlapping = hitbox_active_p1 && hurtbox_active_p2 &&
        (hitbox_x1_p1 < hurtbox_x2_p2 && hitbox_x2_p1 > hurtbox_x1_p2) &&
        (hitbox_y1_p1 < hurtbox_y2_p2 && hitbox_y2_p1 > hurtbox_y1_p2);

    assign got_hit_p2 = overlapping && attack_flag_p1 && ~is_blocking_p2;
    assign got_blocked_p2 = overlapping && dir_attack_flag_p1 && is_blocking_p2;

endmodule
