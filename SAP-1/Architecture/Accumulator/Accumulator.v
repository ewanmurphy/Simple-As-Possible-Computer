`ifndef SN74LS173
   `define SN74LS173
   `include "7400/SN74LS173/SN74LS173.v"
`endif
`ifndef SN74LS126
   `define SN74LS126
   `include "7400/SN74LS126/SN74LS126.v"
`endif
module Accumulator(bus_input, L_A_bar, E_A, CLK, bus_output, add_sub_output);
   input  [7:0] bus_input;
   input  L_A_bar;
   input  E_A;
   input  CLK;
   output [7:0] bus_output;
   output [7:0] add_sub_output;

   wire [3:0] bus_input_first_nibble;
   wire [3:0] bus_input_second_nibble;
   assign {bus_input_second_nibble, bus_input_first_nibble} = bus_input;

   wire [3:0] accumulator_output_first_nibble;
   wire [3:0] accumulator_output_second_nibble;
   assign add_sub_output = {accumulator_output_second_nibble, accumulator_output_first_nibble};

   wire gnd = 0;

   SN74LS173 register_1(.D(bus_input_first_nibble), .Q(accumulator_output_first_nibble), .CLK(CLK), .CLR(gnd), .G_bar({2{L_A_bar}}), .M(gnd), .N(gnd));
   SN74LS173 register_2(.D(bus_input_second_nibble), .Q(accumulator_output_second_nibble), .CLK(CLK), .CLR(gnd), .G_bar({2{L_A_bar}}), .M(gnd), .N(gnd));

   wire [3:0] bus_output_first_nibble;
   wire [3:0] bus_output_second_nibble;
   assign bus_output = {bus_output_second_nibble, bus_output_first_nibble};
   SN74LS126 tri_1(.A(accumulator_output_first_nibble), .G({4{E_A}}), .Y(bus_output_first_nibble));
   SN74LS126 tri_2(.A(accumulator_output_second_nibble), .G({4{E_A}}), .Y(bus_output_second_nibble));
endmodule

module Accumulator_tb;
   `ifdef Accumulator_test
   reg [7:0] bus_input;
   reg L_A_bar;
   reg E_A;
   reg CLK;
   wire [7:0] add_sub_output;
   wire [7:0] bus_output;
   Accumulator DUT(bus_input, L_A_bar, E_A, CLK, bus_output, add_sub_output);

   initial begin
      // Waveform generation
      $dumpfile("Accumulator_tb.vcd");
      $dumpvars(0, Accumulator_tb);
      // Enable loading data into the Accumulator
      L_A_bar = 0;
      // Disable loading accumulator output on to the bus
      E_A = 0;
      // Set bus value
      bus_input = 8'hAC;
      CLK = 0;
      forever #1 CLK = ~CLK;
   end
   initial begin
      #1;
      // Enable loading accumulator output on to the bus
      E_A = 1;
      #1;
      // Disable loading data into the Accumulator
      L_A_bar = 1;
      #1;
      // Set bus value
      bus_input = 8'hF1;
      #1;
      // Enable loading data into the Accumulator
      L_A_bar = 0;
      #2;
      // Disable loading accumulator output on to the bus
      E_A = 0;
      #1;
      $finish;
   end
   `endif
endmodule
