`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:04:32 04/25/2018 
// Design Name: 
// Module Name:    binary_to_segment 
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
module binary_to_segment(
	 input [4:0] binary_in,
    output reg [6:0] seven
    );

always @(binary_in)
begin

    case(binary_in) 
															
        5'd0: seven =7'b0000001;           
        5'd1: seven =7'b1001111;           
        5'd2: seven =7'b0010010;            
        5'd3: seven =7'b0000110;           
		  5'd4: seven =7'b1001100;				
        5'd5: seven =7'b0100100;
        5'd6: seven =7'b0100000;
        5'd7: seven =7'b0001111;
        5'd8: seven =7'b0000000;
        5'd9: seven =7'b0000100;
        5'd10: seven = 7'b0001000;         
        5'd11: seven = 7'b1100000;          
        5'd12: seven  = 7'b0110001;         
		  5'd13: seven =7'b1000010;			
		  5'd14: seven = 7'b0110000;				
		  5'd15: seven = 7'b0111000;			
		  5'd16: seven = 7'b1111110;				
		  5'd17: seven = 7'b1110001;				
		  5'd18: seven = 7'b0100100;				
		  5'd19: seven = 7'b0011000;				
		  5'd20: seven = 7'b1101010;				
		  5'd21: seven  = 7'b1111111;				
		  5'd23: seven   = 7'b1100011;			
		  5'd24: seven  = 7'b1110000;		

			
        default: seven  = 7'h1;
    endcase
end

endmodule

