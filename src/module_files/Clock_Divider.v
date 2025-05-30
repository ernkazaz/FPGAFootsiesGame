module Clock_Divider #(parameter division=2, parameter W=32)(
    input clk_in,
    input clk_bypass,
    input button,
    input reset,
    output reg clk_out
);

wire [W-1:0] counter;
reg [1:0] control;
reg prev_bypass;

// Counter module (assumed to increment on control == 2'b01)
Counter #(W) count_inst(
    .clk(clk_in),
    .control(control),
    .counter(counter)
);

always @(posedge clk_in) begin
    if (reset) begin
        control <= 2'b00;
        clk_out <= 0;
        prev_bypass <= 0;
    end else begin
        // Detect rising or falling edge of clk_bypass
        if (~clk_bypass && prev_bypass) begin
            // just transitioned from bypass to normal mode
            clk_out <= 0;
            control <= 2'b00; // force counter to restart
        end

        prev_bypass <= clk_bypass;

        if (clk_bypass) begin
            clk_out <= button;
            control <= 2'b00; // stop counting
        end else begin
            control <= 2'b01;
            if (counter == (division/2 - 1)) begin
                clk_out <= ~clk_out;
                control <= 2'b00;
            end
        end
    end
end

endmodule
