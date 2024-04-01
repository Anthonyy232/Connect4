`timescale 1ns / 1ps
module program(
    input clk,
    input sel_raw, 
    input start_raw,
    input reset_raw, 
    input left_raw,
    input right_raw,
    output [6:0] seg,
    output [3:0] anode,
    output [11:0] rgb,
    output vsync,
    output hsync
    );
    // Debounced button signals
    wire left_debounced;
    wire right_debounced;
    wire start_debounced;
    wire sel_debounced;
    wire reset_debounced;
    debouncer_button start(
        .clk(clk),
        .button_raw(start_raw),
        .debounced_button(start_debounced)
    );
    debouncer_button left(
        .clk(clk),
        .button_raw(left_raw),
        .debounced_button(left_debounced)
    );
    debouncer_button right(
        .clk(clk),
        .button_raw(right_raw),
        .debounced_button(right_debounced)
    );
    debouncer_button reset(
            .clk(clk),
            .button_raw(reset_raw),
            .debounced_button(reset_debounced)
    );
    debouncer_switch sel(
        .clk(clk),
        .button_raw(sel_raw),
        .debounced_switch(sel_debounced)
    );
        
    // Divided clock signals
    wire clk_1hz;
    wire clk_2hz;
    wire clk_blinking;
    wire clk_seven_segment;
    clkdiv clkdiv(
        .clk(clk), 
        .reset(reset_debounced), 
        .clk_1hz(clk_1hz), 
        .clk_2hz(clk_2hz), 
        .clk_blinking(clk_blinking), 
        .clk_seven_segment(clk_seven_segment)
    );
    
    wire [0:0] player_turn;
    wire [83:0] board_state; // 1D flattened board state
    wire [2:0] player_column; // Player's selection column (represented in decimal column 1->7
    wire [0:0] won;
    connectfour connectfour(
        .clk(clk),
        .reset(reset_debounced),
        .sel(sel_debounced),
        .start(start_debounced),
        .left(left_debounced),
        .right(right_debounced),
        .player_turn(player_turn),
        .output_board(board_state),
        .player_column_output(player_column),
        .won(won)
    );
    
    wire [3:0] three = 7'd1;
    wire [3:0] two = 7'd9;
    wire [3:0] one = 7'd9;
    wire [3:0] zero = 7'd2;

    // Digit -> 7seg conversion
    wire [6:0] three_seg;
    wire [6:0] two_seg;
    wire [6:0] one_seg;
    wire [6:0] zero_seg;
    seg_converter three_converter(
        .number(three),
        .reset(reset_debounced),
        .seg(three_seg)
    );
    seg_converter two_converter(
        .number(two),
        .reset(reset_debounced),
        .seg(two_seg)
    );
    seg_converter one_converter(
        .number(one),
        .reset(reset_debounced),
        .seg(one_seg)
    );
    seg_converter zero_converter(
        .number(zero),
        .reset(reset_debounced),
        .seg(zero_seg)
    );
    
    // Display to 7seg
    display_controller display_controller(
        .clk_seven_segment(clk_seven_segment),
        .clk_blinking(clk_blinking),
        .player_turn(player_turn),
        .won(won),
        .reset(reset_debounced),
        .three_seg(three_seg),
        .two_seg(two_seg),
        .one_seg(one_seg),
        .zero_seg(zero_seg),
        .seg(seg),
        .anode(anode)
    );

        wire [9:0] x_output;
        wire [9:0] y_output;
        wire clk_vga;
        wire video_output_signal;
        reg [11:0] rgb_buffer_1;
        wire [11:0] rgb_buffer_2;
        assign rgb = rgb_buffer_1;
        always @(posedge clk) begin
            if (clk_vga) begin
                rgb_buffer_1 <= rgb_buffer_2;
            end
        end
                
        vga_controller vga_controller(
            .clk(clk),
            .reset(reset_debounced),
            .clk_vga(clk_vga),
            .vsync(vsync),
            .hsync(hsync),
            .x_output(x_output),
            .y_output(y_output),
            .video_output_signal(video_output_signal)
        );

        color_generator color_generator(
            .clk(clk),
            .reset(reset_debounced),
            .x_output(x_output),
            .y_output(y_output),
            .video_output_signal(video_output_signal),
            .player_turn(player_turn),
            .player_column(player_column),
            .input_board(board_state),
            .won(won),
            .rgb(rgb_buffer_2)
        );
endmodule
