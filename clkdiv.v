`timescale 1ns / 1ps
module clkdiv(
    input clk, // 100 Mhz master clock
    input reset,
    output reg clk_1hz,
    output reg clk_2hz,
    output reg clk_blinking,
    output reg clk_seven_segment
    );
    reg [31:0] counter_1hz;
    reg [31:0] counter_2hz;
    reg [31:0] counter_blinking;
    reg [31:0] counter_seven_segment;
    
    initial begin
        counter_1hz = 0;
        counter_2hz = 0;
        counter_seven_segment = 0;
        counter_blinking = 0;
        clk_1hz = 0;
        clk_2hz = 0;
        clk_blinking = 0;
        clk_seven_segment = 0;
    end
    
    always @(posedge clk) begin
        if (reset) begin // Reset all states when reset signal is given
            counter_1hz <= 0;
            counter_2hz <= 0;
            counter_seven_segment <= 0;
            counter_blinking <= 0;
            clk_1hz <= 0;
            clk_2hz <= 0;
            clk_blinking <= 0;
            clk_seven_segment <= 0;
        end
        else begin
            // Formula: 100Mhz / Desired frequency
            // 1 Hz
            counter_1hz <= counter_1hz + 1;
            if (counter_1hz >= 50000000) begin
                counter_1hz <= 0;
                clk_1hz <= ~clk_1hz;
            end
        
            // 2 Hz
            counter_2hz <= counter_2hz + 1;
            if (counter_2hz >= 25000000) begin
                counter_2hz <= 0;
                clk_2hz <= ~clk_2hz;
            end
        
            // Blinking -> 3 Hz
            counter_blinking <= counter_blinking + 1;
            if (counter_blinking >= 16666666) begin
                counter_blinking <= 0;
                clk_blinking <= ~clk_blinking;
            end
        
            // Seven segment -> 381 Hz
            counter_seven_segment <= counter_seven_segment + 1;
            if (counter_seven_segment >= 262467) begin
                counter_seven_segment <= 0;
                clk_seven_segment <= ~clk_seven_segment;
            end
        end
    end
endmodule
