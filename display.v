module display(
    input clk,
    input rst,
    input [31:0] led_matrix,
    output reg [7:0] led_r,
    output reg [3:0] led_c
);
    // Use a smaller counter width for simulation to speed it up
    `ifdef SIM
        parameter WIDTH = 2; 
    `else
        parameter WIDTH = 16;
    `endif

    wire [WIDTH:0] count;
    
    counter #(.N(WIDTH)) display_counter (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    wire update = (count == 0);

    reg [1:0] select;
    always @(posedge update or negedge rst) begin
        if(~rst) begin
            select <= 0;
            led_r <= 0;
            led_c <= 0;
        end
        else begin
            select <= select + 1;
            led_r <= ~led_matrix[(8 * select) +: 8];
            led_c <= ~(4'b0001 << select);
        end
    end

endmodule