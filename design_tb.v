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

    // Run simulation
    integer i;
    initial begin
        $display("Simulation started");
        
        for(i = 0; i < 100; i++) begin
            #(20_000);
            $display("Simulation time: %0t ns", $time);
        end

        $display("Simulation ended");
        $finish();
    end
endmodule