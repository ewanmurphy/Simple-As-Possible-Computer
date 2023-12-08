module SN74LS173(D, Q, CLK, CLR, G_bar, M, N);
   input [4:1] D;
   output reg [4:1] Q;
   input [2:1] G_bar;
   input CLK, CLR, M, N;

   reg [4:1] Q_store;

   assign Q = (M | N) ? 4'hz : Q_store;

   always @(posedge CLK, CLR) begin
      if (CLR)
        Q_store <= 0;
      else
        if (!G_bar[1] && !G_bar[2])
          Q_store <= D;
   end
endmodule

module SN74LS173_tb;
   `ifdef SN74LS173_test
   reg [4:1] d;
   reg CLK;
   reg CLR;
   wire [4:1] q;
   reg m, n;
   reg [2:1] g_bar;
   SN74LS173 DUT(.D(d), .Q(q), .CLK(CLK), .CLR(CLR), .G_bar(g_bar), .M(m), .N(n));

   initial begin
      // Waveform generation
      $dumpfile("SN74LS173_tb.vcd");
      $dumpvars(0, SN74LS173_tb);
      $display("------------------");
      $display("Set Output to Q");
      m = 0;
      n = 0;
      $display("Enable Data Writing");
      g_bar = 2'b00;
      d = 4'h9;
      $display("Set Data to %h", d);
      CLK=0;
      $display("Enable Clear");
      CLR = 1;
      forever #1 CLK = ~CLK;
   end
   initial begin
      #1
      $display("Disable Clear");
      CLR = 0;
      #1;
      d = 4'h3;
      $display("Set Data to %h", d);
      #1
      $display("Set Output to High Impedence");
      m = 1;
      n = 1;
      #1;
      d = 4'hC;
      $display("Set Data to %h", d);
      #1
      $display("Set Output to Q");
      m = 0;
      n = 0;
      #1;
      $display("Disable Data Writing");
      g_bar = 2'b11;
      #1;
      d = 4'hF;
      $display("Set Data to %h", d);
      #1
      $display("------------------");
      $finish;
   end
   `endif
endmodule
