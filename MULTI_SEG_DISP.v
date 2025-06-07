module Multi_Seg_Disp(
    input sys_clk,
    input [2:0] ndigits,
    input [5:0] in7, in6, in5, in4, in3, in2, in1, in0,
    output reg [7:0] AN,
    output reg [7:0] display_out
);

// Refresh clock
reg d_clk;
integer i;
always @(posedge sys_clk)
begin
    if(i == 49999)
    begin
        i <= 0;
        d_clk <= ~d_clk;
    end
    else
        i <= i + 1;
end

// Digit scan counter
reg [2:0] count;
always @(posedge d_clk)
begin
    if(count == ndigits - 1)
        count <= 0;
    else
        count <= count + 1;        
end

reg [5:0] temp;
always @(posedge sys_clk)
begin
    case(count)
        3'b000: begin AN <= 8'b11111110; temp <= in0; end
        3'b001: begin AN <= 8'b11111101; temp <= in1; end
        3'b010: begin AN <= 8'b11111011; temp <= in2; end
        3'b011: begin AN <= 8'b11110111; temp <= in3; end
        3'b100: begin AN <= 8'b11101111; temp <= in4; end
        3'b101: begin AN <= 8'b11011111; temp <= in5; end
        3'b110: begin AN <= 8'b10111111; temp <= in6; end
        3'b111: begin AN <= 8'b01111111; temp <= in7; end
        default: begin AN <= 8'b11111111; temp <= 6'd0; end
    endcase
end

// Character decoder (7-segment values)
always @(posedge sys_clk) begin
    case (temp)
        // Digits
        6'd0  : display_out = 8'b00000011; // 0
        6'd1  : display_out = 8'b10011111; // 1
        6'd2  : display_out = 8'b00100101; // 2
        6'd3  : display_out = 8'b00001101; // 3
        6'd4  : display_out = 8'b10011001; // 4
        6'd5  : display_out = 8'b01001001; // 5
        6'd6  : display_out = 8'b01000001; // 6
        6'd7  : display_out = 8'b00011111; // 7
        6'd8  : display_out = 8'b00000001; // 8
        6'd9  : display_out = 8'b00001001; // 9

        // Letters (approximate for 7-segment)
        6'd10 : display_out = 8'b00010001; // A
        6'd11 : display_out = 8'b11000001; // b
        6'd12 : display_out = 8'b01100011; // C
        6'd13 : display_out = 8'b10000101; // d
        6'd14 : display_out = 8'b01100001; // E
        6'd15 : display_out = 8'b01110001; // F
        6'd16 : display_out = 8'b01000011; // G
        6'd17 : display_out = 8'b10010011; // H
        6'd18 : display_out = 8'b11111011; // I
        6'd19 : display_out = 8'b10001111; // J
        6'd20 : display_out = 8'b01110111; // K (approx)
        6'd21 : display_out = 8'b11100011; // L
        6'd22 : display_out = 8'b00010101; // M (approx)
        6'd23 : display_out = 8'b11010101; // N (approx)
        6'd24 : display_out = 8'b00000011; // O
        6'd25 : display_out = 8'b00110001; // P
        6'd26 : display_out = 8'b00011001; // Q (approx)
        6'd27 : display_out = 8'b11110101; // R (approx)
        6'd28 : display_out = 8'b01001001; // S
        6'd29 : display_out = 8'b11100001; // t (approx)
        6'd30 : display_out = 8'b10000011; // U
        6'd31 : display_out = 8'b11000011; // V (approx)
        6'd32 : display_out = 8'b10101011; // W (approx)
        6'd33 : display_out = 8'b10010001; // X (? H)
        6'd34 : display_out = 8'b10001001; // Y
        6'd35 : display_out = 8'b00100101; // Z (? 2)
        default: display_out = 8'b11111111; // blank
    endcase
end

endmodule