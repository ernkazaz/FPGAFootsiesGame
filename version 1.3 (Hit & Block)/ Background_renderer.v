module Background_Renderer (
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    output [7:0] bg_color
);

    wire [7:0] background_color = 8'hB0; // dark orange -> A0 is darker, C0 is brighter
    wire [7:0] ground_color     = 8'h00; // black
    wire [7:0] sun_color        = 8'hE0; // red sun

    wire inside_ground = (pixel_y >= 400);
    wire inside_sun    = (pixel_x > 500 && pixel_x < 540 &&
                          pixel_y > 60 && pixel_y < 100);

    assign bg_color = inside_ground ? ground_color :
                      inside_sun    ? sun_color :
                                      background_color;

endmodule
