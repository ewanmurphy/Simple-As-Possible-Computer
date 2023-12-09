`include "../../../7400/SN74LS173/SN74LS173.v"
`include "../../../7400/SN74LS157/SN74LS157.v"
module Input_and_MAR(L_M_bar, CLK, bus_input, address, program_data, run_or_prog);
   input L_M_bar;
   input CLK;
   input  [3:0] bus_input;
   output [3:0] address;

   input [3:0] program_data;
   input run_or_prog;


   wire [3:0] mar_output;

   wire gnd;
   assign gnd = 0;

   SN74LS173 mar(.D(bus_input), .Q(mar_output), .CLK(CLK), .CLR(gnd), .G_bar({2{L_M_bar}}), .M(gnd), .N(gnd));
   SN74LS157 mux(.A(program_data), .B(mar_output), .Y(address), .G_bar(gnd), .SELECT(run_or_prog));
   //SN74LS157 mux(.A(4'h1), .B(4'h2), .Y(address), .G_bar(gnd), .SELECT(run_or_prog));

endmodule

module Input_and_MAR_tb;
   `ifdef Input_and_MAR_test
   reg L_M_bar;
   reg CLK;
   reg [3:0] bus_address;
   wire [3:0] address;
   reg [3:0] programmer_address;
   reg run_or_prog;
   Input_and_MAR DUT(L_M_bar, CLK, bus_address, address, programmer_address, run_or_prog);

   initial begin
      // Waveform generation
      $dumpfile("Input_and_MAR_tb.vcd");
      $dumpvars(0, Input_and_MAR_tb);
      // Enable Loading instructions in the MAR
      L_M_bar = 0;
      // Set the mux to load the intruction from the MAR
      run_or_prog = 1;
      // Set bus data
      bus_address = 4'h3;
      // Set progmmer data
      programmer_address = 4'h7;
      CLK = 0;
      forever #1 CLK = ~CLK;
   end
   initial begin
      #2;
      // Set the mux to load programmer instruction
      run_or_prog = 0;
      // Disable loading into the MAR
      L_M_bar = 1;
      #1;
      // Change the data on the data bus
      bus_address = 4'hC;
      #1
      run_or_prog = 1;
      #1;
      // Re enable loading from the data bus
      L_M_bar = 0;
      #1
      $finish;
   end
   `endif
endmodule
