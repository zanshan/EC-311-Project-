`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2024 03:54:39 PM
// Design Name: 
// Module Name: whack_a_mole
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


module whack_a_mole(
        input clk,
    input reset,
    input button,              // Debounced button input (fed from exernal module)
    output reg mole,           // Mole visibility (1 for mole shown, 0 for hidden)
    output reg [3:0] score,    // Player score
    output reg [3:0] lives,    // Player lives
    output reg [2:0] state     // Game state (IDLE, GAMEPLAY, END_SCREEN)
);

// Defining States 
reg IDLE = 3'b000;
reg GAMEPLAY = 3'b001;
reg END_SCREEN = 3'b010;

// Timer definitions
reg [7:0] mole_timer;        // Random timer for mole to appear (1-3 seconds) [DOULE CHECK if that many clk cycles corresponds to the second timings]
reg [7:0] hammer_timer;      // Time for hammer availability
reg button_prev;             // Previous button state to detect rising edge
reg [7:0] blink_counter;     // Counter for blinking in the end state
reg [7:0] random_num;        // Random number for mole_timer

// Note: I don't think the random number generator detailed below is working rn; As a task, turn it into extern module as input


// Reset Logic for timers, button, and RNG
always @(posedge clk or posedge reset) begin
    if (reset) begin
        mole_timer <= 0;        // Resetting the timer
        hammer_timer <= 0;      // Resetting the hammer timer
        button_prev <= 0;       // Initialize button_prev
        random_num <= 8'd0;     // Random number
        state <= 3'b000;
    end else begin
        // CLK updates for random num and button prev; timer logics will be handles in game loop for clarity.
        button_prev <= button;          // Update button_prev on every clock cycle; helps detect rising edge (button = 1, button prev = 0, every other combo is not it)
        random_num <= random_num + 1;   // change random number
    end
end


// Game logic state machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
    // Reset all variable
        state <= IDLE;
        score <= 4'b0000;    // begin with 0 score
        lives <= 4'b0011;    // Starting with 3 lives
        mole <= 0;
        mole_timer <= 0;
        hammer_timer <= 0;
        blink_counter <= 0;  // Used for blinking LED in END_SCREEN
    end else begin
        case(state)
            IDLE: begin
                mole <= 0;                          // turn mole LED off
                mole_timer <= 0;                    // Reset mole timer to 0 in IDLE state
                if (button && !button_prev) begin   // Detect rising edge of the button, on press goto GAMPLAY on next clk cycle
                    state <= GAMEPLAY;
                    // Initilizing gameplay variables
                    score <= 4'b0000;
                    lives <= 4'b0011;
                    mole_timer <= random_num[7:0] % 3 + 1;  // Random timer between 1 and 3 ? (Replace this code to interface with RNG module)
                    hammer_timer <= 8'd100;                 // 1 second for hammer timer
                end
            end
            
            GAMEPLAY: begin 
                // First, we will check if the game is over:
                if (lives == 0) begin
                        state <= 3'b010;  // GLITCH: breaks when it says end screen Go to end screen if no lives left. IDK why...
                end 
                
                // Next, we decrement the new mole timer, and check if it has hit 0:
                else if (mole_timer > 0) begin
                    mole_timer = mole_timer - 1;
                    
                    // if mole timer has hit zero, we turn mole on, triggering the start of hammer logic
                    if (mole_timer == 0) begin
                        mole <= 1;  // If 0, turn on the mole 
                    end
                end
                
                // Hammer timer logic starts only when mole turns on (ie mole timer = 0 and prev case does not trigger):
                else if (hammer_timer > 0 && mole == 1) begin
                    // decreases hammer timer every clk cycle until 0:
                    hammer_timer <= hammer_timer - 1; 
                    
                    // Check if user has pressed button while hammer timer is on only for rising edge (since holding does not count as a hit):
                    if (button && !button_prev) begin  
                        // If yes, get a point & reset mole & timer variables to restart the GAMEPLAY logic loop
                        score <= score + 1;      // Increment score on button press
                        mole <= 0;               // Turn mole off
                        mole_timer <= random_num[7:0] % 3 + 1;  // Reset mole timer to another randome variable (AGAIN, Change to work with external module)
                        hammer_timer <= 8'd100;  // Reset hammer timer
                    end 
                end 
                
                // We reach here when varaible have yet to reset and missed chance to hit button while timer was on (both timers are now 0)
                // Here, we handle the lose a life case:
                else if (hammer_timer == 0) begin
                    // Update lives and reset mole to zero
                    lives <= lives - 1;  
                    mole <= 0;
                    
                    // if this triggers, goto END SCREEN the next clk cycle (the other variable resets will happen later)
                    if (lives == 0) begin
                        state <= END_SCREEN;  // Go to end screen if no lives left
                    end 
                    
                    // If that did not trigger, then there are still lives remaining. Reset the timers to begin gameplay loop all over again
                    else begin
                        mole_timer <= random_num[7:0] % 3 + 1;  // Again, signal to MODIFY THIS in accordance to new RNG module
                        hammer_timer <= 8'd100;                 
                    end
                end
            end
            
            3'b010: begin
                // Mole LED will blink every second until button is pressed
                /*blink_counter <= blink_counter + 1;
                if (blink_counter == 8'd25000000) begin  // Toggle mole every second (assuming 100 MHz clock)
                    mole <= ~mole;                       // Toggle mole visibility
                    blink_counter <= 0;                  // reset counter for next time
                end*/
                
                // Waits in this state until a rising edge button press is detected, then sends to IDLE state.
                if (button && !button_prev) begin  
                    //state <= 3'b000;  // Reset to IDLE state next clk cycle
                    // Some of the assignemnts are redudent since they happen again in the idle state, just saying. However, if you later want to trim it down, trim the ones in the IDLE state instead
                    score <= 4'b0000;
                    lives <= 4'b0011; // Starting with 3 lives
                    mole <= 0;
                    mole_timer <= 0;
                    hammer_timer <= 0;
                    blink_counter <= 0;
                    state <= 3'b000;  // Reset to IDLE state next clk cycle
                end
            end
        endcase
    end
end

endmodule


