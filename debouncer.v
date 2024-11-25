`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2024 06:37:31 PM
// Design Name: 
// Module Name: debouncer
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 05:07:08 PM
// Design Name: 
// Module Name: debouncer
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

// Implament the given flow:

module debouncer(
    input clk,
    input button,
    output reg clean
    );
    
    // Variables
    wire [19:0] counter_max = 20'd1000;   // d'... is decimal, so max count = ten-thousand before stable
    reg [19:0] counter = 20'd00000;      
    reg button_reg = 1'b0;          // registered button state
    reg button_stable = 1'b0;       // stabilized button after debouncing
    
    // Wait one clock cycle
    always @(posedge clk) begin
        // Store value of current button state
        button_reg = button;
        
        // (button == clean) If button state has changed from stable to unstable, reset button counter 
        if(button_reg == button_stable) begin
            // (yes, then set to zero)
            counter = 20'd00000;
        // (no, is counter == max?)
        end else if (counter < counter_max) begin
            // (no, incrament counter)
            counter = counter + 1'b1; // Updates the stable button state
        end
        
        // (yes, clean assigned to button) When the counter reaches max val, button is stable
        else if(counter == counter_max) begin
            button_stable = button_reg; // Update the stable button state
        end   
           
        // (other half of assinging to button) Output the stable debounced state
        clean = button_stable;
    end
endmodule





