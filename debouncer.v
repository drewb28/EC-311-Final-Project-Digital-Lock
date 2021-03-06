`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:22 04/25/2018 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer(
    input       clk,
    input       rst,
    input       noisy_in, 
    output reg  clean_out 
    );


reg noisy_in_reg;

reg clean_out_tmp1; 
reg clean_out_tmp2; 

always@(posedge clk or posedge rst)
begin
    if (rst==1'b1) begin
        noisy_in_reg <= 0;
        clean_out_tmp1 <= 0;
        clean_out_tmp2 <= 0;

        clean_out <= 0;
    end
    else begin
        noisy_in_reg <= noisy_in; 
                clean_out_tmp1 <= noisy_in_reg;

       
            clean_out_tmp2 <= clean_out_tmp1;
            clean_out <= ~clean_out_tmp2 & clean_out_tmp1; 

    end

end


endmodule

