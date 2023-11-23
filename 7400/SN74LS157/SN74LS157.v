module SN74LS157(A, B, Y, G_bar, SELECT);
   input G_bar, SELECT;
   input [4:1] A, B;
   output reg [4:1] Y;

   always @(*) begin
      if (G_bar) begin
          Y = 0;
      end else begin
          if (SELECT) begin
              Y = B;
          end else begin
              Y = A;
          end
      end
   end
endmodule

module SN74LS157_tb;
   reg g_bar;
   reg select;
   reg [4:1] a, b;
   wire [4:1] y;


   SN74LS157 DUT(.G_bar(g_bar), .SELECT(select), .A(a), .B(b), .Y(y));

   initial begin
      // Waveform generation
      $dumpfile("SN74LS157_tb.vcd");
      $dumpvars(0, SN74LS157_tb);

      // Force output to 0
      g_bar = 1;
      // Select input a
      select = 0;
      // Set initial values
      a = 3;
      b = 7;
      #1;
      // Stop forcing output to 0
      g_bar = 0;
      #1;
      // Select input b
      select = 1;
      #1
      // Force output to 0
      g_bar = 1;
      #1;
      // Change input a
      b = 4'hf;
      #1;
      // Stop forcing output to 0
      g_bar = 0;
      #1;
      // Select input a
      select = 0;
      #1
      $finish;
   end
endmodule
