module Sprite_FSM (
    input clk,
    input reset,
    input left,
    input right,
    input attack,
    output reg [2:0] state,
    output reg move_flag,
    output reg directional_attack_flag,
    output reg attack_flag
);

    localparam [2:0] 
        S_IDLE = 3'd0,
        S_Backward = 3'd1,
        S_Forward = 3'd2,
        S_Attack_start = 3'd3,
        S_Attack_active = 3'd4,
        S_Attack_recovery = 3'd5;

    localparam ATTACK_START_FRAMES = 5;
    localparam ATTACK_ACTIVE_FRAMES = 2;
    localparam ATTACK_RECOVERY_FRAMES = 16;

    reg [5:0] frame_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            frame_counter <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    frame_counter <= 0;
                    if (left)
                        state <= S_Backward;
                    else if (right)
                        state <= S_Forward;
                    else if (attack)
                        state <= S_Attack_start;
                end

                S_Backward: begin
                    frame_counter <= 0;
                    if (left)
                        state <= S_Backward;
                    else if (right)
                        state <= S_Forward;
                    else if (attack)
                        state <= S_Attack_start;
                    else
                        state <= S_IDLE;
                end

                S_Forward: begin
                    frame_counter <= 0;
                    if (left)
                        state <= S_Backward;
                    else if (right)
                        state <= S_Forward;
                    else if (attack)
                        state <= S_Attack_start;
                    else
                        state <= S_IDLE;
                end

                S_Attack_start: begin
                    if (frame_counter >= ATTACK_START_FRAMES - 1) begin
                        state <= S_Attack_active;
                        frame_counter <= 0;
                    end else begin
                        frame_counter <= frame_counter + 1;
                    end
                end

                S_Attack_active: begin
                    if (frame_counter >= ATTACK_ACTIVE_FRAMES - 1) begin
                        state <= S_Attack_recovery;
                        frame_counter <= 0;
                    end else begin
                        frame_counter <= frame_counter + 1;
                    end
                end

                S_Attack_recovery: begin
                    if (frame_counter >= ATTACK_RECOVERY_FRAMES - 1) begin
                        state <= S_IDLE;
                        frame_counter <= 0;
                    end else begin
                        frame_counter <= frame_counter + 1;
                    end
                end

                default: begin
                    state <= S_IDLE;
                    frame_counter <= 0;
                end
            endcase
        end
    end

    // Output logic (can be in a separate block or combined)
    always @(*) begin
        move_flag = 0;
        directional_attack_flag = 0;
        attack_flag = 0;

        case(state)
            S_Backward, S_Forward: begin
                move_flag = 1;
                directional_attack_flag = attack;
            end
            S_Attack_start,
            S_Attack_active: begin
                attack_flag = 1;
            end
        endcase
    end

endmodule
