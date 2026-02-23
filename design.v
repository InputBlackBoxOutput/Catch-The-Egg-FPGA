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

    debounce db_rst  (.clk(clk), .btn(btn_rst), .pulse(rst));
    debounce db_right(.clk(clk), .btn(btn_1),   .pulse(right));
    debounce db_left (.clk(clk), .btn(btn_2),   .pulse(left));

    // Use a smaller counter width for simulation to speed it up
    `ifdef SIM
        parameter WIDTH = 4;
    `else
        parameter WIDTH = 23;
    `endif

    // Generate game tick
    wire [WIDTH - 1 : 0] tick_count;
    wire tick = (tick_count == 0);

    counter #(.N(WIDTH)) tick_counter (
        .clk(clk),
        .rst(rst),
        .count(tick_count)
    );

    // Generate random number using LFSR
    wire [2:0] rnd;
    lfsr8 rng (.trigger(x == 2'b00), .rnd(rnd));

    reg [7:0] bucket;
    reg [2:0] y;

    // Move bucket left or right based on button presses
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            bucket <= 8'h18;
            y <= 3'd3;
        end
        else begin
            if(check) begin
                if (right && y < 6) begin
                    bucket <= bucket >> 1;
                    y <= y + 1;
                end
                
                if (left && y > 0) begin
                    bucket <= bucket << 1;
                    y <= y - 1;
                end
            end
            else begin
                bucket <= 8'h18;
                y <= 3'd3;
            end
        end
    end

    reg [31:0] egg;
    reg [1:0] x;

    // Generate egg at the top row and move it down every tick
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            egg <= 32'h0000_0000;
            x <= 2'd0;
        end
        else begin
            if(tick && check) begin
                case (x)
                    2'b00: egg <= (egg & 32'h0000_00FF) | (8'h01 << rnd) << 24;
                    2'b01: egg <= (egg & 32'h0000_00FF) | (8'h01 << rnd) << 16;
                    2'b10: egg <= (egg & 32'h0000_00FF) | (8'h01 << rnd) << 8;
                    2'b11: egg <= 32'h0;
                endcase
                x <= x + 1;
            end
        end
    end


    // Check if the egg was caught
    reg check;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            check <= 1;
        end 
        else begin
            if(check && tick && (x == 2'b11)) begin
                if (((bucket & (8'h01 << rnd)) == 0)) begin
                    check <= 0; 
                end
            end
        end
    end


    // Display multiplexing logic
    wire [31:0] led_matrix = egg | {24'd0, bucket};

    display display(
        .clk(clk), 
        .rst(rst),
        .led_matrix(led_matrix),
        .led_r({led_r7, led_r6, led_r5, led_r4, led_r3, led_r2, led_r1, led_r0}), 
        .led_c({led_c3, led_c2, led_c1, led_c0})
    );
endmodule