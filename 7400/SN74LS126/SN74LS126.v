module SN74LS126(
    input A1,G1, A2,G2, A3,G3, A4,G4,
    output Y1, Y2, Y3, Y4);

   assign Y1 = G1 ? A1 : 1'bZ;
   assign Y2 = G2 ? A2 : 1'bZ;
   assign Y3 = G3 ? A3 : 1'bZ;
   assign Y4 = G4 ? A4 : 1'bZ;
endmodule

module SN74LS126_tb;
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
   end // initial begin

endmodule
