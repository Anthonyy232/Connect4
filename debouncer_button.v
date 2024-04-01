`timescale 1ns / 1ps
module debouncer_button(
    input clk,
    input button_raw,
    output reg debounced_button
    );
    reg [31:0] counter;
    reg debounced_button_temp1;
    reg debounced_button_temp2;
    
    //10ms debounce on the buttons
    always @(posedge clk) begin
        debounced_button_temp2 <= debounced_button_temp1;
        if (button_raw && !debounced_button_temp1) begin
            counter <= 0;
            debounced_button_temp1 <= 1;
        end else if (debounced_button_temp1) begin
            counter <= counter + 1;
            if (counter == 1000000) begin
                debounced_button <= 1;
            end
            if (counter == 1000001) begin
                debounced_button <= 0;
            end
        end
        
        if (!button_raw) begin
            debounced_button <= 0;
            debounced_button_temp1 <= 0;
        end
    end
endmodule


