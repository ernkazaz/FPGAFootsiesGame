module game_core(

    //Clock inputs
	 input enable,
    input clock,
    input clock_bypass,
    input clock_manual_button,

    //Reset input
    input reset,

    //Visible hitbox inputs
    input switch_hitbox,

    //Player 1 inputs
    input player1_left,
    input player1_right,
    input player1_attack,

    //Player 2 inputs
    input player2_left,
    input player2_right,
    input player2_attack,

    //VGA inputs
    output [7:0] VGA_red,
    output [7:0] VGA_blue,
    output [7:0] VGA_green,
    output VGA_sync,
    output VGA_clock,
    output VGA_Hsync,
    output VGA_Vsync,
    output VGA_blank,

    output [2:0] health_p1,
    output [2:0] health_p2
);


    //Clock wires
    wire clk_25MHz;
    wire clk_60Hz;

    //25MHz Clock
    Clock_Divider #(.division(2)) clock_vga (
        .clk_in    (clock),
        .clk_bypass(1'b0),
        .button    (1'b0),
        .reset     (1'b0),
        .clk_out   (clk_25MHz)
    );
    
    //60Hz Clock
    Clock_Divider #(.division(833334)) clock_fsm (
        .clk_in    (clock),
        .clk_bypass(clock_bypass),
        .button    (clock_manual_button),
        .reset     (1'b0),
        .clk_out   (clk_60Hz)
    );


    wire [9:0] pixel_x;
    wire [9:0] pixel_y; 
    wire [7:0] sprite_color;


    // -----------------------------
    //         Player 1 wires
    // -----------------------------
    wire  [3:0] sprite_state_p1;
    wire        move_flag_p1;
    wire        directional_attack_flag_p1;
    wire        basic_attack_flag_p1;
    wire        hitbox_active_p1;
    wire        hurtbox_active_p1;
	wire        recovery_hurtbox_active_p1;
	wire        visible_box_active_p1;
    wire        got_hit_p1;
    wire        got_blocked_p1;
    wire  [2:0] block_count_p1;

    wire [9:0] sprite_x_p1;
    wire [9:0] sprite_y_p1;

    wire [9:0] hitbox_x1_p1, hitbox_x2_p1;
    wire [9:0] hitbox_y1_p1, hitbox_y2_p1;

    wire [9:0] hurtbox_x1_p1, hurtbox_x2_p1;
    wire [9:0] hurtbox_y1_p1, hurtbox_y2_p1;

	wire [9:0] hurtbox_rec_x1_p1, hurtbox_rec_x2_p1;
	wire [9:0] hurtbox_rec_y1_p1, hurtbox_rec_y2_p1;
	 
	wire [9:0] visible_box_x1_p1, visible_box_x2_p1;
	wire [9:0] visible_box_y1_p1, visible_box_y2_p1;


    // wire inside_bandana_p1;
    wire sprite_pixel_p1 = (pixel_x >= sprite_x_p1 && pixel_x < sprite_x_p1 + 64) &&
                           (pixel_y >= sprite_y_p1 && pixel_y < sprite_y_p1 + 240);


    // ----------------------------
    //        Player 2 wires
    // ----------------------------
    wire  [3:0] sprite_state_p2;
    wire        move_flag_p2;
    wire        directional_attack_flag_p2;
    wire        basic_attack_flag_p2;
    wire        hitbox_active_p2;
    wire        hurtbox_active_p2;
	wire        recovery_hurtbox_active_p2;
	wire        visible_box_active_p2;
    wire        got_hit_p2;
    wire        got_blocked_p2;
    wire  [2:0] block_count_p2;

    wire [9:0] sprite_x_p2;
    wire [9:0] sprite_y_p2;

    wire [9:0] hitbox_x1_p2, hitbox_x2_p2;
    wire [9:0] hitbox_y1_p2, hitbox_y2_p2;

    wire [9:0] hurtbox_x1_p2, hurtbox_x2_p2;
    wire [9:0] hurtbox_y1_p2, hurtbox_y2_p2;
	 
	wire [9:0] hurtbox_rec_x1_p2, hurtbox_rec_x2_p2;
	wire [9:0] hurtbox_rec_y1_p2, hurtbox_rec_y2_p2;
	 
	wire [9:0] visible_box_x1_p2, visible_box_x2_p2;
	wire [9:0] visible_box_y1_p2, visible_box_y2_p2;


    //wire inside_bandana_p2;
    wire sprite_pixel_p2 = (pixel_x >= sprite_x_p2 && pixel_x < sprite_x_p2 + 64) &&
                           (pixel_y >= sprite_y_p2 && pixel_y < sprite_y_p2 + 240);
    
    //--------------------------------------------------------------------
    // P1 hurt/hitboxes:
    //--------------------------------------------------------------------	 
    wire hurtbox_edge_p1 = switch_hitbox && hurtbox_active_p1 &&
        (
            (pixel_x >= hurtbox_x1_p1 && pixel_x < hurtbox_x1_p1 + 2) ||
            (pixel_x >= hurtbox_x2_p1 - 2 && pixel_x < hurtbox_x2_p1) ||
            (pixel_y >= hurtbox_y1_p1 && pixel_y < hurtbox_y1_p1 + 2) ||
            (pixel_y >= hurtbox_y2_p1 - 2 && pixel_y < hurtbox_y2_p1)
        ) &&
        (pixel_x >= hurtbox_x1_p1 && pixel_x < hurtbox_x2_p1) &&
        (pixel_y >= hurtbox_y1_p1 && pixel_y < hurtbox_y2_p1);

    wire hitbox_edge_p1 = switch_hitbox && hitbox_active_p1 &&
        (
            (pixel_x >= hitbox_x1_p1 && pixel_x < hitbox_x1_p1 + 2) ||
            (pixel_x >= hitbox_x2_p1 - 2 && pixel_x < hitbox_x2_p1) ||
            (pixel_y >= hitbox_y1_p1 && pixel_y < hitbox_y1_p1 + 2) ||
            (pixel_y >= hitbox_y2_p1 - 2 && pixel_y < hitbox_y2_p1)
        ) &&
        (pixel_x >= hitbox_x1_p1 && pixel_x < hitbox_x2_p1) &&
        (pixel_y >= hitbox_y1_p1 && pixel_y < hitbox_y2_p1);
		  
    wire hurtbox_rec_edge_p1 = switch_hitbox && recovery_hurtbox_active_p1 &&
        (
            (pixel_x >= hurtbox_rec_x1_p1 && pixel_x < hurtbox_rec_x1_p1 + 2) ||
            (pixel_x >= hurtbox_rec_x2_p1 - 2 && pixel_x < hurtbox_rec_x2_p1) ||
            (pixel_y >= hurtbox_rec_y1_p1 && pixel_y < hurtbox_rec_y1_p1 + 2) ||
            (pixel_y >= hurtbox_rec_y2_p1 - 2 && pixel_y < hurtbox_rec_y2_p1)
        ) &&
        (pixel_x >= hurtbox_rec_x1_p1 && pixel_x < hurtbox_rec_x2_p1) &&
        (pixel_y >= hurtbox_rec_y1_p1 && pixel_y < hurtbox_rec_y2_p1);	 

    wire visible_box_p1 = visible_box_active_p1 &&
		  (    
			(pixel_x >= visible_box_x1_p1) && (pixel_x < visible_box_x2_p1) &&
            (pixel_y >= visible_box_y1_p1) && (pixel_y < visible_box_y2_p1)
        );

    //--------------------------------------------------------------------	  
    // P2 hurt/hitboxes:
	//--------------------------------------------------------------------
    wire hurtbox_edge_p2 = switch_hitbox && hurtbox_active_p2 &&
        (
            (pixel_x >= hurtbox_x1_p2 && pixel_x < hurtbox_x1_p2 + 2) ||
            (pixel_x >= hurtbox_x2_p2 - 2 && pixel_x < hurtbox_x2_p2) ||
            (pixel_y >= hurtbox_y1_p2 && pixel_y < hurtbox_y1_p2 + 2) ||
            (pixel_y >= hurtbox_y2_p2 - 2 && pixel_y < hurtbox_y2_p2)
        ) &&
        (pixel_x >= hurtbox_x1_p2 && pixel_x < hurtbox_x2_p2) &&
        (pixel_y >= hurtbox_y1_p2 && pixel_y < hurtbox_y2_p2);

    wire hitbox_edge_p2 = switch_hitbox && hitbox_active_p2 &&
        (
            (pixel_x >= hitbox_x1_p2 && pixel_x < hitbox_x1_p2 + 2) ||
            (pixel_x >= hitbox_x2_p2 - 2 && pixel_x < hitbox_x2_p2) ||
            (pixel_y >= hitbox_y1_p2 && pixel_y < hitbox_y1_p2 + 2) ||
            (pixel_y >= hitbox_y2_p2 - 2 && pixel_y < hitbox_y2_p2)
        ) &&
        (pixel_x >= hitbox_x1_p2 && pixel_x < hitbox_x2_p2) &&
        (pixel_y >= hitbox_y1_p2 && pixel_y < hitbox_y2_p2);
		  
	 wire hurtbox_rec_edge_p2 = switch_hitbox && recovery_hurtbox_active_p2 &&
			(
				 (pixel_x >= hurtbox_rec_x1_p2 && pixel_x < hurtbox_rec_x1_p2 + 2) ||
				 (pixel_x >= hurtbox_rec_x2_p2 - 2 && pixel_x < hurtbox_rec_x2_p2) ||
				 (pixel_y >= hurtbox_rec_y1_p2 && pixel_y < hurtbox_rec_y1_p2 + 2) ||
				 (pixel_y >= hurtbox_rec_y2_p2 - 2 && pixel_y < hurtbox_rec_y2_p2)
			) &&
			(pixel_x >= hurtbox_rec_x1_p2 && pixel_x < hurtbox_rec_x2_p2) &&
			(pixel_y >= hurtbox_rec_y1_p2 && pixel_y < hurtbox_rec_y2_p2);

	 wire visible_box_p2 = visible_box_active_p2 &&
		   (    
			(pixel_x >= visible_box_x1_p2) && (pixel_x < visible_box_x2_p2) &&
            (pixel_y >= visible_box_y1_p2) && (pixel_y < visible_box_y2_p2)
         );

    wire is_blocking_p1 = (block_count_p1 > 0) && player1_left;
    wire is_blocking_p2 = (block_count_p2 > 0) && player2_left;

    wire [7:0] bg_color;
    wire [7:0] color_out;

    assign color_out =
           (hitbox_edge_p1           ? 8'hE0 :  // Red
           (hurtbox_edge_p1          ? 8'hFC :  // Yellow
			  (hurtbox_rec_edge_p1      ? 8'hFC :
			  (visible_box_p1           ? 8'h00 :  // Black
           (hitbox_edge_p2           ? 8'hE0 :
           (hurtbox_edge_p2          ? 8'hFC :
			  (hurtbox_rec_edge_p2      ? 8'hFC :
			  (visible_box_p2           ? 8'h00 :
           (sprite_pixel_p1          ? 8'h00 :
           (sprite_pixel_p2          ? 8'h00 :
           //(inside_bandana_p1        ? 8'hFF :
           //(inside_bandana_p2        ? 8'hFF :
            bg_color))))))))));

    Sprite_FSM fsm_p1 (
        .clk                      (clk_60Hz),
        .reset                    (reset),
        .left                     (player1_left),        // KEY[3] = left for P1
        .right                    (player1_right),        // KEY[1] = right for P1
        .attack                   (player1_attack),        // KEY[2] = attack for P1
        .got_hit                  (got_hit_p1),
        .got_blocked              (got_blocked_p1),
        .state                    (sprite_state_p1),
        .move_flag                (move_flag_p1),
        .directional_attack_flag  (directional_attack_flag_p1),
        .basic_attack_flag        (basic_attack_flag_p1)
    );


    Sprite_FSM fsm_p2 (
        .clk                      (clk_60Hz),
        .reset                    (reset),
        .left                     (player2_left),          // SW[7] = left for P2
        .right                    (player2_right),          // SW[9] = right for P2
        .attack                   (player2_attack),          // SW[8] = attack for P2
        .got_hit                  (got_hit_p2),
        .got_blocked              (got_blocked_p2),
        .state                    (sprite_state_p2),
        .move_flag                (move_flag_p2),
        .directional_attack_flag  (directional_attack_flag_p2),
        .basic_attack_flag        (basic_attack_flag_p2)
    );

    Sprite_renderer #(.IS_MIRRORED(0)) render1 (
        .clk           (clk_60Hz),
		  .reset 		  (reset),
        .state         (sprite_state_p1),
        .pixel_x       (pixel_x),             
        .pixel_y       (pixel_y), 		       
	    .opponent_x    (sprite_x_p2),
        .sprite_x      (sprite_x_p1),
        .sprite_y      (sprite_y_p1),
        .sprite_color  (sprite_color)               // It is unused, can be remowed if changing state colors is unwanted.
        //.inside_bandana(inside_bandana_p1)
    );

    Sprite_renderer #(.IS_MIRRORED(1)) render2 (
        .clk           (clk_60Hz),
		  .reset         (reset),
        .state         (sprite_state_p2),
        .pixel_x       (pixel_x),
        .pixel_y       (pixel_y),
        .opponent_x    (sprite_x_p1),
	    .sprite_x      (sprite_x_p2),
        .sprite_y      (sprite_y_p2),
        .sprite_color  (sprite_color)               // It is unused, can be remowed if changing state colors is unwanted.
        //.inside_bandana(inside_bandana_p2)
    );

    Background_renderer background (
		  .clk(clock),
		  .reset(reset),
		  .timer_enable(enable),
        .pixel_x  (pixel_x),
        .pixel_y  (pixel_y),
        .bg_color (bg_color),
        .health_p1(health_p1),
       
		 .health_p2(health_p2),
        .block_count_p1(block_count_p1),
        .block_count_p2(block_count_p2)
    );


    Sprite_boxes #(.IS_MIRRORED(0)) boxes1 (
        .state                   (sprite_state_p1),
        .sprite_x                (sprite_x_p1),
        .sprite_y                (sprite_y_p1),
        .hitbox_x1               (hitbox_x1_p1),
        .hitbox_x2               (hitbox_x2_p1),
        .hitbox_y1               (hitbox_y1_p1),
        .hitbox_y2               (hitbox_y2_p1),
        .hurtbox_x1              (hurtbox_x1_p1),
        .hurtbox_x2              (hurtbox_x2_p1),
        .hurtbox_y1              (hurtbox_y1_p1),
        .hurtbox_y2              (hurtbox_y2_p1),
	    .hurtbox_rec_x1          (hurtbox_rec_x1_p1),
	    .hurtbox_rec_x2          (hurtbox_rec_x2_p1),
	    .hurtbox_rec_y1          (hurtbox_rec_y1_p1),
	    .hurtbox_rec_y2          (hurtbox_rec_y2_p1),
	    .visible_box_x1          (visible_box_x1_p1),
	    .visible_box_x2          (visible_box_x2_p1),
	    .visible_box_y1          (visible_box_y1_p1),
	    .visible_box_y2          (visible_box_y2_p1),
        .hitbox_active           (hitbox_active_p1),
        .hurtbox_active          (hurtbox_active_p1),
	    .recovery_hurtbox_active (recovery_hurtbox_active_p1),
	    .visible_box_active      (visible_box_active_p1)
    );

    Sprite_boxes #(.IS_MIRRORED(1)) boxes2 (
        .state                   (sprite_state_p2),
        .sprite_x                (sprite_x_p2),
        .sprite_y                (sprite_y_p2),
        .hitbox_x1               (hitbox_x1_p2),
        .hitbox_x2               (hitbox_x2_p2),
        .hitbox_y1               (hitbox_y1_p2),
        .hitbox_y2               (hitbox_y2_p2),
        .hurtbox_x1              (hurtbox_x1_p2),
        .hurtbox_x2              (hurtbox_x2_p2),
        .hurtbox_y1              (hurtbox_y1_p2),
        .hurtbox_y2              (hurtbox_y2_p2),
	    .hurtbox_rec_x1          (hurtbox_rec_x1_p2),
	    .hurtbox_rec_x2          (hurtbox_rec_x2_p2),
	    .hurtbox_rec_y1          (hurtbox_rec_y1_p2),
	    .hurtbox_rec_y2          (hurtbox_rec_y2_p2),
	    .visible_box_x1          (visible_box_x1_p2),
	    .visible_box_x2          (visible_box_x2_p2),
	    .visible_box_y1          (visible_box_y1_p2),
	    .visible_box_y2          (visible_box_y2_p2),
        .hitbox_active           (hitbox_active_p2),
        .hurtbox_active          (hurtbox_active_p2),
	    .recovery_hurtbox_active (recovery_hurtbox_active_p2),
	    .visible_box_active      (visible_box_active_p2)
    );


    Collision_logic col_p1_hits_p2 (
        .attacker_hitbox_x1       (hitbox_x1_p1),
        .attacker_hitbox_x2       (hitbox_x2_p1),
        .attacker_hitbox_y1       (hitbox_y1_p1),
        .attacker_hitbox_y2       (hitbox_y2_p1),
        .attacker_hitbox_active   (hitbox_active_p1),
        .attacker_attack_flag     (basic_attack_flag_p1),
        .attacker_diratk_flag     (directional_attack_flag_p1),

        .target_hurtbox_x1        (hurtbox_x1_p2),
        .target_hurtbox_x2        (hurtbox_x2_p2),
        .target_hurtbox_y1        (hurtbox_y1_p2),
        .target_hurtbox_y2        (hurtbox_y2_p2),
        .target_hurtbox_active    (hurtbox_active_p2),
        .target_is_blocking       (is_blocking_p2),

        .target_recovery_hurtbox_x1  (hurtbox_rec_x1_p2),    
        .target_recovery_hurtbox_x2  (hurtbox_rec_x2_p2),
        .target_recovery_hurtbox_y1  (hurtbox_rec_y1_p2),
        .target_recovery_hurtbox_y2  (hurtbox_rec_y2_p2),
        .target_recovery_hurtbox_active (recovery_hurtbox_active_p2),	
  
        .got_hit_target           (got_hit_p2),
        .got_blocked_target       (got_blocked_p2)
    );


    Collision_logic col_p2_hits_p1 (
        .attacker_hitbox_x1       (hitbox_x1_p2),
        .attacker_hitbox_x2       (hitbox_x2_p2),
        .attacker_hitbox_y1       (hitbox_y1_p2),
        .attacker_hitbox_y2       (hitbox_y2_p2),
        .attacker_hitbox_active   (hitbox_active_p2),
        .attacker_attack_flag     (basic_attack_flag_p2),
        .attacker_diratk_flag     (directional_attack_flag_p2),

        .target_hurtbox_x1        (hurtbox_x1_p1),
        .target_hurtbox_x2        (hurtbox_x2_p1),
        .target_hurtbox_y1        (hurtbox_y1_p1),
        .target_hurtbox_y2        (hurtbox_y2_p1),
        .target_hurtbox_active    (hurtbox_active_p1),
        .target_is_blocking       (is_blocking_p1),
        .target_recovery_hurtbox_x1  (hurtbox_rec_x1_p1),     
        .target_recovery_hurtbox_x2  (hurtbox_rec_x2_p1),
        .target_recovery_hurtbox_y1  (hurtbox_rec_y1_p1),
        .target_recovery_hurtbox_y2  (hurtbox_rec_y2_p1),
        .target_recovery_hurtbox_active (recovery_hurtbox_active_p1),

        .got_hit_target           (got_hit_p1),
        .got_blocked_target       (got_blocked_p1)
    );
	 

    Health_Block health_block_p1(
        .clk(clk_60Hz),
        .reset(reset),
        .got_hit(got_hit_p1),
        .blocked(got_blocked_p1),
        .health(health_p1),
        .block(block_count_p1)
    );

    Health_Block health_block_p2(
        .clk(clk_60Hz),
        .reset(reset),
        .got_hit(got_hit_p2),
        .blocked(got_blocked_p2),
        .health(health_p2),
        .block(block_count_p2)
    );

    vga_driver vga (
        .clock   (clk_25MHz),
        .reset   (1'b0),
        .color_in(color_out),
        .next_x  (pixel_x),
        .next_y  (pixel_y),
        .hsync   (VGA_Hsync),
        .vsync   (VGA_Vsync),
        .red     (VGA_red),
        .green   (VGA_green),
        .blue    (VGA_blue),
        .sync    (VGA_sync),
        .clk     (VGA_clock),
        .blank   (VGA_blank)
    );


endmodule 