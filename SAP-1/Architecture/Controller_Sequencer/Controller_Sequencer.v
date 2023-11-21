module Controller_Sequencer(instruction, CLK, CLK_bar, CLR, CLR_bar, CON);
    input [3:0] instruction;
    output CLK;
    output CLK_bar;
    output CLR;
    output CLR_bar;
    output [11:0] CON;
endmodule

module Controller_Sequencer_tb;
endmodule
