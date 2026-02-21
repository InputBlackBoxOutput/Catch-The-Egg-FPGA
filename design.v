module game(
    input clk,
    
    input btn_1,       // Move right  [Active low]
    input btn_2,       // Move left   [Active low]
    input btn_rst,     // Reset/start [Active low]

    output led_r0, 
    output led_r1, 
    output led_r2, 
    output led_r3, 
    output led_r4, 
    output led_r5, 
    output led_r6, 
    output led_r7,
    
    output led_c0, 
    output led_c1, 
    output led_c2, 
    output led_c3
);

    // Debounce button
    wire rst;
    wire right;
    wire left;

    debounce db_rst(
        .clk(clk), 
        .btn(btn_rst), 
        .pulse(rst)
    );
    debounce db_right(
        .clk(clk), 
        .btn(btn_1), 
        .pulse(right)
    );
    debounce db_left(
        .clk(clk), 
        .btn(btn_2), 
        .pulse(left)
    );

    // Use a smaller counter width for simulation to speed it up
    `ifdef SIM
        parameter WIDTH = 4;
    `else
        parameter WIDTH = 22;
    `endif

    // Generate game tick
    wire [WIDTH : 0] tick_count;
    wire tick = (tick_count == 8'd0);

    counter #(.N(WIDTH)) tick_counter (
        .clk(clk),
        .rst(~rst),
        .count(tick_count)
    );

    // Render bucket and eggs using 8x8 LED matrix
    reg check;
    
    reg [31:0] egg;
    reg [1:0] x;
    
    reg [7:0] bucket;
    reg [2:0] y;
    
    wire [2:0] rnd;
    lfsr8 rng (
        .trigger(x == 2'b00), 
        .rnd(rnd)
    );

    always @(posedge clk) begin
        if (rst) begin
            check <= 1;
            bucket <= 8'h18;
            egg <= 32'h0000_0000;
            x <= 2'd0;
            y <= 3'd4;
        end 
        else begin
            if(check) begin
                // Generate egg at the top row and move it down every tick
                if (tick) begin
                    case (x)
                        2'b00: egg <= (egg & 32'h0000_00FF) | (8'h01 << rnd) << 24;
                        2'b01: egg <= (egg & 32'h0000_00FF) | (8'h01 << rnd) << 16;
                        2'b10: egg <= (egg & 32'h0000_00FF) | (8'h01 << rnd) << 8;
                        2'b11: egg <= 32'h0;
                    endcase

                    x <= x + 1;
                end

                // Move bucket left or right based on button presses
                if (right && y < 6) begin
                    bucket <= bucket >> 1;
                    y <= y + 1;
                end
                if (left && y > 1) begin
                    bucket <= bucket << 1;
                    y <= y - 1;
                end


                // Check if the egg was caught
                if(tick && (x == 2'b11)) begin
                    if (((bucket & (8'h01 << rnd)) == 0)) begin
                        check <= 0; 
                    end
                end
            end
            else begin
                bucket <= 8'h18;
                y <= 0;
                egg <= 32'h0000_0000;
                x <= 0;
            end
        end
    end

    // Display multiplexing logic
    wire [31:0] led_matrix = egg | {24'd0, bucket};

    display display(
        .clk(clk), 
        .rst(~rst),
        .led_matrix(led_matrix),
        .led_r({led_r7, led_r6, led_r5, led_r4, led_r3, led_r2, led_r1, led_r0}), 
        .led_c({led_c3, led_c2, led_c1, led_c0})
    );
endmodule