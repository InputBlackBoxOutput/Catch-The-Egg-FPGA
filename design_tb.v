`timescale 10ns/10ps
// Note: do not `include "design.v"` here - the build compiles source files separately
module testbench;

    // Generate clk signal
    reg clk = 0;
    always begin
       #1 clk = ~clk; 
    end 

    // Generate reset signal and mimic reset button press
    reg btn_rst;
    initial begin
        #0 btn_rst = 1; 
        #5 btn_rst = 0;
        #5 btn_rst = 1; 
    end

    // DUT signals
    wire led_r0; 
    wire led_r1; 
    wire led_r2; 
    wire led_r3;
    wire led_r4; 
    wire led_r5; 
    wire led_r6; 
    wire led_r7;
    wire [7:0] led_r = {led_r7, led_r6, led_r5, led_r4, led_r3, led_r2, led_r1, led_r0};

    wire led_c0; 
    wire led_c1; 
    wire led_c2; 
    wire led_c3;
    wire [3:0] led_c = {led_c3, led_c2, led_c1, led_c0};
 
    reg btn_1;
    reg btn_2;

    // DUT instantiation
    game dut(
    .clk(clk), 
    
    .led_r0(led_r0),
    .led_r1(led_r1),
    .led_r2(led_r2),
    .led_r3(led_r3),
    .led_r4(led_r4),
    .led_r5(led_r5),
    .led_r6(led_r6),
    .led_r7(led_r7),

    .led_c0(led_c0),
    .led_c1(led_c1),
    .led_c2(led_c2),
    .led_c3(led_c3),
    
    .btn_1(btn_1),
    .btn_2(btn_2),
    .btn_rst(btn_rst)
    );

    // Setup VCD dump for waveform viewing
    initial begin
        $dumpfile("simulation/dump.vcd");
        $dumpvars(0, dut);
    end

    // Tasks to simulate button presses
    task press_btn1;
        begin
            #0  btn_1 = 0;
            #10 btn_1 = 1;
        end
    endtask

    task press_btn2;
        begin
            #0  btn_2 = 0;
            #10 btn_2 = 1;
        end
    endtask

    // Simulate button presses
    initial begin
        #0 btn_1 = 1;
        #0 btn_2 = 1;

        // Check if bucket moved right
        #10 press_btn1();
        #6; // Wait 3 clk cycles 
        if(dut.y != 4 || dut.bucket != 8'h0C) begin 
            $error("Bucket should move right");
        end

        // Press button, wait 3 clk cycles and check if bucket moved right
        #10 press_btn2();
        #10 press_btn2();
        #6; // Wait 3 clk cycles
        if(dut.y != 2 || dut.bucket != 8'h30) begin 
            $error("Bucket should move left");
        end
    end

    // Check if egg is generated correctly
    always @(posedge clk) begin
        if(dut.tick && !dut.rst) begin
            #2; // Wait 1 clk cycles 
            case(dut.x)
                2'b00: if (dut.egg != 0) $error("Egg should be cleared after row 3");
                2'b01: if ((dut.egg & 32'hFF00_0000) == 0) $error("Egg should be generated in row 0");
                2'b10: if ((dut.egg & 32'h00FF_0000) == 0) $error("Egg should be generated in row 1");
                2'b11: if ((dut.egg & 32'h0000_FF00) == 0) $error("Egg should be generated in row 2");
            endcase
        end 
    end

    // Run simulation
    initial begin
        $display("Simulation started");
        
        #(200);
        $display("Simulation time: %0t ns", $time);

        $display("Simulation ended");
        $finish();
    end
endmodule