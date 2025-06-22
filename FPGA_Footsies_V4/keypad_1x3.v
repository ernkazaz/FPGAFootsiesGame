module keypad_1x3 (
    input wire clk,              // Already divided clock
    input wire rst_n,            // Active low reset
    input wire [2:0] col,        // Column inputs (3 bits, active low)
    output reg row,              // Single row output
    output reg [2:0] button_out, // 3-bit output: button3, button2, button1
    output reg key_valid         // High when a key is pressed
);
    
    // Single row is always active (low for active-low logic)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row <= 1'b0;  // Always active (low)
        end else begin
            row <= 1'b0;  // Keep row always active
        end
    end
    
    // Key detection and decoding
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            button_out <= 3'b000;
            key_valid <= 1'b0;
        end else begin
            if (col != 3'b111) begin
                key_valid <= 1'b1;
                button_out <= ~col;  // Invert active-low input to active-high output
            end else begin
                key_valid <= 1'b0;
                button_out <= 3'b000;
            end
        end
    end

endmodule
