// Main counter control module
module counter_controller (
    input clk,              // System clock
    input reset,            // Reset signal
    input enable,           // Enable counting
    output reg [6:0] count  // Counter output (0-99)
);
    
    // Slow clock for counting (approximately 1 Hz)
    wire slow_clk;
    Clock_Divider #(.division(50000000), .W(32)) clk_div (
        .clk_in(clk),
        .clk_bypass(1'b0),
        .button(1'b0),
        .reset(reset),
        .clk_out(slow_clk)
    );
    
    // Counter logic
    always @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            count <= 7'd0;
        end else if (enable) begin
            if (count == 7'd99) begin
                count <= 7'd0;  // Wrap around at 99
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule