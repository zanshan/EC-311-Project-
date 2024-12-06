module lfsr_random(
    input wire clk,
    input wire reset,
    output reg [31:0] random_num // Now 32 bits to hold four 8-bit random numbers
);

reg [7:0] lfsr;
wire feedback;
reg [1:0] sample_count; // 2-bit counter to count up to 4

// Feedback taps for an 8-bit LFSR using a primitive polynomial
assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        lfsr <= 8'h1; // Non-zero seed
    end else begin
        lfsr <= {lfsr[6:0], feedback}; // Shift left, insert feedback
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        random_num   <= 32'h0;
        sample_count <= 2'b00;
    end else begin
        // Store the current LFSR output into part of random_num
        case (sample_count)
            2'b00: random_num[7:0]   <= lfsr;
            2'b01: random_num[15:8]  <= lfsr;
            2'b10: random_num[23:16] <= lfsr;
            2'b11: random_num[31:24] <= lfsr;
        endcase
        
        // Increment the sample counter
        sample_count <= sample_count + 1'b1;
    end
end

endmodule
