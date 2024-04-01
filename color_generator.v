`timescale 1ns / 1ps

module color_generator(
    input clk,
    input reset,
    input [9:0] x_output,
    input [9:0] y_output,
    input video_output_signal,
    input [0:0] player_turn,
    input [2:0] player_column,
    input [83:0] input_board,
    input won,
    output reg [11:0] rgb
    );
    wire [1:0] board_state [0:5][0:6];
    assign board_state[5][6] = input_board[83:82];
    assign board_state[5][5] = input_board[81:80];
    assign board_state[5][4] = input_board[79:78];
    assign board_state[5][3] = input_board[77:76];
    assign board_state[5][2] = input_board[75:74];
    assign board_state[5][1] = input_board[73:72];
    assign board_state[5][0] = input_board[71:70];
    assign board_state[4][6] = input_board[69:68];
    assign board_state[4][5] = input_board[67:66];
    assign board_state[4][4] = input_board[65:64];
    assign board_state[4][3] = input_board[63:62];
    assign board_state[4][2] = input_board[61:60];
    assign board_state[4][1] = input_board[59:58];
    assign board_state[4][0] = input_board[57:56];
    assign board_state[3][6] = input_board[55:54];
    assign board_state[3][5] = input_board[53:52];
    assign board_state[3][4] = input_board[51:50];
    assign board_state[3][3] = input_board[49:48];
    assign board_state[3][2] = input_board[47:46];
    assign board_state[3][1] = input_board[45:44];
    assign board_state[3][0] = input_board[43:42];
    assign board_state[2][6] = input_board[41:40];
    assign board_state[2][5] = input_board[39:38];
    assign board_state[2][4] = input_board[37:36];
    assign board_state[2][3] = input_board[35:34];
    assign board_state[2][2] = input_board[33:32];
    assign board_state[2][1] = input_board[31:30];
    assign board_state[2][0] = input_board[29:28];
    assign board_state[1][6] = input_board[27:26];
    assign board_state[1][5] = input_board[25:24];
    assign board_state[1][4] = input_board[23:22];
    assign board_state[1][3] = input_board[21:20];
    assign board_state[1][2] = input_board[19:18];
    assign board_state[1][1] = input_board[17:16];
    assign board_state[1][0] = input_board[15:14];
    assign board_state[0][6] = input_board[13:12];
    assign board_state[0][5] = input_board[11:10];
    assign board_state[0][4] = input_board[9:8];
    assign board_state[0][3] = input_board[7:6];
    assign board_state[0][2] = input_board[5:4];
    assign board_state[0][1] = input_board[3:2];
    assign board_state[0][0] = input_board[1:0];
    
    // Colors in BGR format
    parameter red = 12'h00F; // Player 1
    parameter yellow = 12'h0FF; // Player 2
    parameter blue = 12'hF00; // Board 
    parameter black = 12'h000; // Background
    parameter white = 12'hFFF;
    
    // Screen specifications (640 x 480)
    parameter max_vertical = 480;
    parameter max_horizontal = 640;
    
    // Board specification
    wire board_x_on;
    assign board_x_on = ((y_output <= 475) && (y_output >= 115)) && (((x_output >= 110) && (x_output <= 114)) || ((x_output >= 166) && (x_output <= 174)) || ((x_output >= 226) && (x_output <= 234)) || ((x_output >= 286) && (x_output <= 294)) || ((x_output >= 346) && (x_output <= 354)) || ((x_output >= 406) && (x_output <= 414)) || ((x_output >= 466) && (x_output <= 474)) || ((x_output >= 526) && (x_output <= 530)));
    wire board_y_on;
    assign board_y_on = ((x_output >= 110) &&  (x_output <= 530)) && (((y_output <= 475) && (y_output >= 471)) || ((y_output <= 419) && (y_output >= 411)) || ((y_output <= 359) && (y_output >= 351)) || ((y_output <= 299) && (y_output >= 291)) || ((y_output <= 239) && (y_output >= 231)) || ((y_output <= 179) && (y_output >= 171)) || ((y_output <= 119) && (y_output >= 115)));
    wire board_on;
    assign board_on = board_x_on || board_y_on;
        
    // Piece specification (name specified in row_column order)
    parameter square_size = 56; 
    wire float_piece;
    reg float_piece_reg;
    assign float_piece = float_piece_reg;
    always @(*) begin
        case (player_column)
            1: float_piece_reg = ((x_output > 114) && (x_output < 166) && (y_output > 58) && (y_output < 110));
            2: float_piece_reg = ((x_output > 174) && (x_output < 226) && (y_output > 58) && (y_output < 110));
            3: float_piece_reg = ((x_output > 234) && (x_output < 286) && (y_output > 58) && (y_output < 110));
            4: float_piece_reg = ((x_output > 294) && (x_output < 346) && (y_output > 58) && (y_output < 110));
            5: float_piece_reg = ((x_output > 354) && (x_output < 406) && (y_output > 58) && (y_output < 110));
            6: float_piece_reg = ((x_output > 414) && (x_output < 466) && (y_output > 58) && (y_output < 110));
            7: float_piece_reg = ((x_output > 474) && (x_output < 526) && (y_output > 58) && (y_output < 110));
            default: float_piece_reg = 0;
        endcase
    end
    

    parameter x_left = 110;
    parameter x_right = 530;
    parameter y_top = 115;
    parameter y_bot = 475;
    
    // 6th row
    wire five_zero_piece_one;
    assign five_zero_piece_one = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][0] == 2'b01);
    wire five_zero_piece_two;
    assign five_zero_piece_two = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][0] == 2'b10);
    
    wire five_one_piece_one;
    assign five_one_piece_one = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][1] == 2'b01);
    wire five_one_piece_two;
    assign five_one_piece_two = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][1] == 2'b10);
        
    wire five_two_piece_one;
    assign five_two_piece_one = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][2] == 2'b01);
    wire five_two_piece_two;
    assign five_two_piece_two = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][2] == 2'b10);
    
    wire five_three_piece_one;
    assign five_three_piece_one = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][3] == 2'b01);
    wire five_three_piece_two;
    assign five_three_piece_two = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][3] == 2'b10);
    
    wire five_four_piece_one;
    assign five_four_piece_one = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][4] == 2'b01);
    wire five_four_piece_two;
    assign five_four_piece_two = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][4] == 2'b10);
    
    wire five_five_piece_one;
    assign five_five_piece_one = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][5] == 2'b01);
    wire five_five_piece_two;
    assign five_five_piece_two = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][5] == 2'b10);
    
    wire five_six_piece_one;
    assign five_six_piece_one = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][6] == 2'b01);
    wire five_six_piece_two;
    assign five_six_piece_two = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 0 * 60)) && (y_output > (y_bot - 56 - 0 * 60))) && (board_state[5][6] == 2'b10);

    
    // 5th row
    wire four_zero_piece_one;
    assign four_zero_piece_one = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][0] == 2'b01);
    wire four_zero_piece_two;
    assign four_zero_piece_two = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][0] == 2'b10);
    
    wire four_one_piece_one;
    assign four_one_piece_one = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][1] == 2'b01);
    wire four_one_piece_two;
    assign four_one_piece_two = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][1] == 2'b10);

    wire four_two_piece_one;
    assign four_two_piece_one = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][2] == 2'b01);
    wire four_two_piece_two;
    assign four_two_piece_two = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][2] == 2'b10);
    
    wire four_three_piece_one;
    assign four_three_piece_one = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][3] == 2'b01);
    wire four_three_piece_two;
    assign four_three_piece_two = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][3] == 2'b10);
    
    wire four_four_piece_one;
    assign four_four_piece_one = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][4] == 2'b01);
    wire four_four_piece_two;
    assign four_four_piece_two = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][4] == 2'b10);
    
    wire four_five_piece_one;
    assign four_five_piece_one = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][5] == 2'b01);
    wire four_five_piece_two;
    assign four_five_piece_two = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][5] == 2'b10);
    
    wire four_six_piece_one;
    assign four_six_piece_one = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][6] == 2'b01);
    wire four_six_piece_two;
    assign four_six_piece_two = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 1 * 60)) && (y_output > (y_bot - 56 - 1 * 60))) && (board_state[4][6] == 2'b10);

        
    // 4th row
    wire three_zero_piece_one;
    assign three_zero_piece_one = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][0] == 2'b01);
    wire three_zero_piece_two;
    assign three_zero_piece_two = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][0] == 2'b10);
    
    wire three_one_piece_one;
    assign three_one_piece_one = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][1] == 2'b01);
    wire three_one_piece_two;
    assign three_one_piece_two = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][1] == 2'b10);
    
    wire three_two_piece_one;
    assign three_two_piece_one = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][2] == 2'b01);
    wire three_two_piece_two;
    assign three_two_piece_two = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][2] == 2'b10);
    
    wire three_three_piece_one;
    assign three_three_piece_one = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][3] == 2'b01);
    wire three_three_piece_two;
    assign three_three_piece_two = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][3] == 2'b10);
    
    wire three_four_piece_one;
    assign three_four_piece_one = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][4] == 2'b01);
    wire three_four_piece_two;
    assign three_four_piece_two = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][4] == 2'b10);
    
    wire three_five_piece_one;
    assign three_five_piece_one = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][5] == 2'b01);
    wire three_five_piece_two;
    assign three_five_piece_two = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][5] == 2'b10);
    
    wire three_six_piece_one;
    assign three_six_piece_one = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][6] == 2'b01);
    wire three_six_piece_two;
    assign three_six_piece_two = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 2 * 60)) && (y_output > (y_bot - 56 - 2 * 60))) && (board_state[3][6] == 2'b10);

    
    // 3rd row
    wire two_zero_piece_one;
    assign two_zero_piece_one = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][0] == 2'b01);
    wire two_zero_piece_two;
    assign two_zero_piece_two = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][0] == 2'b10);
    
    wire two_one_piece_one;
    assign two_one_piece_one = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][1] == 2'b01);
    wire two_one_piece_two;
    assign two_one_piece_two = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][1] == 2'b10);
    
    wire two_two_piece_one;
    assign two_two_piece_one = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][2] == 2'b01);
    wire two_two_piece_two;
    assign two_two_piece_two = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][2] == 2'b10);
    
    wire two_three_piece_one;
    assign two_three_piece_one = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][3] == 2'b01);
    wire two_three_piece_two;
    assign two_three_piece_two = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][3] == 2'b10);
    
    wire two_four_piece_one;
    assign two_four_piece_one = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][4] == 2'b01);
    wire two_four_piece_two;
    assign two_four_piece_two = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][4] == 2'b10);
    
    wire two_five_piece_one;
    assign two_five_piece_one = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][5] == 2'b01);
    wire two_five_piece_two;
    assign two_five_piece_two = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][5] == 2'b10);
    
    wire two_six_piece_one;
    assign two_six_piece_one = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][6] == 2'b01);
    wire two_six_piece_two;
    assign two_six_piece_two = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 3 * 60)) && (y_output > (y_bot - 56 - 3 * 60))) && (board_state[2][6] == 2'b10);

    
    // 2nd row
    wire one_zero_piece_one;
    assign one_zero_piece_one = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][0] == 2'b01);
    wire one_zero_piece_two;
    assign one_zero_piece_two = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][0] == 2'b10);
    
    wire one_one_piece_one;
    assign one_one_piece_one = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][1] == 2'b01);
    wire one_one_piece_two;
    assign one_one_piece_two = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][1] == 2'b10);
    
    wire one_two_piece_one;
    assign one_two_piece_one = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][2] == 2'b01);
    wire one_two_piece_two;
    assign one_two_piece_two = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][2] == 2'b10);
    
    wire one_three_piece_one;
    assign one_three_piece_one = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][3] == 2'b01);
    wire one_three_piece_two;
    assign one_three_piece_two = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][3] == 2'b10);
    
    wire one_four_piece_one;
    assign one_four_piece_one = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][4] == 2'b01);
    wire one_four_piece_two;
    assign one_four_piece_two = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][4] == 2'b10);
    
    wire one_five_piece_one;
    assign one_five_piece_one = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][5] == 2'b01);
    wire one_five_piece_two;
    assign one_five_piece_two = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][5] == 2'b10);
    
    wire one_six_piece_one;
    assign one_six_piece_one = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][6] == 2'b01);
    wire one_six_piece_two;
    assign one_six_piece_two = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 4 * 60)) && (y_output > (y_bot - 56 - 4 * 60))) && (board_state[1][6] == 2'b10);
 
    
    // 1st row
    wire zero_zero_piece_one;
    assign zero_zero_piece_one = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][0] == 2'b01);
    wire zero_zero_piece_two;
    assign zero_zero_piece_two = ((x_output > (x_left + 4 + 0 * 60)) && (x_output < (x_left + 56 + 0 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][0] == 2'b10);
    
    wire zero_one_piece_one;
    assign zero_one_piece_one = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][1] == 2'b01);
    wire zero_one_piece_two;
    assign zero_one_piece_two = ((x_output > (x_left + 4 + 1 * 60)) && (x_output < (x_left + 56 + 1 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][1] == 2'b10);
    
    wire zero_two_piece_one;
    assign zero_two_piece_one = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][2] == 2'b01);
    wire zero_two_piece_two;
    assign zero_two_piece_two = ((x_output > (x_left + 4 + 2 * 60)) && (x_output < (x_left + 56 + 2 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][2] == 2'b10);
    
    wire zero_three_piece_one;
    assign zero_three_piece_one = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][3] == 2'b01);
    wire zero_three_piece_two;
    assign zero_three_piece_two = ((x_output > (x_left + 4 + 3 * 60)) && (x_output < (x_left + 56 + 3 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][3] == 2'b10);
    
    wire zero_four_piece_one;
    assign zero_four_piece_one = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][4] == 2'b01);
    wire zero_four_piece_two;
    assign zero_four_piece_two = ((x_output > (x_left + 4 + 4 * 60)) && (x_output < (x_left + 56 + 4 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][4] == 2'b10);
    
    wire zero_five_piece_one;
    assign zero_five_piece_one = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][5] == 2'b01);
    wire zero_five_piece_two;
    assign zero_five_piece_two = ((x_output > (x_left + 4 + 5 * 60)) && (x_output < (x_left + 56 + 5 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][5] == 2'b10);
    
    wire zero_six_piece_one;
    assign zero_six_piece_one = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][6] == 2'b01);
    wire zero_six_piece_two;
    assign zero_six_piece_two = ((x_output > (x_left + 4 + 6 * 60)) && (x_output < (x_left + 56 + 6 * 60)) && (y_output < (y_bot - 4 - 5 * 60)) && (y_output > (y_bot - 56 - 5 * 60))) && (board_state[0][6] == 2'b10);

        
    always @* begin
        if (~video_output_signal || reset) 
            rgb = black;         
        else begin
            if (board_on) begin
                rgb = blue;
            end
            else if (float_piece) begin
                if (player_turn) begin
                    rgb = yellow;
                end
                else begin
                    rgb = red;
                end 
            end
            else if (zero_zero_piece_one || zero_one_piece_one || zero_two_piece_one || zero_three_piece_one || zero_four_piece_one || zero_five_piece_one || zero_six_piece_one || one_zero_piece_one || one_one_piece_one || one_two_piece_one || one_three_piece_one || one_four_piece_one || one_five_piece_one || one_six_piece_one || two_zero_piece_one || two_one_piece_one || two_two_piece_one || two_three_piece_one || two_four_piece_one || two_five_piece_one || two_six_piece_one || three_zero_piece_one || three_one_piece_one || three_two_piece_one || three_three_piece_one || three_four_piece_one || three_five_piece_one || three_six_piece_one || four_zero_piece_one || four_one_piece_one || four_two_piece_one || four_three_piece_one || four_four_piece_one || four_five_piece_one || four_six_piece_one || five_zero_piece_one || five_one_piece_one || five_two_piece_one || five_three_piece_one || five_four_piece_one || five_five_piece_one || five_six_piece_one) begin
                rgb = red;
            end
            else if (zero_zero_piece_two || zero_one_piece_two || zero_two_piece_two || zero_three_piece_two || zero_four_piece_two || zero_five_piece_two || zero_six_piece_two || one_zero_piece_two || one_one_piece_two || one_two_piece_two || one_three_piece_two || one_four_piece_two || one_five_piece_two || one_six_piece_two || two_zero_piece_two || two_one_piece_two || two_two_piece_two || two_three_piece_two || two_four_piece_two || two_five_piece_two || two_six_piece_two || three_zero_piece_two || three_one_piece_two || three_two_piece_two || three_three_piece_two || three_four_piece_two || three_five_piece_two || three_six_piece_two || four_zero_piece_two || four_one_piece_two || four_two_piece_two || four_three_piece_two || four_four_piece_two || four_five_piece_two || four_six_piece_two || five_zero_piece_two || five_one_piece_two || five_two_piece_two || five_three_piece_two || five_four_piece_two || five_five_piece_two || five_six_piece_two) begin
                rgb = yellow;
            end
            else begin
                rgb = black;     
            end  
        end
    end
endmodule