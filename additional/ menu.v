reg [2:0] key_sync;
reg prev_key0, prev_key1, prev_key2;

always @(posedge clk_50MHz) begin
    key_sync <= {KEY[2], KEY[1], KEY[0]};
    prev_key0 <= key_sync[0];
    prev_key1 <= key_sync[1];
    prev_key2 <= key_sync[2];
end

wire key0_pressed = (prev_key0 == 1) && (key_sync[0] == 0);  // KEY[0] falling edge (left)
wire key1_pressed = (prev_key1 == 1) && (key_sync[1] == 0);  // KEY[1] falling edge (select)
wire key2_pressed = (prev_key2 == 1) && (key_sync[2] == 0);  // KEY[2] falling edge (right)


always @(posedge clk_60Hz or posedge reset) begin
    if (reset) begin
        menu_state <= MENU_MAIN;
        menu_selection <= 0;
    end else begin
        case(menu_state)
            MENU_MAIN: begin
                // Navigate options with left/right keys
                if (key0_pressed && menu_selection > 0)
                    menu_selection <= menu_selection - 1;
                else if (key2_pressed && menu_selection < 1)
                    menu_selection <= menu_selection + 1;

                // Confirm selection with select key
                if (key1_pressed) begin
                    if (menu_selection == 0)
                        menu_state <= MENU_1P_VS_CPU;
                    else
                        menu_state <= MENU_2P;
                end
            end

            MENU_1P_VS_CPU: begin
                // Add logic for 1P mode or go to next menu
                // For now just go back to main menu on select
                if (key1_pressed)
                    menu_state <= MENU_MAIN;
            end

            MENU_2P: begin
                // Add logic for 2P mode or next menu
                if (key1_pressed)
                    menu_state <= MENU_MAIN;
            end

            default: menu_state <= MENU_MAIN;
        endcase
    end
end



wire [7:0] menu_color;

wire option1_selected = (menu_selection == 0) && (menu_state == MENU_MAIN);
wire option2_selected = (menu_selection == 1) && (menu_state == MENU_MAIN);

wire option1_area = (pixel_x >= 100 && pixel_x < 200) && (pixel_y >= 200 && pixel_y < 250);
wire option2_area = (pixel_x >= 300 && pixel_x < 400) && (pixel_y >= 200 && pixel_y < 250);

assign menu_color = (option1_area && option1_selected) ? 8'b111_000_00 : // Red highlight
                    (option2_area && option2_selected) ? 8'b000_111_00 : // Green highlight
                    8'b111_111_11; // Background color (light gray)
