`timescale 1ns / 1ps
module seg_converter(
    input [3:0] number,
    input reset,
	output reg [6:0] seg
	);
	
	/*
	initial begin
	   seg = 7'b1111110;
	end

    always @(*) begin
        if (reset) begin
            seg = 7'b1111110;
        end
        else begin
            case(number)
                1: seg = 7'b1001111;
                2: seg = 7'b0010010;
                3: seg = 7'b1111110;
                default: seg = 7'b1111110;
            endcase
        end
    end
    */
        initial begin
           seg = 7'b1111110;
        end
        
        always @(*) begin
            if (reset) begin
                seg = 7'b1111110;
            end
            else begin
                case(number)
                    0: seg = 7'b0000001;
                    1: seg = 7'b1001111;
                    2: seg = 7'b0010010;
                    3: seg = 7'b0000110;
                    4: seg = 7'b1001100;
                    5: seg = 7'b0100100;
                    6: seg = 7'b0100000;
                    7: seg = 7'b0001101;
                    8: seg = 7'b1111110;
                    9: seg = 7'b1111110;
                    default: seg = 7'b1111110;
                endcase
            end
        end
endmodule