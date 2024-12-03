module lfsr_random(
    input wire clk,
    input wire reset,
    output reg [7:0] random_num
);

reg [7:0] lfsr;
wire feedback;

// Feedback taps for an 8-bit LFSR using a primitive polynomial
assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        lfsr <= 8'h1; // Non-zero seed value to start the LFSR
    end else begin
        lfsr <= {lfsr[6:0], feedback}; // Shift left and insert feedback bit
    end
end

// Output the current LFSR value as the random number
always @(posedge clk or posedge reset) begin
    if (reset) begin
        random_num <= 8'h0;
    end else begin
        random_num <= lfsr;
    end
end

endmodule
