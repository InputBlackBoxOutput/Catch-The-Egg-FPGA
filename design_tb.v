`timescale 10ns/10ps
`include "design.v"

module testbench;

    reg CLK = 0;
    always #1 CLK = ~CLK; 

    wire LED_R0; 
    wire LED_R1; 
    wire LED_R2; 
    wire LED_R3;
    wire LED_R4; 
    wire LED_R5; 
    wire LED_R6; 
    wire LED_R7;

    wire LED_C0; 
    wire LED_C1; 
    wire LED_C2; 
    wire LED_C3;
    
    reg BTN_1;
    reg BTN_2;
    reg BTN_RST;

    game g(
    .CLK(CLK), 
    
    .LED_R0(LED_R0),
    .LED_R1(LED_R1),
    .LED_R2(LED_R2),
    .LED_R3(LED_R3),
    .LED_R4(LED_R4),
    .LED_R5(LED_R5),
    .LED_R6(LED_R6),
    .LED_R7(LED_R7),

    .LED_C0(LED_C0),
    .LED_C1(LED_C1),
    .LED_C2(LED_C2),
    .LED_C3(LED_C3),
    
    .BTN_1(BTN_1),
    .BTN_2(BTN_2),
    .BTN_RST(BTN_RST)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, g);
    end

    
    initial begin
        $display("Simluation started");
        $display("Simluation ended");

        // Buttons are active low
        BTN_1 = 1;
        BTN_2 = 1;
        BTN_RST = 1;

        #4 BTN_RST = 0;
        #2 BTN_RST = 1;

        #100000 $finish();
    end
endmodule