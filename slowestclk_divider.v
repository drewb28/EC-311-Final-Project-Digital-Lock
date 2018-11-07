`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:24:09 04/25/2018 
// Design Name: 
// Module Name:    slowestclk_divider 
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
module slowestclk_divider(
    input clk_in,
    input rst,
    output reg divided_clk
    );

parameter toggle_value = 29'b10111110101111000010000000000;

reg[28:0] cnt;

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
