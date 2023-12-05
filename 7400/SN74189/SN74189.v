module SN74189(A, DI, DO, S_bar, W_bar);
   input [3:0] A;
   input [3:0] DI;
   output [3:0] DO;
   input S_bar, W_bar;

   reg [3:0] mem[15:0]; reg [3:0] d_out;

   assign DO = (!S_bar && W_bar) ? ~d_out : 4'hz;
   // Write
   always @(A, DI, S_bar, W_bar)
     if (!S_bar && !W_bar) mem[A] = DI;
   // Read
   always @(A, S_bar, W_bar)
     if (!S_bar && W_bar) d_out = mem[A];
endmodule

module SN74189_tb;
   reg [3:0] address;
   wire [3:0] data_out;
   reg [3:0] data_in;
   reg write_bar, select_bar;
   integer k, myseed;

   SN74189 DUT (address, data_in, data_out, select_bar, write_bar);

   initial
     begin
        $dumpfile("SN74189_tb.vcd");
        $dumpvars(0, SN74189_tb);
        for (k=0; k<=15; k=k+1)
          begin
             data_in = (k+5) % 16; address = k; write_bar = 0; select_bar = 0; #2;
          end
        repeat (20)
          begin
             address = $random(myseed) % 16;
             write_bar = 1; select_bar = 0;
             #2;
             $display ("Address : %2d, Data: %2d", address, ~data_out);
          end
     end
   initial myseed = 314;
endmodule
