`timescale 1ns / 1ps
/*
       1   2   3   4   5   6   7
     +---+---+---+---+---+---+---+
     |   |   |   |   |   |   |   |
     +---+---+---+---+---+---+---+
     |   |   |   |   |   |   |   |
     +---+---+---+---+---+---+---+
     |   |   |   |   |   |   |   |
     +---+---+---+---+---+---+---+
     |   |   |   |   |   |   |   |
     +---+---+---+---+---+---+---+
     |   |   |   |   |   |   |   |
     +---+---+---+---+---+---+---+
     |   |   |   |   |   |   |   |
     +---+---+---+---+---+---+---+
*/
module connectfour(
    input clk,
    input reset,
    input sel,
    input start,
    input left,
    input right,
    output [83:0] output_board,
    output reg [2:0] player_column_output,
    output reg [0:0] player_turn, // 0 for player 1's turn, 1 for player 2's turn
    output reg [0:0] won
    );
    reg [2:0] player_column;
    reg [1:0] board_state [0:5][0:6]; // Connect4 board for 6 rows, 7 columns represented by 00 (0=empty, 1 = player 1, 2 = player 2)
    assign output_board =       {board_state[5][6], board_state[5][5], board_state[5][4], board_state[5][3], board_state[5][2], board_state[5][1], board_state[5][0],
    /* 3D Array -> 1D*/          board_state[4][6], board_state[4][5], board_state[4][4], board_state[4][3], board_state[4][2], board_state[4][1], board_state[4][0],
                                 board_state[3][6], board_state[3][5], board_state[3][4], board_state[3][3], board_state[3][2], board_state[3][1], board_state[3][0],
                                 board_state[2][6], board_state[2][5], board_state[2][4], board_state[2][3], board_state[2][2], board_state[2][1], board_state[2][0],
                                 board_state[1][6], board_state[1][5], board_state[1][4], board_state[1][3], board_state[1][2], board_state[1][1], board_state[1][0],
                                 board_state[0][6], board_state[0][5], board_state[0][4], board_state[0][3], board_state[0][2], board_state[0][1], board_state[0][0]};
                                 
    reg game_started; // 0 if game hasn't started, 1 if game has started
    integer i;
    integer j;
    integer open; // The index of the next open row from the bottom up based on player_column. -1 if no open column
    
    initial begin
        game_started = 0;
        player_turn = !sel;
        player_column = 3'd4;
        won = 0;
        
        // Set board state to 0 
        i = 0;
        j = 0;
        for (i = 0; i <= 5; i = i+1) begin
            for (j = 0; j <= 6; j = j+1) begin
                board_state[i][j] = 2'b00;
            end
        end
    end
    always @(posedge clk) begin
        player_column_output <= player_column;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            game_started <= 0;
            player_turn <= sel;
            player_column <= 3'd4;
            won <= 0;
            
            // Set board state to 0 
            i <= 0;
            j <= 0;
            for (i = 0; i <= 5; i = i+1) begin
                for (j = 0; j <= 6; j = j+1) begin
                    board_state[i][j] = 2'b00;
                end
            end
        end
        else if (start && !game_started && !won) begin
            game_started <= 1;
        end
        
        if (!game_started && !start && !reset && !won) begin
            player_turn <= sel;
        end
        else if (game_started && !reset && !won) begin
            if (left) begin
                // Handles game behavior for shifting player's position left. Must check to ensure it doesn't move past column 1
                if (player_column > 1) begin
                    player_column = player_column - 1;
                end
            end
            else if (right) begin
                // Handles game behavior for shifting player's position right. Must check to ensure it doesn't move past column 7
                if (player_column < 7) begin
                    player_column = player_column + 1;
                end
            end
            else if (start) begin
                open = -1;
                i = 0;
                for (i = 0; i < 6; i = i+1) begin // Search from the top to the bottom of the column and find an empty spot
                    if (board_state[i][player_column-1] == 2'b00) begin
                        open = i;
                    end
                end
                
                if (open >= 0) begin
                    if (!player_turn) begin // Player 1
                        board_state[open][player_column-1] = 2'b01;
                        player_column = 3'd4;
                        
                        // Check horizontally
                        i = 0;
                        j = 0;
                        for (i = 0; i < 6; i = i+1) begin
                            for (j = 0; j < 4; j = j+1) begin
                                if ((board_state[i][j] == 2'b01) && (board_state[i][j+1] == 2'b01) && (board_state[i][j+2] == 2'b01) && (board_state[i][j+3] == 2'b01)) begin
                                    won = 1;
                                end
                            end
                        end
                        // Check vertically
                        i = 0;
                        j = 0;
                        for (i = 0; i < 3; i = i+1) begin
                            for (j = 0; j < 7; j = j+1) begin
                                if ((board_state[i][j] == 2'b01) && (board_state[i+1][j] == 2'b01) && (board_state[i+2][j] == 2'b01) && (board_state[i+3][j] == 2'b01)) begin
                                    won = 1;
                                end
                            end
                        end
                        // Check diagonal /
                        i = 0;
                        j = 0;
                        for (i = 3; i < 6; i = i+1) begin
                            for (j = 0; j < 4; j = j+1) begin
                                if ((board_state[i][j] == 2'b01) && (board_state[i-1][j+1] == 2'b01) && (board_state[i-2][j+2] == 2'b01) && (board_state[i-3][j+3] == 2'b01)) begin
                                    won = 1;
                                end
                            end
                        end
                        // Check diagonal \
                        i = 0;
                        j = 0;
                        for (i = 3; i < 6; i = i+1) begin
                            for (j = 3; j < 7; j = j+1) begin
                                if ((board_state[i][j] == 2'b01) && (board_state[i-1][j-1] == 2'b01) && (board_state[i-2][j-2] == 2'b01) && (board_state[i-3][j-3] == 2'b01)) begin
                                    won = 1;
                                end
                            end
                        end
                    end
                    else begin // Player 2
                        board_state[open][player_column-1] = 2'b10;
                        player_column = 3'd4;
                        
                        // Check horizontally
                        i = 0;
                        j = 0;
                        for (i = 0; i < 6; i = i+1) begin
                            for (j = 0; j < 4; j = j+1) begin
                                if ((board_state[i][j] == 2'b10) && (board_state[i][j+1] == 2'b10) && (board_state[i][j+2] == 2'b10) && (board_state[i][j+3] == 2'b10)) begin
                                    won = 1;
                                end
                            end
                        end
                        // Check vertically
                        i = 0;
                        j = 0;
                        for (i = 0; i < 3; i = i+1) begin
                            for (j = 0; j < 7; j = j+1) begin
                                if ((board_state[i][j] == 2'b10) && (board_state[i+1][j] == 2'b10) && (board_state[i+2][j] == 2'b10) && (board_state[i+3][j] == 2'b10)) begin
                                    won = 1;
                                end
                            end
                        end
                       // Check diagonal /
                        i = 0;
                        j = 0;
                        for (i = 3; i < 6; i = i+1) begin
                            for (j = 0; j < 4; j = j+1) begin
                                if ((board_state[i][j] == 2'b10) && (board_state[i-1][j+1] == 2'b10) && (board_state[i-2][j+2] == 2'b10) && (board_state[i-3][j+3] == 2'b10)) begin
                                    won = 1;
                                end
                            end
                        end
                        // Check diagonal \
                        i = 0;
                        j = 0;
                        for (i = 3; i < 6; i = i+1) begin
                            for (j = 3; j < 7; j = j+1) begin
                                if ((board_state[i][j] == 2'b10) && (board_state[i-1][j-1] == 2'b10) && (board_state[i-2][j-2] == 2'b10) && (board_state[i-3][j-3] == 2'b10)) begin
                                    won = 1;
                                end
                            end
                        end
                    end
                    if (!won) begin
                        player_turn = !player_turn;
                    end
                end
            end
        end
    end
endmodule
