// Source:
// https://www.youtube.com/@dajoma36
// FPGADude on Pong and Frogger and Bouncing Square
`timescale 1ns / 1ps
module vga_controller(
    input clk,
    input reset,
    output clk_vga,
    output vsync,
    output hsync,
    output [9:0] x_output,
    output [9:0] y_output,
    output video_output_signal
    );
    
    /* Inner display of 640x480
       Specs by: FPGADude */
    parameter max_horizontal = 799;
    parameter visible_horizontal = 640;
    parameter horizontal_front_porch = 48;
    parameter horizontal_back_porch = 16;
    parameter horizontal_retrace = 96;
    parameter max_vertical = 524;
    parameter visible_vertical = 480;
    parameter vertical_front_porch = 10;
    parameter vertical_back_porch = 33;
    parameter vertical_retrace = 2;
    

    wire temp_vga;
	reg [1:0] counter_vga;
	assign temp_vga = (counter_vga == 0);
	always @(posedge clk or posedge reset) begin
		if (reset) begin
		  counter_vga <= 0;
		end
		else begin
		  counter_vga <= counter_vga + 1;
		end
	end
    
    //Double buffering for video output
    reg [9:0] temp_vertical;
    reg [9:0] vertical_buffer;
    reg [9:0] temp_horizontal;
    reg [9:0] horizontal_buffer;
    
    // Output Buffers
    reg temp_vsync;
    wire vsync_buffer;
    reg temp_hsync;
    wire hsync_buffer;
    
    assign x_output = temp_horizontal;
    assign y_output = temp_vertical;
    assign vsync = temp_vsync;
    assign hsync = temp_hsync;
    assign clk_vga = temp_vga;
    assign video_output_signal = (temp_horizontal < visible_horizontal) && (temp_vertical < visible_vertical); // 0-639 and 0-479 respectively
    assign vsync_buffer = (temp_vertical >= (visible_vertical+vertical_back_porch) && temp_vertical <= (visible_vertical+vertical_back_porch+vertical_retrace-1));
    assign hsync_buffer = (temp_horizontal >= (visible_horizontal+horizontal_back_porch) && temp_horizontal <= (visible_horizontal+horizontal_back_porch+horizontal_retrace-1));

    always @(posedge clk or posedge reset)
        if (reset) begin
            temp_vertical <= 0;
            temp_horizontal <= 0;
            temp_vsync <= 0;
            temp_hsync <= 0;
        end
        else begin
            temp_vertical <= vertical_buffer;
            temp_horizontal <= horizontal_buffer;
            temp_vsync <= vsync_buffer;
            temp_hsync <= hsync_buffer;
        end

    // Render every column then sweep to new row
    always @(posedge temp_vga or posedge reset) begin
        if(reset) begin
            horizontal_buffer = 0;
            vertical_buffer = 0;
        end
        else begin
            if(temp_horizontal == max_horizontal) begin
                horizontal_buffer = 0;
                if(temp_vertical == max_vertical) begin
                    vertical_buffer = 0;
                end
                else begin
                    vertical_buffer = temp_vertical + 1;
                end
            end
            else begin
                horizontal_buffer = temp_horizontal + 1;         
            end
        end
    end
endmodule