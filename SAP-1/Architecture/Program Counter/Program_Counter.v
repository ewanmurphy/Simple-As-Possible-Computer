`ifndef SN74LS107
   `define SN74LS107
   `include "7400/SN74LS107/SN74LS107.v"
`endif
`ifndef SN74LS126
   `define SN74LS126
   `include "7400/SN74LS126/SN74LS126.v"
`endif
module Program_Counter(C_P, CLK_bar, CLR_bar, E_P, address);
    input C_P;
    input CLK_bar;
    input CLR_bar;
    input E_P;
    output [3:0] address;

   wire [3:0] Q;
   SN74LS107 dualFF_1(.CLK_1(!CLK_bar), .CLR_bar_1(CLR_bar), .J_1(C_P), .K_1(C_P), .Q_1(Q[0]),
                      .CLK_2(!Q[0]), .CLR_bar_2(CLR_bar), .J_2(C_P), .K_2(C_P), .Q_2(Q[1]));
   SN74LS107 dualFF_2(.CLK_1(!Q[1]), .CLR_bar_1(CLR_bar), .J_1(C_P), .K_1(C_P), .Q_1(Q[2]),
                      .CLK_2(!Q[2]), .CLR_bar_2(CLR_bar), .J_2(C_P), .K_2(C_P), .Q_2(Q[3]));
   SN74LS126 tristateBuffer(.A(Q), .G({4{E_P}}), .Y(address));

endmodule

module Program_Counter_tb;
   `ifdef Program_Counter_test
   reg C_P;
   reg CLK_bar;
   reg CLR_bar;
   reg E_P;
   wire [3:0] address;

   Program_Counter DUT(C_P, CLK_bar, CLR_bar, E_P, address);
   initial begin
      CLK_bar = 1;
      forever #1 CLK_bar = ~CLK_bar;
   end
   initial begin
      // Waveform generation
      $dumpfile("Program_Counter_tb.vcd");
      $dumpvars(0, Program_Counter_tb);
      CLR_bar = 1;
      // Disable counting
      C_P = 0;
      // Enable output
      E_P = 1;
      // Clear the value
      #1;
      CLR_bar = 0;
      #1;
      CLR_bar = 1;
      #1;
      // Enable counting
      C_P = 1;
      #20;
      // Disable counting
      C_P = 0;
      #4;
      // Disable output
      E_P = 0;
      #4;
      $finish;
   end
   `endif
endmodule
