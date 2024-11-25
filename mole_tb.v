`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2024 05:26:23 PM
// Design Name: 
// Module Name: mole_tb
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


module mole_tb(
    );
    
    // Variables
    reg clk;
    reg reset;
    reg button; 
    wire mole;
    wire [3:0] score;
    wire [3:0] lives;
    wire [2:0] state;
    
    // Instantiate a whack-a-mole
    whack_a_mole WAM(clk, reset, button, mole, score, lives, state);
    
   
    
    // Making a clk:
    always #5 clk = ~ clk;
    
    // Initial block for stimulus
    initial begin
        // Initilize variables
        clk = 0;
        reset = 0;
        button = 0;
        // Apply reset
        reset = 1; #10;
        reset = 0; #10;
        // Test the IDLE state
        button = 1; #20;
        // Simulate gameplay state
        button = 0; #100; // Wait for mole to appear
        button = 1; #10;  // Hit mole
        button = 0; #50;
        // Test life decrement
        button = 1; #10; // Press to continue
        // Test ENDSCREEN state (when lives = 0)
        button = 0; #20; // Wait for end state to activate
        button = 1; #10;  // Press button to go back to IDLE state
        
        #500
        button = 0; #3500;
        button = 1; #50;
        button = 0; #200;
        button = 1; #20;
        // Finish Simulation
        $finish;
    end
endmodule













