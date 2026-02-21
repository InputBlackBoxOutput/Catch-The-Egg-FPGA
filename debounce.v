module debounce(
    input  clk,
    input  btn,
    output pulse
);
    reg [2:0] sync;

    always @(posedge clk) begin
        sync <= {sync[1:0], btn};
    end

    assign pulse = (~sync[2]) & sync[1];
endmodule