module JK_FlipFlop(CLR_bar, CLK, J, K, Q, Q_bar);
   input CLR_bar;
   input CLK;
   input J;
   input K;
   output reg Q, Q_bar;

   always @(posedge CLK or posedge CLR_bar) begin
      if (~CLR_bar) begin
         Q <= 0;
         Q_bar <= 1;
      end
      else begin
         Q <= (J & Q_bar) | (~K & Q);
         Q_bar <= ~((J & Q_bar) | (~K & Q));
      end
   end
endmodule
module SN74LS107(CLK, CLR_bar_1, J_1, K_1, Q_1, Q_bar_1, CLR_bar_2, J_2, K_2, Q_2, Q_bar_2);
   input CLK;
   input CLR_bar_1, CLR_bar_2;
   input J_1, J_2;
   input K_1, K_2;
   output Q_1, Q_bar_1, Q_2, Q_bar_2;

   JK_FlipFlop FF_1(.CLR_bar(CLR_bar_1), .CLK(CLK), .J(J_1), .K(K_1), .Q(Q_1), .Q_bar(Q_bar_1));
   JK_FlipFlop FF_2(.CLR_bar(CLR_bar_2), .CLK(CLK), .J(J_2), .K(K_2), .Q(Q_2), .Q_bar(Q_bar_2));
endmodule

module SN74LS107_tb;
   reg CLK;
   reg CLR_bar_1, J_1, K_1;
   wire Q_1, Q_bar_1;
   reg CLR_bar_2, J_2, K_2;
   wire Q_2, Q_bar_2;


   SN74LS107 DUT(.CLK(CLK),
                 .CLR_bar_1(CLR_bar_1), .J_1(J_1), .K_1(K_1), .Q_1(Q_1), .Q_bar_1(Q_bar_1),
                 .CLR_bar_2(CLR_bar_2), .J_2(J_2), .K_2(K_2), .Q_2(Q_2), .Q_bar_2(Q_bar_2));
   initial begin
      CLK=0;
      forever #1 CLK = ~CLK;
   end
   initial begin
      // Waveform generation
      $dumpfile("SN74LS107_tb.vcd");
      $dumpvars(0, SN74LS107_tb);
      CLR_bar_1 = 0; CLR_bar_2 = 0;
      #2;
      CLR_bar_1 = 1;
      // Test flip-flop 1
      J_1 = 0; K_1 = 1; // Set Q = 0
      #2;
      J_1 = 0; K_1 = 0; // Hold value
      #2;
      J_1 = 1; K_1 = 0; // Set Q = 1
      #2;
      J_1 = 0; K_1 = 0; // Hold value
      #2;
      J_1 = 1; K_1 = 1; // Toggle value
      #2
      // Test flip-flop 2
      CLR_bar_2 = 1;
      J_2 = 1; K_2 = 0; // Set Q = 1
      #2;
      J_2 = 0; K_2 = 0; // Hold value
      #2;
      J_2 = 0; K_2 = 1; // Set Q = 0
      #2;
      J_2 = 0; K_2 = 0; // Hold value
      #2;
      J_2 = 1; K_2 = 1; // Toggle value
      #2
      $finish;
   end
endmodule
