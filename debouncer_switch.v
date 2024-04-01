`timescale 1ns / 1ps
module debouncer_switch(
    input clk,
    input button_raw,
    output debounced_switch
    );
    reg tempDebounce1;
    reg tempDebounce2;
    reg tempDebounce3;
    assign debounced_switch = tempDebounce3;
    
    always @(posedge clk) begin
        tempDebounce1 <= button_raw;
        tempDebounce2 <= tempDebounce1;
        tempDebounce3 <= tempDebounce2;
    end
endmodule
