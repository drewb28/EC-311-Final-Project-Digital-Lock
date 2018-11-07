`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:16:24 04/25/2018 
// Design Name: 
// Module Name:    Final_Project 
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
	module Final_Project(
    input rst1,
	 input rst2,
    input clk,
    input ent1,
    input change1,
	 input clr1,
    output [6:0] ssd,
    output  [7:0] led,
	 output [3:0] AN,
    input [3:0] sw, 
	 input [3:0] sw2
    );
	reg [15:0] pp;
	reg [15:0] p;
	reg [15:0] temp;
	reg [15:0] cp;
	reg [15:0] np;
	reg [7:0] current_state;
	reg [7:0] next_state;
	reg [15:0] tempdigit;
	reg [4:0] digit1;	
	reg [4:0] digit2;
	reg [4:0] digit3;
	reg [4:0] digit4;
	
	
	//debouncer for all buttons
	wire rst, ent, clr, change, new_clk, slow_clk;
	reg [1:0] count;
	reg [19:0] counter3 = 0;
	
	clk_divider cd1(.clk_in(clk),.rst(rst2),.divided_clk(new_clk));
	slowestclk_divider cd3(.clk_in(clk),.rst(rst2),.divided_clk(slow_clk));
	debouncer debounce_ent(.clk(new_clk),.rst(rst2),.noisy_in(ent1),.clean_out(ent));
	debouncer debounce_clr(.clk(new_clk),.rst(rst2),.noisy_in(clr1),.clean_out(clr));
	debouncer debounce_change(.clk(new_clk),.rst(rst2),.noisy_in(change1),.clean_out(change));
	
	SSD	disp(.clk(clk),.digit1(digit1),.digit2(digit2),.digit3(digit3),.digit4(digit4),.current_state(current_state),.rst(rst2),.seven_out(ssd),.AN(AN));
	
	//parameter creations
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
	parameter IDLETOGGLE = 16'b0011101010011000;
	parameter [7:0] out = 8'd38;
	parameter halftoggle = 24'b101111101011110000100000;
	reg halfsecclock;
	reg [23:0] halfcounter;
	reg [1:0] try = 2'b11;
	reg [28:0] idlecounter;
	reg [11:0] outcounter;
	initial current_state = idle;
	
	
	
	// state transitions
always @ (posedge new_clk or posedge rst1)
	begin
			if(rst1)
				begin
				current_state <= idle;
				end
			else
				begin
				current_state <= next_state;
				end
			
	end
	
	//Idle always
	always @ (posedge new_clk)
		begin
			if(idlecounter == IDLETOGGLE)
				begin
					idlecounter <= 0;
				end
		else if(ent1 == 0 && rst1 == 0 && rst2==0 && change1 == 0 && clr1==0)
				begin
					idlecounter <= idlecounter + 1;
				end
		else
		begin
		idlecounter <= 0;
		end
		end
		
		
	 //outcounter
	always @ (posedge new_clk)
		begin
		if(current_state == out)
			begin
			outcounter <= outcounter +1;
			end
			else 
			begin
			outcounter <= 0;
			end
		end
	// next state definitions
always @ (*) 
		case(current_state)
		
		//idle state for begining
			idle:
				begin

					if(ent == 1'b1)
						begin
						next_state =unlock1;
						
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else
						begin
						next_state = current_state;
						end
					
				end
			//official locked state		
			closed:  
					begin
				
					
					if(ent == 1'b1)
						begin
							next_state = unlock1;
						 
						 end
						 else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else
						begin
							next_state = current_state;
						end

				end
			// official unlocked state									
			open:		
			begin
	
					if(ent == 1'b1)
						begin						
							next_state = lock1;
						end
					 else if(change1 == 1'b1)
						begin
							next_state = old;
							
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else
						begin
						next_state = current_state;
						end

			end		
			//first digit when trying to unlock the sysyem					
			unlock1:
			begin
					if(ent == 1'b1)
						begin 
						next_state = unlock2;
						
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else 
					begin
						next_state = current_state;
					end
			end		
			
			
			
			unlock2: //second digit
			begin
	
					if(ent == 1'b1)
						begin
						
						next_state = unlock3;
						end
					else if(clr == 1'b1) 
						begin
						
						next_state = unlock1;
					end
					else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end
			
			
			
			unlock3: //third digit
			begin
					
					if(ent == 1'b1)
						begin
						
						next_state = unlock4;
						end
					else if(clr == 1'b1) 
						begin
						
						next_state = unlock1;
					end
					else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end		
			
			
			
			unlock4: //fourth digit
			begin
		
					if(ent == 1'b1)
						begin
					
						next_state = passcheckunlock;
						end
						else if(clr == 1'b1) 
						begin
					
						next_state = unlock1;
					end
					else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end
			// first digit when attempting to relock the system
			lock1: //first digit
			begin
			
			
					if(ent == 1'b1)
						begin
						
						next_state = lock2;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin 
						next_state = current_state;
					end
			end
			lock2: //second digit
			begin
	
					
					if(ent == 1'b1)
						begin
						
						next_state = lock3;
						end
					else if(clr == 1'b1) 
						begin
						
						next_state = lock1;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end
			
			
			lock3: //thrid digit
			begin
		
					
					if(ent == 1'b1)
						begin
						
						next_state = lock4;
						end
						else if(clr == 1'b1) 
						begin
					
						next_state = lock1;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end
			
			
			lock4: //fourth digit
			begin

					if(ent == 1'b1)
						begin
						next_state = passchecklock;
					
						end
						else if(clr == 1'b1) 
						begin
					
						next_state = lock1;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
		end
			passcheckunlock: //checking the password to unlock the system
			
			begin
					if(cp[15:0] == p[15:0])
						begin
							next_state = open;
						end
							else 
							begin
							next_state = closed;
							end
						
			end
			passchecklock:
			begin
				if(np[15:0] == pp[15:0])
					begin
						next_state = setnewpass;
					end
				else 
				
							next_state = new;
							
					
			end
			
			
			old:// old password in comparison to changing password
				begin	
			 if(slow_clk == 1)
				begin
					next_state = old1;
					end
					else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
			else begin
				next_state = current_state;
				end
			end
			
			old1: 
			begin
			
			 if(ent == 1'b1)
						begin
						next_state = old2;
					
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
						else begin	
						next_state = current_state;
					end
				end

			
			old2:
			begin
			if(ent == 1'b1)
						begin
						
						next_state = old3;
						
						end
					else if(clr == 1'b1)
						begin
						
						next_state = old1;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end
			
			
			old3:
			begin
			if(ent == 1'b1)
						begin
						next_state = old4;
						end
						else if(clr == 1'b1)
						
						begin
						next_state = old1;
						end
			else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
			else begin	
						next_state = current_state;
					end
			end
			
			old4:
			begin
			if(ent == 1'b1)
						begin
						
						next_state = new;
						end
						else if(clr == 1'b1)
						begin
					
						next_state = old1;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end
		
		
			new:// new password to compare to old, if changing the password.
			begin	
			 if(slow_clk == 1)
				begin
					next_state = new1;
					end
					else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					
			else begin
				next_state = current_state;
				end
			end
			
					new1:
			begin
				if(ent == 1'b1)
						begin
					
						next_state = new2;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
						else begin	
						next_state = current_state;
					end
			
			end
			
			new2:
			begin
			if(ent == 1'b1)
						begin
					
						next_state = new3;
						end
					else if(clr == 1'b1)
						begin
						
						next_state = new1;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end
			
			
			new3:
			begin
			if(ent == 1'b1)
						begin
						
						next_state = new4;
						end
					else if(clr == 1'b1)
						begin
						
						next_state = new1;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end
			
			new4:
			begin
			if(ent == 1'b1)
						begin
						
						next_state = passchecklock;
						end
						else if(clr == 1'b1)
						begin
						
						next_state = new1;
						end
						else if(idlecounter == IDLETOGGLE)
					begin
						next_state = out;
					end
					else begin	
						next_state = current_state;
					end
			end
			
			
			setnewpass:
			begin
				next_state = closed;
			end
			
			out:
			begin
				if(outcounter == 12'b111110100000)
					next_state = closed;
				else
					next_state = current_state;
			end
		
			default:
			begin
				next_state = current_state;
			end
			
	endcase			
	


//controling the registers
always @ (posedge new_clk )
	begin
		case(current_state)
		
			passchecklock:
			begin
				if(np[15:0] == p[15:0])
				begin
				try[1:0] <= 2'b11;
				end
				else
				begin
				try <= try - 2'b01;
				end
				
			end
			
			passcheckunlock:
			begin
				if(cp[15:0] == p[15:0])
				begin
				try[1:0] <= 2'b11;
				end
				else
				begin
				try <= try - 2'b01;
				end
				
			end
			idle: 
				begin
					cp[15:0] <= 16'd0;
					try[1:0] <= 2'b11;
				end
			unlock1: 
				begin
					if(ent == 1'b1)
						begin
							
							p[3:0] <= sw[3:0];
							
						end
				end
			unlock2: 
				begin
					if(ent == 1'b1)
						begin
							p[7:4]	<= sw[3:0];
							
						end
									
		
				end
			unlock3: 
				begin
					if(ent == 1'b1)
						begin
							p[11:8]	<= sw[3:0];
							
						end
				
				end
			unlock4: 
				begin
					if(ent == 1'b1)
						begin
							p[15:12]	<= sw[3:0];
						
						end
	
				end
				
			lock1: 
				begin
					if(ent == 1'b1)
						begin
							p[3:0] <= sw[3:0];
						
						end
		
				end
			lock2: 
				begin
					if(ent == 1'b1)
						begin
							p[7:4]	<= sw[3:0];
						end
				
				end
			lock3: 
				begin
					if(ent == 1'b1)
						begin
							p[11:8]	<= sw[3:0];
						end
		
				end
			lock4: 
				begin
					if(ent == 1'b1)
						begin
							p[15:12]	<= sw[3:0];
						end
				end
						
			old1: 
				begin
					if(ent == 1'b1)
						begin
							pp[3:0] <= sw[3:0];
						
						end
		
				end
			old2: 
				begin
					if(ent == 1'b1)
						begin
							pp[7:4]	<= sw[3:0];
						end
				
				end
			old3: 
				begin
					if(ent == 1'b1)
						begin
							pp[11:8]	<= sw[3:0];
						end
		
				end
			old4: 
				begin
					if(ent == 1'b1)
						begin
							pp[15:12]	<= sw[3:0];
						end
				end
			
					new1: 
				begin
					if(ent == 1'b1)
						begin
							np[3:0] <= sw[3:0];
						
						end
		
				end
			new2: 
				begin
					if(ent == 1'b1)
						begin
							np[7:4]	<= sw[3:0];
						end
				
				end
			new3: 
				begin
					if(ent == 1'b1)
						begin
							np[11:8]	<= sw[3:0];
						end
		
				end
			new4: 
				begin
					if(ent == 1'b1)
						begin
							np[15:12]	<= sw[3:0];
						end
				end
			

			setnewpass:
				begin
					cp[15:0] <= np[15:0];
				end
		
			default:
				begin
				temp[15:0] <= p[15:0];
				end
				
		endcase
		// your code goes here
	end
//assigning all led's
assign led[7:0] = current_state;
// sequential part - outputs
always @ (posedge new_clk )
	begin
	case(current_state) 
			
			out:
			begin
				if(outcounter==10'b1111101000)
				begin
				digit1[4:0] <= 5'd0;
				digit2[4:0] <= 5'd23;
				digit3[4:0] <= 5'd24;
				digit4[4:0] <= 5'd21;
				end
				else if(outcounter == 11'b10000011010)
				begin
				digit1[4:0] <= 5'd21;
				digit2[4:0] <= 5'd21;
				digit3[4:0] <= 5'd21;
				digit4[4:0] <= 5'd21;
				end
				else if(outcounter==11'b11111010000)
				begin
				digit1[4:0] <= 5'd0;
				digit2[4:0] <= 5'd23;
				digit3[4:0] <= 5'd24;
				digit4[4:0] <= 5'd21;
				end
				else if (outcounter == 12'b100000000010)
			   begin
				digit1[4:0] <= 5'd21;
				digit2[4:0] <= 5'd21;
				digit3[4:0] <= 5'd21;
				digit4[4:0] <= 5'd21;
				end
				else if(outcounter==12'b101110111000)
				begin
				digit1[4:0] <= 5'd0;
				digit2[4:0] <= 5'd23;
				digit3[4:0] <= 5'd24;
				digit4[4:0] <= 5'd21;
				end
				else if (outcounter == 12'b101111101010)
				 begin
				digit1[4:0] <= 5'd21;
				digit2[4:0] <= 5'd21;
				digit3[4:0] <= 5'd21;
				digit4[4:0] <= 5'd21;
				end
			
			end
			
			idle:
			begin
				digit1[4:0] <= 5'd12; 	
				digit2[4:0] <= 5'd17;		
				digit3[4:0] <= 5'd18;		
				digit4[4:0] <= 5'd13; 			
			
			end
			
			closed:
			begin
				digit1[4:0] <= 5'd12; 	
				digit2[4:0] <= 5'd17;		
				digit3[4:0] <= 5'd18;		
				digit4[4:0] <= 5'd13; 		
				
			end
			
			open:
			begin
			digit1 <= 5'd0;
				digit2 <= 5'd19;
				digit3 <= 5'd14;
				digit4 <= 5'd20;
							
			end
			
			unlock1: 
			begin
			
			digit1[3:0] <= sw[3:0];
			digit1[4] <= 1'b0;
			digit2[4:0] <= 5'd21; 
			digit3[4:0] <= 5'd21;
			digit4[4:0] <= 5'd21;
			
			
			end
			
			unlock2: 
			begin
			digit1 <= 5'd16; 
			digit2 <= sw[3:0];
			digit3 <= 5'd21;
			digit4 <= 5'd21;
			end
			
			unlock3: 
			begin
			digit1 <= 5'd16; 
			digit3 <= sw[3:0];
			digit2 <= 5'd16;
			digit4 <= 5'd21;
			end
			
			unlock4: 
			begin
			digit1 <= 5'd16;
			digit4[3:0] <= sw[3:0];
			digit4[4] <= 1'b0;
			digit3 <= 5'd16;
			digit2 <= 5'd16;
			end
			
			lock1: 
			begin
			digit4 <= 5'd21; 
			digit1[3:0] <= sw[3:0];
			digit1[4] <= 1'b0;
			digit3 <= 5'd21;
			digit2 <= 5'd21;
			end
			
			lock2:
			begin
			digit1 <= 5'd16; 
			digit2[3:0] <= sw[3:0];
			digit2[4] <= 1'b0;
			digit3 <= 5'd21;
			digit4 <= 5'd21;
			end
			
				lock3: 
			begin
			digit1 <= 5'd16; 
			digit3[3:0] <= sw[3:0];
			digit3[4] <= 1'b0;
			digit4 <= 5'd21;
			digit2 <= 5'd16;
			end

			lock4: 
			begin

			digit1 <= 5'd16; 
			digit4[3:0] <= sw[3:0];
			digit4[4] <= 1'b0;
			digit3 <= 5'd16;
			digit2 <= 5'd16;
			end
			
			
			old1: 
			begin
			digit4 <= 5'd21; 
			digit1[3:0] <= sw[3:0];
			digit1[4] <= 1'b0;
			digit3 <= 5'd21;
			digit2 <= 5'd21;
			end
			
			old2: 
			begin
			digit1 <= pp[3:0]; 
			digit2[3:0] <= sw[3:0];
			digit2[4] <= 1'b0;
			digit3 <= 5'd21;
			digit4 <= 5'd21;
			end
			
				old3: 
			begin
			digit1 <= pp[3:0]; 
			digit3[3:0] <= sw[3:0];
			digit3[4] <= 1'b0;
			digit4 <= 5'd21;
			digit2 <= pp[7:4];
			end

			old4: 
			begin
			digit1 <= pp[3:0]; 
			digit4[3:0] <= sw[3:0];
			digit4[4] <= 1'b0;
			digit3 <= pp[11:8];
			digit2 <= pp[7:4];
			end
			
			
		passcheckunlock: 
			
			begin
			end
			
		passchecklock:
			begin
			end
		
			old1: 
			begin
			digit4 <= 5'd21; 
			digit1[3:0] <= sw[3:0];
			digit1[4] <= 1'b0;
			digit3 <= 5'd21;
			digit2 <= 5'd21;
			end
			
			old2: 
			begin
			digit1 <= pp[15:12]; 
			digit2[3:0] <= sw[3:0];
			digit2[4] <= 1'b0;
			digit3 <= 5'd21;
			digit4 <= 5'd21;
			end
			
				old3: 
			begin
			digit1 <= pp[15:12]; 
			digit3[3:0] <= sw[3:0];
			digit3[4] <= 1'b0;
			digit4 <= 5'd21;
			digit2 <= pp[11:8];
			end

			old4: 
			begin
			digit1 <= pp[15:12]; 
			digit4[3:0] <= sw[3:0];
			digit4[4] <= 1'b0;
			digit3 <= pp[7:4];
			digit2 <= pp[11:8];
			end


				new1: 
			begin
			digit4 <= 5'd21; 
			digit1[3:0] <= sw[3:0];
			digit1[4] <= 1'b0;
			digit3 <= 5'd21;
			digit2 <= 5'd21;
			end
			
			new2: 
			begin
			digit1 <= 5'd16; 
			digit2[3:0] <= sw[3:0];
			digit2[4] <= 1'b0;
			digit3 <= 5'd21;
			digit4 <= 5'd21;
			end
			
				new3: 
			begin
			digit1 <= 5'd16; 
			digit3[3:0] <= sw[3:0];
			digit3[4] <= 1'b0;
			digit4 <= 5'd21;
			digit2 <= 5'd16;
			end

			new4: 
			begin

			digit1 <= 5'd16; 
			digit4[3:0] <= sw[3:0];
			digit4[4] <= 1'b0;
			digit3 <= 5'd16;
			digit2 <= 5'd16;
			end
		
		
		old:
			begin

			digit1 <= 5'd21; 
			digit2 <= 5'd21;
			digit3 <= 5'd21;
			digit4 <= 5'd21;
			end
			
		new: 
			begin

			digit1 <= 5'd0; 
			digit2 <= 5'd19; 
 			digit3 <= 5'd14;
			digit4 <= 5'd20;
			end
			
		

		setnewpass:
		begin
		end
		
		default:
		begin
			digit1[3:0] <= p[3:0];
			digit1[4] <= 1'b0;
			digit2[3:0] <= p[7:4];
			digit2[4] <= 1'b0;
			digit3[3:0] <= p[11:8];
			digit3[4] <= 1'b0;
			digit4[3:0] <= p[15:12];
			digit4[4] <= 1'b0;
		end
	endcase

end
endmodule

