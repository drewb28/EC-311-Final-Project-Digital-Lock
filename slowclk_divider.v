`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:26:53 04/25/2018 
// Design Name: 
// Module Name:    slowclk_divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module slowclk_divider(
    input clk_in,
    input rst,
    output reg divided_clk
    );

parameter toggle_value = 26'b10011000100101101000000000;

reg[25:0] cnt;

always@(posedge clk_in or posedge rst)
begin
    if (rst==1) begin
        cnt <= 0;
        divided_clk <= 0;
    end
    else begin
        if (cnt==toggle_value) begin
            cnt <= 0;
            divided_clk <= ~divided_clk;
        end
        else begin
            cnt <= cnt +1;
            divided_clk <= divided_clk;
        end
    end

end


endmodule
