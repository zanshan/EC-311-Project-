`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2024 04:33:38 PM
// Design Name: 
// Module Name: Debounced_WAM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Debounced_WAM(
    input clk,
    input reset,
    input button,              // Debounced button input (fed from exernal module)
    output reg mole,           // Mole visibility (1 for mole shown, 0 for hidden)
    output reg [3:0] score,    // Player score
    output reg [3:0] lives,    // Player lives
    output reg [2:0] state     // Game state (IDLE, GAMEPLAY, END_SCREEN)
    );
    
    wire clean;
    
    debouncer DEB(clk, button, clean);
    whack_a_mole(clk, reset, clean, mole, score, lives, state);
endmodule
