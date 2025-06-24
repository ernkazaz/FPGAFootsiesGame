module CPU_logic (
		input clock,
		input clock_bypass,
		input clock_manual_button,
		input reset,
		output [15:0] lfsr_output
);

wire clk_1Hz;
wire clk_60Hz;

   Clock_Divider #(.division(50000000)) clock_cpu (
        .clk_in    (clock),
        .clk_bypass(clock_bypass),
        .button    (clock_manual_button),
        .reset     (1'b0),
        .clk_out   (clk_1Hz)
	 );
	 

	LFSR_16bit my_lfsr(
		.clk(clk_1Hz),
		.reset(reset),
		.lfsr_out(lfsr_output)
	);

	endmodule