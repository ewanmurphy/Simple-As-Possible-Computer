module SN74LS83(A, B, C0, C4, S);
   input [3:0] A;
   input [3:0] B;
   input C0;
   output C4;
   output [3:0] S;

   assign {C4, S} = A + B + C0;
endmodule

module SN74LS83_tb;
   `ifdef SN74LS83_test
   reg [3:0] a;
   reg [3:0] b;
   reg carry_in;
   wire carry_out;
   wire [3:0] sum;
   integer myseed;

   SN74LS83 DUT(a, b, carry_in, carry_out, sum);

   initial
     begin
        $dumpfile("SN74LS83.vcd");
        $dumpvars(0, SN74LS83_tb);
        repeat (20)
          begin
             a = $random(myseed) % 16;
             b = $random(myseed) % 16;
             carry_in = $random(myseed) % 2;
             #2;
             $display ("%2d + %2d + %2d = %2d, Carry = %2d", a, b, carry_in, sum+16*carry_out, carry_out);
          end
     end
   initial myseed = 314;
   `endif
endmodule
