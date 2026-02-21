module lfsr8 (
    input trigger,
    output [2:0] rnd
);
    reg [7:0] seed = 8'h35;
    
    always @(posedge trigger) begin
        seed <= {seed[7:0], seed[0] ^ seed[1] ^ seed[3] ^ seed[4]};
    end

    assign rnd = seed[2:0];
endmodule