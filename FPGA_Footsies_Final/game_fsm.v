module game_fsm (
    input wire clk_50,
    input wire reset,

    input wire [9:0] switches,
    input wire [3:0] keys,

    input wire [2:0] keypad_p2,
    input wire [2:0] cpu_p2,

    output wire vga_clk,
    output wire vga_blank_n,
    output wire vga_sync_n,
    output wire vga_hs,
    output wire vga_vs,
    output wire [7:0] vga_r,
    output wire [7:0] vga_g,
    output wire [7:0] vga_b,

    output reg menu_enable,
    output reg game_enable,
    output reg game_over_enable,

    output reg game_mode,

    output reg [1:0] winner,
    output wire [9:0] leds
);

    parameter MENU_STATE      = 3'b000;
    parameter GAME_STATE      = 3'b001;
    parameter GAME_OVER_STATE = 3'b010;

    wire [2:0] health_p1;
    wire [2:0] health_p2;
    wire game_over;
    wire p1_wins;
    wire p2_wins;
    reg [2:0] p2_inputs;
    wire game_clock_bypass = (switches[0] || (game_enable == 0));

    reg [2:0] current_state, next_state;

    reg [3:0] keys_prev;
    wire [3:0] key_pressed;
    wire any_key_pressed;

    wire menu_vga_clk, menu_vga_blank_n, menu_vga_sync_n, menu_vga_hs, menu_vga_vs;
    wire [7:0] menu_vga_r, menu_vga_g, menu_vga_b;
    wire [9:0] menu_leds;

    wire game_vga_clk, game_vga_blank_n, game_vga_sync_n, game_vga_hs, game_vga_vs;
    wire [7:0] game_vga_r, game_vga_g, game_vga_b;

    wire gameover_vga_clk, gameover_vga_blank_n, gameover_vga_sync_n, gameover_vga_hs, gameover_vga_vs;
    wire [7:0] gameover_vga_r, gameover_vga_g, gameover_vga_b;

    always @(posedge clk_50 or posedge reset) begin
        if (reset) begin
            keys_prev <= 4'b0000;
        end else begin
            keys_prev <= keys;
        end
    end

    assign key_pressed = keys & ~keys_prev;
    assign any_key_pressed = |key_pressed;

    always @(posedge clk_50 or posedge reset) begin
        if (reset) begin
            current_state <= MENU_STATE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;

        case (current_state)
            MENU_STATE: begin
                if (any_key_pressed) begin
                    next_state = GAME_STATE;
                end
            end

            GAME_STATE: begin
                if (game_over || p1_wins || p2_wins) begin
                    next_state = GAME_OVER_STATE;
                end
            end

            GAME_OVER_STATE: begin
                if (any_key_pressed) begin
                    next_state = MENU_STATE;
                end
            end

            default: next_state = MENU_STATE;
        endcase
    end

    always @(*) begin
        menu_enable = 1'b0;
        game_enable = 1'b0;
        game_over_enable = 1'b0;

        case (current_state)
            MENU_STATE: menu_enable = 1'b1;
            GAME_STATE: game_enable = 1'b1;
            GAME_OVER_STATE: game_over_enable = 1'b1;
        endcase
    end

    always @(posedge clk_50 or posedge reset) begin
        if (reset) begin
            game_mode <= 1'b0;
        end else if (current_state == MENU_STATE && any_key_pressed) begin
            game_mode <= switches[0];
        end
    end

    always @(*) begin
        p2_inputs = (game_mode == 1'b0) ? cpu_p2 : keypad_p2;
    end

    reg game_core_reset;

    always @(posedge clk_50 or posedge reset) begin
        if (reset) begin
            game_core_reset <= 1'b0;
        end else if (current_state == GAME_OVER_STATE && any_key_pressed) begin
            game_core_reset <= 1'b1;
        end else begin
            game_core_reset <= 1'b0;
        end
    end

    wire internal_reset = game_core_reset;

    reg [1:0] winner_next;

    always @(*) begin
        winner_next = winner;

        if (current_state == GAME_STATE && next_state == GAME_OVER_STATE) begin
            if (p1_wins) begin
                winner_next = 2'b01;
            end else if (p2_wins) begin
                winner_next = 2'b10;
            end else begin
                winner_next = 2'b11;
            end
        end else if (current_state == MENU_STATE) begin
            winner_next = 2'b00;
        end
    end

    always @(posedge clk_50 or posedge reset) begin
        if (reset) begin
            winner <= 2'b00;
        end else begin
            winner <= winner_next;
        end
    end

    Menu_Core menu_inst (
        .clk_50(clk_50),
        .reset(1'b0),
        .switches(switches),
        .keys(keys),
        .vga_clk(menu_vga_clk),
        .vga_blank_n(menu_vga_blank_n),
        .vga_sync_n(menu_vga_sync_n),
        .vga_hs(menu_vga_hs),
        .vga_vs(menu_vga_vs),
        .vga_r(menu_vga_r),
        .vga_g(menu_vga_g),
        .vga_b(menu_vga_b),
        .leds(menu_leds)
    );

    game_core game_inst(
        .clock(clk_50),
        .clock_bypass(game_clock_bypass),
        .clock_manual_button(keys[0]),
        .reset(reset),
        .switch_hitbox(switches[0]),
        .player1_left(keys[2]),
        .player1_right(keys[0]),
        .player1_attack(keys[1]),
        .player2_left(p2_inputs[2]),
        .player2_right(p2_inputs[0]),
        .player2_attack(p2_inputs[1]),
        .VGA_red(game_vga_r),
        .VGA_blue(game_vga_b),
        .VGA_green(game_vga_g),
        .VGA_sync(game_vga_sync_n),
        .VGA_clock(game_vga_clk),
        .VGA_Hsync(game_vga_hs),
        .VGA_Vsync(game_vga_vs),
        .VGA_blank(game_vga_blank_n),
        .health_p1(health_p1),
        .health_p2(health_p2)
    );

    assign game_over = (health_p1 == 0) | (health_p2 == 0);
    assign p1_wins = (health_p2 == 0) && (health_p1 != 0);
    assign p2_wins = (health_p1 == 0) && (health_p2 != 0);

    Game_Over_core game_over_inst(
        .clk_50(clk_50),
        .reset(1'b0),
        .switches(switches),
        .keys(keys),
        .winner_player(p1_wins || p2_wins),
        .vga_clk(gameover_vga_clk),
        .vga_blank_n(gameover_vga_blank_n),
        .vga_sync_n(gameover_vga_sync_n),
        .vga_hs(gameover_vga_hs),
        .vga_vs(gameover_vga_vs),
        .vga_r(gameover_vga_r),
        .vga_g(gameover_vga_g),
        .vga_b(gameover_vga_b)
    );

    reg vga_clk_mux, vga_blank_n_mux, vga_sync_n_mux, vga_hs_mux, vga_vs_mux;
    reg [7:0] vga_r_mux, vga_g_mux, vga_b_mux;

    always @(*) begin
        case (current_state)
            MENU_STATE: begin
                vga_clk_mux = menu_vga_clk;
                vga_blank_n_mux = menu_vga_blank_n;
                vga_sync_n_mux = menu_vga_sync_n;
                vga_hs_mux = menu_vga_hs;
                vga_vs_mux = menu_vga_vs;
                vga_r_mux = menu_vga_r;
                vga_g_mux = menu_vga_g;
                vga_b_mux = menu_vga_b;
            end

            GAME_STATE: begin
                vga_clk_mux = game_vga_clk;
                vga_blank_n_mux = game_vga_blank_n;
                vga_sync_n_mux = game_vga_sync_n;
                vga_hs_mux = game_vga_hs;
                vga_vs_mux = game_vga_vs;
                vga_r_mux = game_vga_r;
                vga_g_mux = game_vga_g;
                vga_b_mux = game_vga_b;
            end

            GAME_OVER_STATE: begin
                vga_clk_mux = gameover_vga_clk;
                vga_blank_n_mux = gameover_vga_blank_n;
                vga_sync_n_mux = gameover_vga_sync_n;
                vga_hs_mux = gameover_vga_hs;
                vga_vs_mux = gameover_vga_vs;
                vga_r_mux = gameover_vga_r;
                vga_g_mux = gameover_vga_g;
                vga_b_mux = gameover_vga_b;
            end

            default: begin
                vga_clk_mux = menu_vga_clk;
                vga_blank_n_mux = menu_vga_blank_n;
                vga_sync_n_mux = menu_vga_sync_n;
                vga_hs_mux = menu_vga_hs;
                vga_vs_mux = menu_vga_vs;
                vga_r_mux = menu_vga_r;
                vga_g_mux = menu_vga_g;
                vga_b_mux = menu_vga_b;
            end
        endcase
    end

    assign vga_clk = vga_clk_mux;
    assign vga_blank_n = vga_blank_n_mux;
    assign vga_sync_n = vga_sync_n_mux;
    assign vga_hs = vga_hs_mux;
    assign vga_vs = vga_vs_mux;
    assign vga_r = vga_r_mux;
    assign vga_g = vga_g_mux;
    assign vga_b = vga_b_mux;

    assign leds = (current_state == MENU_STATE) ? menu_leds : {6'b000000, winner, current_state[1:0]};

endmodule
