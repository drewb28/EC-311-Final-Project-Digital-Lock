`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:24:40 04/25/2018 
// Design Name: 
// Module Name:    SSD 
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
module SSD(
     input clk,
     input [4:0] digit1,
	  input [4:0] digit2,
	  input [4:0] digit3,
	  input [4:0] digit4,
	  input [7:0] current_state, 
	  input rst,
     output reg [3:0] AN,
     output [6:0] seven_out
    );

	parameter [7:0] idle = 8'd0;
	parameter [7:0] closed = 8'd1;
	parameter [7:0] open = 8'd2;
	parameter [7:0] unlock1 = 8'd3;
	parameter [7:0] unlock2 = 8'd4;
	parameter [7:0] unlock3 = 8'd5;
	parameter [7:0] unlock4 = 8'd6;
	parameter [7:0] lock1 = 8'd7;
	parameter [7:0] lock2 = 8'd8;
	parameter [7:0] lock3 = 8'd9;
	parameter [7:0] lock4 = 8'd10;
	parameter [7:0] passchecklock = 8'd11;
	parameter [7:0] passcheckunlock = 8'd12;
	parameter [7:0] changepass1 = 8'd13;
	parameter [7:0] changepass2 = 8'd14;
	parameter [7:0] changepass3 = 8'd15;
	parameter [7:0] changepass4 = 8'd16;
	parameter [7:0] setnewpass = 8'd17;
	parameter [7:0] old = 8'd18;
	parameter [7:0] old1 = 8'd19;
	parameter [7:0] old2 = 8'd20;
	parameter [7:0] old3 = 8'd21;
	parameter [7:0] old4 = 8'd22;
	parameter [7:0] new = 8'd23;
	parameter [7:0] new1 = 8'd24;
	parameter [7:0] new2 = 8'd25;
	parameter [7:0] new3 = 8'd26;
	parameter [7:0] new4 = 8'd27;

	


initial AN = 4'b1110;
reg [1:0] count = 0;
wire count2;
reg [4:0] seven_in;

binary_to_segment disp0(seven_in,seven_out);
wire ssd_clk;
clk_divider cd(.clk_in(clk),.rst(rst),.divided_clk(ssd_clk));
slowclk_divider cd2(.clk_in(clk),.rst(rst),.divided_clk(count2));


always @(posedge ssd_clk) begin
	  case (count)
		  0: begin
		  AN <= 4'b0111;
			 if(current_state == lock1 || current_state == unlock1 || current_state == changepass1 || current_state == old1 || current_state == new1)
				begin
				case(count2)
					0: begin
						seven_in <= digit1;
						end
					1:
					begin
						seven_in <= 5'd21;
					end
				endcase
				end
				else 
				begin
					seven_in <= digit1;
				end
				count <= count + 1'b1;
		  end
		  1: begin
			  AN <= 4'b1011;
			  if(current_state == lock2 || current_state == unlock2 || current_state == changepass2 || current_state == old2 || current_state == new2)
				begin
				case(count2)
					0: begin
						seven_in <= digit2;
						end
					1:
					begin
						seven_in <= 5'd21;
					end
				endcase
				end
				else 
				begin
					seven_in <= digit2;
				end
				count <= count + 1'b1;	
		 end
		  2: begin 
			  AN <= 4'b1101;
			  if(current_state == lock3 || current_state == unlock3 || current_state == changepass3 || current_state == old3 || current_state == new3)
				begin
				case(count2)
					0: begin
						seven_in <= digit3;
						end
					1:
					begin
						seven_in <= 5'd21;
					end
				endcase
				end
				else 
				begin
					seven_in <= digit3;
				end
				count <= count + 1'b1;			  
		 end
		  3: begin 
			  AN <= 4'b1110;
				if(current_state == lock4 || current_state == unlock4 || current_state == changepass4 || current_state == old4 || current_state == new4)
				begin
				case(count2)
					0: begin
						seven_in <= digit4;
						end
					1:
					begin
						seven_in <= 5'd21;
					end
				endcase
				end
				else 
				begin
					seven_in <= digit4;
				end	
				count <= count + 1'b1;	
    end
	 default: count <= 0;
    endcase

end

endmodule


