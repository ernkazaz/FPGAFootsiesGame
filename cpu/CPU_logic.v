module CPU_logic (
		input clock,
		input clock_bypass,
		input clock_manual_button,
		input reset,
		input cpu_enable,
		output reg [2:0] cpu_inputs
);

wire clk_1Hz;
wire clk_60Hz;
wire [15:0] lfsr_output;

    Clock_Divider #(.division(50000000)) clock_cpu (
        .clk_in    (clock),
        .clk_bypass(clock_bypass),
        .button    (clock_manual_button),
        .reset     (1'b0),
        .clk_out   (clk_1Hz)
	 );
	 
    Clock_Divider #(.division(833334)) clock_cpu2 (
        .clk_in    (clock),
        .clk_bypass(clock_bypass),
        .button    (clock_manual_button),
        .reset     (1'b0),
        .clk_out   (clk_60Hz)
	 );	 
	 
    lfsr_16bit cpu_lfsr (
        .clk(clk_1Hz),
        .seed(16'hACE0),        // Initial random seed
        .lfsr_out(lfsr_output)
    );
	 
//    always @(posedge clk_60Hz) begin
//        if (reset) begin
//            //cpu_inputs <= 3'b000;
//        end 
//    end	 
	 
	 always @(posedge clk_1Hz) begin
		  if (cpu_enable) begin
            cpu_inputs <= lfsr_output[2:0]; // Use 3 LSBs for random buttons
        end
	 end

endmodule





