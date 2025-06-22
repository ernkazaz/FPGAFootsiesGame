module Collision_logic(
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
    input  [9:0] target_recovery_hurtbox_x1,      
    input  [9:0] target_recovery_hurtbox_x2,
    input  [9:0] target_recovery_hurtbox_y1,
    input  [9:0] target_recovery_hurtbox_y2,
    input        target_recovery_hurtbox_active,
  
    output reg   got_hit_target,
    output reg   got_blocked_target
);

    // More robust collision detection with explicit boundary checks
    wire x_overlap_normal = (attacker_hitbox_x1 <= target_hurtbox_x2) &&
                            (attacker_hitbox_x2 >= target_hurtbox_x1);
    wire y_overlap_normal = (attacker_hitbox_y1 <= target_hurtbox_y2) &&
                            (attacker_hitbox_y2 >= target_hurtbox_y1);
    
    wire x_overlap_recovery = (attacker_hitbox_x1 <= target_recovery_hurtbox_x2) &&
                             (attacker_hitbox_x2 >= target_recovery_hurtbox_x1);
    wire y_overlap_recovery = (attacker_hitbox_y1 <= target_recovery_hurtbox_y2) &&
                             (attacker_hitbox_y2 >= target_recovery_hurtbox_y1);
   
    // Collision conditions with additional validation
    wire valid_attack = (attacker_hitbox_active && attacker_attack_flag) || (attacker_hitbox_active && attacker_diratk_flag) ;
    wire hit_normal = valid_attack && target_hurtbox_active &&
                      x_overlap_normal && y_overlap_normal;
    wire hit_recovery = valid_attack && target_recovery_hurtbox_active &&
                        x_overlap_recovery && y_overlap_recovery;
    
    wire hit_detected = hit_normal || hit_recovery;
    
    // Priority encoding to prevent conflicts
    always @(*) begin
        // Default values
        got_hit_target = 1'b0;
        got_blocked_target = 1'b0;
        
        // Only process if we have a valid hit
        if (hit_detected) begin
            if (target_is_blocking) begin
                got_blocked_target = 1'b1;
            end else begin
                got_hit_target = 1'b1;
            end
        end
    end

endmodule