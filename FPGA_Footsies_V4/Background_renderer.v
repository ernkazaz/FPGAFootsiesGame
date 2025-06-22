module Background_Renderer (
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input [2:0] health_p1,      
    input [2:0] health_p2,      
    input [2:0] block_count_p1, 
    input [2:0] block_count_p2, 
    output [7:0] bg_color
);

    // Color definitions
    wire [7:0] background_color = 8'hB0; 
    wire [7:0] ground_color = 8'h00;     
    wire [7:0] sun_color = 8'hE0;        
    wire [7:0] heart_color = 8'hFC;      
    wire [7:0] dead_heart_color = 8'h00; 
    wire [7:0] shield_color = 8'h1C;     
    wire [7:0] used_shield_color = 8'h00; 

    // Ground and sun (original elements)
    wire inside_ground = (pixel_y >= 420);
    wire inside_sun = (pixel_x > 500 && pixel_x < 540 && pixel_y > 60 && pixel_y < 100);

    // Heart parameters
    parameter HEART_SIZE = 16;
    parameter HEART_OFFSET = 20;
    parameter HEART_SPACING = 25;

    // Shield parameters  
    parameter SHIELD_SIZE = 12;
    parameter SHIELD_Y_OFFSET = 25;

    // State parameter definitions (matching Health_Block module)
    localparam threelives = 2'b11, twolives = 2'b10, onelive = 2'b01, dead = 2'b00;
    localparam threeblock = 2'b11, twoblocks = 2'b10, oneblock = 2'b01, noblock = 2'b00;

    // Left side hearts (3 hearts in top-left corner)
    wire [9:0] left_heart1_x = HEART_OFFSET;
    wire [9:0] left_heart2_x = HEART_OFFSET + HEART_SPACING;
    wire [9:0] left_heart3_x = HEART_OFFSET + 2*HEART_SPACING;
    wire [9:0] hearts_y = HEART_OFFSET;

    // Right side hearts (3 hearts in top-right corner) 
    wire [9:0] right_heart1_x = 640 - HEART_OFFSET - HEART_SIZE;
    wire [9:0] right_heart2_x = 640 - HEART_OFFSET - HEART_SIZE - HEART_SPACING;
    wire [9:0] right_heart3_x = 640 - HEART_OFFSET - HEART_SIZE - 2*HEART_SPACING;

    // Heart detection (simplified heart shape using rectangles)
    wire inside_left_heart1 = (pixel_x >= left_heart1_x && pixel_x < left_heart1_x + HEART_SIZE && 
                              pixel_y >= hearts_y && pixel_y < hearts_y + HEART_SIZE);
    wire inside_left_heart2 = (pixel_x >= left_heart2_x && pixel_x < left_heart2_x + HEART_SIZE && 
                              pixel_y >= hearts_y && pixel_y < hearts_y + HEART_SIZE);
    wire inside_left_heart3 = (pixel_x >= left_heart3_x && pixel_x < left_heart3_x + HEART_SIZE && 
                              pixel_y >= hearts_y && pixel_y < hearts_y + HEART_SIZE);

    wire inside_right_heart1 = (pixel_x >= right_heart1_x && pixel_x < right_heart1_x + HEART_SIZE && 
                               pixel_y >= hearts_y && pixel_y < hearts_y + HEART_SIZE);
    wire inside_right_heart2 = (pixel_x >= right_heart2_x && pixel_x < right_heart2_x + HEART_SIZE && 
                               pixel_y >= hearts_y && pixel_y < hearts_y + HEART_SIZE);
    wire inside_right_heart3 = (pixel_x >= right_heart3_x && pixel_x < right_heart3_x + HEART_SIZE && 
                               pixel_y >= hearts_y && pixel_y < hearts_y + HEART_SIZE);

    // Left side shields (below hearts)
    wire [9:0] left_shield1_x = HEART_OFFSET;
    wire [9:0] left_shield2_x = HEART_OFFSET + HEART_SPACING;
    wire [9:0] left_shield3_x = HEART_OFFSET + 2*HEART_SPACING;
    wire [9:0] left_shields_y = hearts_y + HEART_SIZE + SHIELD_Y_OFFSET;

    // Right side shields (below hearts)
    wire [9:0] right_shield1_x = 640 - HEART_OFFSET - SHIELD_SIZE;
    wire [9:0] right_shield2_x = 640 - HEART_OFFSET - SHIELD_SIZE - HEART_SPACING;
    wire [9:0] right_shield3_x = 640 - HEART_OFFSET - SHIELD_SIZE - 2*HEART_SPACING;
    wire [9:0] right_shields_y = hearts_y + HEART_SIZE + SHIELD_Y_OFFSET;

    // Shield detection
    wire inside_left_shield1 = (pixel_x >= left_shield1_x && pixel_x < left_shield1_x + SHIELD_SIZE && 
                               pixel_y >= left_shields_y && pixel_y < left_shields_y + SHIELD_SIZE);
    wire inside_left_shield2 = (pixel_x >= left_shield2_x && pixel_x < left_shield2_x + SHIELD_SIZE && 
                               pixel_y >= left_shields_y && pixel_y < left_shields_y + SHIELD_SIZE);
    wire inside_left_shield3 = (pixel_x >= left_shield3_x && pixel_x < left_shield3_x + SHIELD_SIZE && 
                               pixel_y >= left_shields_y && pixel_y < left_shields_y + SHIELD_SIZE);

    wire inside_right_shield1 = (pixel_x >= right_shield1_x && pixel_x < right_shield1_x + SHIELD_SIZE && 
                                pixel_y >= right_shields_y && pixel_y < right_shields_y + SHIELD_SIZE);
    wire inside_right_shield2 = (pixel_x >= right_shield2_x && pixel_x < right_shield2_x + SHIELD_SIZE && 
                                pixel_y >= right_shields_y && pixel_y < right_shields_y + SHIELD_SIZE);
    wire inside_right_shield3 = (pixel_x >= right_shield3_x && pixel_x < right_shield3_x + SHIELD_SIZE && 
                                pixel_y >= right_shields_y && pixel_y < right_shields_y + SHIELD_SIZE);

    // Determine heart colors based on health state
    wire [7:0] left_heart1_color = (health_p1 == threelives || health_p1 == twolives || health_p1 == onelive) ? heart_color : dead_heart_color;
    wire [7:0] left_heart2_color = (health_p1 == threelives || health_p1 == twolives) ? heart_color : dead_heart_color;
    wire [7:0] left_heart3_color = (health_p1 == threelives) ? heart_color : dead_heart_color;

    wire [7:0] right_heart1_color = (health_p2 == threelives || health_p2 == twolives || health_p2 == onelive) ? heart_color : dead_heart_color;
    wire [7:0] right_heart2_color = (health_p2 == threelives || health_p2 == twolives) ? heart_color : dead_heart_color;
    wire [7:0] right_heart3_color = (health_p2 == threelives) ? heart_color : dead_heart_color;

    // Determine shield colors based on block state
    wire [7:0] left_shield1_color = (block_count_p1 == threeblock || block_count_p1 == twoblocks || block_count_p1 == oneblock) ? shield_color : used_shield_color;
    wire [7:0] left_shield2_color = (block_count_p1 == threeblock || block_count_p1 == twoblocks) ? shield_color : used_shield_color;
    wire [7:0] left_shield3_color = (block_count_p1 == threeblock) ? shield_color : used_shield_color;

    wire [7:0] right_shield1_color = (block_count_p2 == threeblock || block_count_p2 == twoblocks || block_count_p2 == oneblock) ? shield_color : used_shield_color;
    wire [7:0] right_shield2_color = (block_count_p2 == threeblock || block_count_p2 == twoblocks) ? shield_color : used_shield_color;
    wire [7:0] right_shield3_color = (block_count_p2 == threeblock) ? shield_color : used_shield_color;

    // Priority-based color assignment with individual heart and shield colors
    assign bg_color = inside_ground ? ground_color :
                     inside_left_heart1 ? left_heart1_color :
                     inside_left_heart2 ? left_heart2_color :
                     inside_left_heart3 ? left_heart3_color :
                     inside_right_heart1 ? right_heart1_color :
                     inside_right_heart2 ? right_heart2_color :
                     inside_right_heart3 ? right_heart3_color :
                     inside_left_shield1 ? left_shield1_color :
                     inside_left_shield2 ? left_shield2_color :
                     inside_left_shield3 ? left_shield3_color :
                     inside_right_shield1 ? right_shield1_color :
                     inside_right_shield2 ? right_shield2_color :
                     inside_right_shield3 ? right_shield3_color :
                     inside_sun ? sun_color :
                     background_color;

endmodule