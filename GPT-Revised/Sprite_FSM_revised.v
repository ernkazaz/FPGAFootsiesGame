//=========================================================
// Sprite_FSM (unchanged)
//=========================================================
module Sprite_FSM (
    input        clk,
    input        reset,
    input        left,
    input        right,
    input        attack,
    input        got_hit,
    input        got_blocked,
    output reg [3:0] state,
    output reg       move_flag,
    output reg       directional_attack_flag,
    output reg       basic_attack_flag
);

    localparam [3:0] 
        S_IDLE             = 4'd0,
        S_Backward         = 4'd1,
        S_Forward          = 4'd2,
        S_Attack_start     = 4'd3,
        S_Attack_active    = 4'd4,
        S_Attack_recovery  = 4'd5,
        S_DirAtk_start     = 4'd6,
        S_DirAtk_active    = 4'd7,
        S_DirAtk_recovery  = 4'd8,
        S_Hitstun          = 4'd9,
        S_Blockstun        = 4'd10;

    localparam integer ATTACK_START_FRAMES     = 5;
    localparam integer ATTACK_ACTIVE_FRAMES    = 2;
    localparam integer ATTACK_RECOVERY_FRAMES  = 16;

    localparam integer DIRATK_START_FRAMES     = 4;
    localparam integer DIRATK_ACTIVE_FRAMES    = 3;
    localparam integer DIRATK_RECOVERY_FRAMES  = 15;

    localparam integer HITSTUN_OFFSET          = 1;
    localparam integer BLOCKSTUN_OFFSET        = 3;

    reg [5:0] frame_counter;
    reg       diratk_stun_flag;

    always @(posedge clk) begin
        if (reset) begin
            state            <= S_IDLE;
            frame_counter    <= 0;
            diratk_stun_flag <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    frame_counter    <= 0;
                    diratk_stun_flag <= 0;

                    if (got_hit) begin
                        state            <= S_Hitstun;
                        diratk_stun_flag <= 0;
                    end else if (got_blocked) begin
                        state            <= S_Blockstun;
                        diratk_stun_flag <= 0;
                    end else if ((left ^ right) && attack) begin
                        state            <= S_DirAtk_start;
                        diratk_stun_flag <= 1;
                    end else if (attack && ~left && ~right) begin
                        state            <= S_Attack_start;
                        diratk_stun_flag <= 0;
                    end else if (left && ~right) begin
                        state            <= S_Backward;
                    end else if (right && ~left) begin
                        state            <= S_Forward;
                    end
                end

                S_Backward,
                S_Forward: begin
                    frame_counter    <= 0;
                    diratk_stun_flag <= 0;

                    if (got_hit) begin
                        state            <= S_Hitstun;
                        diratk_stun_flag <= 0;
                    end else if (got_blocked) begin
                        state            <= S_Blockstun;
                        diratk_stun_flag <= 0;
                    end else if ((left ^ right) && attack) begin
                        state            <= S_DirAtk_start;
                        diratk_stun_flag <= 1;
                    end else if (attack && ~left && ~right) begin
                        state            <= S_Attack_start;
                        diratk_stun_flag <= 0;
                    end else if (left && ~right) begin
                        state            <= S_Backward;
                    end else if (right && ~left) begin
                        state            <= S_Forward;
                    end else begin
                        state            <= S_IDLE;
                    end
                end

                S_Attack_start: begin
                    if (frame_counter >= ATTACK_START_FRAMES - 1) begin
                        state         <= S_Attack_active;
                        frame_counter <= 0;
                    end else
                        frame_counter <= frame_counter + 1;
                end

                S_Attack_active: begin
                    if (frame_counter >= ATTACK_ACTIVE_FRAMES - 1) begin
                        state         <= S_Attack_recovery;
                        frame_counter <= 0;
                    end else
                        frame_counter <= frame_counter + 1;
                end

                S_Attack_recovery: begin
                    if (frame_counter >= ATTACK_RECOVERY_FRAMES - 1) begin
                        state         <= S_IDLE;
                        frame_counter <= 0;
                    end else
                        frame_counter <= frame_counter + 1;
                end

                S_DirAtk_start: begin
                    if (frame_counter >= DIRATK_START_FRAMES - 1) begin
                        state         <= S_DirAtk_active;
                        frame_counter <= 0;
                    end else
                        frame_counter <= frame_counter + 1;
                end

                S_DirAtk_active: begin
                    if (frame_counter >= DIRATK_ACTIVE_FRAMES - 1) begin
                        state         <= S_DirAtk_recovery;
                        frame_counter <= 0;
                    end else
                        frame_counter <= frame_counter + 1;
                end

                S_DirAtk_recovery: begin
                    if (frame_counter >= DIRATK_RECOVERY_FRAMES - 1) begin
                        state         <= S_IDLE;
                        frame_counter <= 0;
                    end else
                        frame_counter <= frame_counter + 1;
                end

                S_Hitstun: begin
                    if (frame_counter >= ((diratk_stun_flag ? DIRATK_RECOVERY_FRAMES : ATTACK_RECOVERY_FRAMES) - HITSTUN_OFFSET - 1)) begin
                        state            <= S_IDLE;
                        frame_counter    <= 0;
                        diratk_stun_flag <= 0;
                    end else
                        frame_counter <= frame_counter + 1;
                end

                S_Blockstun: begin
                    if (frame_counter >= ((diratk_stun_flag ? DIRATK_RECOVERY_FRAMES : ATTACK_RECOVERY_FRAMES) - BLOCKSTUN_OFFSET - 1)) begin
                        state            <= S_IDLE;
                        frame_counter    <= 0;
                        diratk_stun_flag <= 0;
                    end else
                        frame_counter <= frame_counter + 1;
                end

                default: begin
                    state            <= S_IDLE;
                    frame_counter    <= 0;
                    diratk_stun_flag <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        move_flag               = 1'b0;
        basic_attack_flag       = 1'b0;
        directional_attack_flag = 1'b0;

        case (state)
            S_Backward,
            S_Forward: begin
                move_flag = 1'b1;
            end

            S_Attack_start,
            S_Attack_active: begin
                basic_attack_flag = 1'b1;
            end

            S_DirAtk_start,
            S_DirAtk_active: begin
                directional_attack_flag = 1'b1;
            end

            default: begin
                // No flags in IDM, recovery, hitstun, blockstun, or idle
                move_flag               = 1'b0;
                basic_attack_flag       = 1'b0;
                directional_attack_flag = 1'b0;
            end
        endcase
    end
endmodule
