module Health_Block (
    input clk,
    input reset,
    input got_hit,
    input blocked,
    output reg [1:0] health,
    output reg [1:0] block
);
    reg prev_hit;
    reg prev_blocked;
    wire hit_flag = got_hit & ~prev_hit;
    wire block_flag = blocked & ~prev_blocked;
    
    // Maximum values
    localparam MAX_HEALTH = 2'd3;  // Can go up to 7 with 3-bit counter
    localparam MAX_BLOCK = 2'd3;   // Can go up to 7 with 3-bit counter
    localparam INITIAL_HEALTH = 2'd3;
    localparam INITIAL_BLOCK = 2'd3;
    
    initial begin
        health = INITIAL_HEALTH;
        block = INITIAL_BLOCK;
        prev_hit = 1'b0;
        prev_blocked = 1'b0;
    end 
    
    always @(posedge clk) begin
        if (reset) begin
            health <= INITIAL_HEALTH;
            block <= INITIAL_BLOCK;
            prev_hit <= 1'b0;
            prev_blocked <= 1'b0;
        end else begin
            prev_hit <= got_hit;
            prev_blocked <= blocked;
            
            // Health counter - decrements when hit
            if (hit_flag) begin
                if (health > 0) begin
                    health <= health - 1;
                end
                // If health is already 0, it stays at 0
            end
            
            // Block counter - decrements when blocked
            if (block_flag) begin
                if (block > 0) begin
                    block <= block - 1;
                end
                // If block is already 0, it stays at 0
            end
        end
    end
endmodule