module SN74LS126(A, G, Y);
   input [4:1] A;
   input [4:1] G;
   output [4:1] Y;


   assign Y[1] = G[1] ? A[1] : 1'bZ;
   assign Y[2] = G[2] ? A[2] : 1'bZ;
   assign Y[3] = G[3] ? A[3] : 1'bZ;
   assign Y[4] = G[4] ? A[4] : 1'bZ;
endmodule

module SN74LS126_tb;
   `ifdef SN74LS126_test
   reg [4:1] a;
   reg [4:1] g;
   wire [4:1] y;

   SN74LS126 UUT (
        .A1(a[1]), .G1(g[1]), .Y1(y[1]),
        .A2(a[2]), .G2(g[2]), .Y2(y[2]),
        .A3(a[3]), .G3(g[3]), .Y3(y[3]),
        .A4(a[4]), .G4(g[4]), .Y4(y[4])
        );
   initial begin
        // Waveform generation
        $dumpfile("SN74LS126_tb.vcd");
        $dumpvars(0, SN74LS126_tb);

        a = 0;
        g = 0;
        for (int i=0; i<4; i=i+1) begin
            {g[1], a[1]} = i; #5;
        end
        for (int i=0; i<4; i=i+1) begin
            {g[2], a[2]} = i; #5;
        end
        for (int i=0; i<4; i=i+1) begin
            {g[3], a[3]} = i; #5;
        end
        for (int i=0; i<4; i=i+1) begin
            {g[4], a[4]} = i; #5;
        end
   end
   `endif
endmodule
