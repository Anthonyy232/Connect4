`timescale 1ns / 1ps
module display_controller(
    input clk_seven_segment,
    input clk_blinking,
    input player_turn, // 1 for player 1, 0 for player 2
    input won,
    input reset,
    input [6:0] three_seg,
    input [6:0] two_seg,
    input [6:0] one_seg,
    input [6:0] zero_seg,
    output reg [6:0] seg,
    output reg [3:0] anode
    );

    reg [1:0] digitCounter;

    initial begin
        digitCounter = 0;
        seg = zero_seg;
        anode = 4'b1110;
    end

    always @ (posedge clk_seven_segment) begin
            case (digitCounter)
                0: begin // 1st digit
                    if (player_turn) begin
                        if (clk_blinking) begin
                            seg = 7'b1111111;
                        end
                        else begin
                            seg = zero_seg;
                        end
                    end
                    else begin
                        seg = zero_seg;
                    end
                    anode = 4'b1110;
                    digitCounter <= digitCounter + 1;
                end
                1: begin // 2st digit
                    seg = one_seg;
                    anode = 4'b1101;
                    digitCounter <= digitCounter + 1;
                end
                2: begin // 3nd digit
                    seg = two_seg;
                    anode = 4'b1011;
                    digitCounter <= digitCounter + 1;
                end
                3: begin // 4rd digit
                    if (!player_turn) begin
                        if (clk_blinking) begin
                            seg = 7'b1111111;
                        end
                        else begin
                            seg = three_seg;
                        end
                    end
                    else begin
                        seg = three_seg;
                    end
                    anode = 4'b0111;
                    digitCounter <= 0;
                end
                default: begin
                    seg = zero_seg;
                    anode = 4'b1110;
                    digitCounter <= 0;
                end
            endcase 
        end
endmodule