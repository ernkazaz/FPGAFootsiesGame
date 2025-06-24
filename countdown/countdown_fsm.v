module countdown_fsm (
    input wire clk,
    input wire reset,
    input wire go,
    output reg [1:0] digit,
    output reg active,
    output reg done
);

    // ================================================================
    // State Machine
    // ================================================================
    localparam [2:0]
        S_IDLE     = 3'd0,
        S_3        = 3'd1,
        S_2        = 3'd2,
        S_1        = 3'd3,
        S_GO       = 3'd4,
        S_DONE     = 3'd5;
        
    reg [2:0] state;
    reg [5:0] tick_count;  
    
    initial begin
        state       = S_IDLE;
        digit       = 2'd3;
        active      = 1'b0;
        done        = 1'b0;
        tick_count  = 6'd0;
    end
    
    always @(posedge clk) begin
        if (reset) begin
            state       <= S_IDLE;
            digit       <= 2'd3;
            active      <= 1'b0;
            done        <= 1'b0;
            tick_count  <= 6'd0;
        end
        else begin
            // Default: done only pulses for one cycle
            done <= 1'b0;
            
            case (state)
                S_IDLE: begin
                    active <= 1'b0;
                    if (go) begin
                        state      <= S_3;
                        digit      <= 2'd3;
                        active     <= 1'b1;
                        tick_count <= 6'd0;
                    end
                end
                
                S_3: begin
                    if (tick_count == 6'd59) begin
                        // after 60 ticks (1 sec), move to "2"
                        state      <= S_2;
                        digit      <= 2'd2;
                        tick_count <= 6'd0;
                    end else begin
                        tick_count <= tick_count + 1;
                    end
                end
                
                S_2: begin
                    if (tick_count == 6'd59) begin
                        state      <= S_1;
                        digit      <= 2'd1;
                        tick_count <= 6'd0;
                    end else begin
                        tick_count <= tick_count + 1;
                    end
                end
                
                S_1: begin
                    if (tick_count == 6'd59) begin
                        // after 60 ticks, move to "START"
                        state      <= S_GO;
                        digit      <= 2'd0;    // code "0" = "START"
                        tick_count <= 6'd0;
                    end else begin
                        tick_count <= tick_count + 1;
                    end
                end
                
                S_GO: begin
                    if (tick_count == 6'd29) begin  // 0.5 seconds for "START"
                        state      <= S_DONE;
                        active     <= 1'b0;    // turn off the "START" screen next cycle
                        done       <= 1'b1;    // one-cycle pulse
                        tick_count <= 6'd0;
                    end else begin
                        tick_count <= tick_count + 1;
                    end
                end
                
                S_DONE: begin 
					 end
                
                default: begin
                    state      <= S_IDLE;
                    digit      <= 2'd3;
                    active     <= 1'b0;
                    tick_count <= 6'd0;
                    done       <= 1'b0;
                end
            endcase
        end
    end

endmodule