`ifndef SN74LS173
   `define SN74LS173
   `include "7400/SN74LS173/SN74LS173.v"
`endif
module Instruction_Register(L_I_bar, CLK, CLR, E_I_bar, bus_input, data, instruction);
   input  L_I_bar;
   input  CLK;
   input  CLR;
   input  E_I_bar;
   input [7:0] bus_input;
   output [3:0] data;
   output [3:0] instruction;

   wire [3:0] bus_input_first_nibble;
   wire [3:0] bus_input_second_nibble;
   assign {bus_input_second_nibble, bus_input_first_nibble} = bus_input;

   wire gnd = 0;

   SN74LS173 register_1(.D(bus_input_first_nibble), .Q(data), .CLK(CLK), .CLR(gnd), .G_bar({2{L_I_bar}}), .M(E_I_bar), .N(E_I_bar));
   SN74LS173 register_2(.D(bus_input_second_nibble), .Q(instruction), .CLK(CLK), .CLR(CLR), .G_bar({2{L_I_bar}}), .M(gnd), .N(gnd));
endmodule

module Instruction_Register_tb;
   `ifdef Instruction_Register_test
   reg L_I_bar;
   reg CLK;
   reg CLR;
   reg E_I_bar;
   reg [7:0] bus_input;
   wire [3:0] data;
   wire [3:0] instruction;

   Instruction_Register DUT(L_I_bar, CLK, CLR, E_I_bar, bus_input, data, instruction);

   initial begin
      // Waveform generation
      $dumpfile("Instruction_Register_tb.vcd");
      $dumpvars(0, Instruction_Register_tb);
      // Disable loading data into the Instruction register
      L_I_bar = 1;
      // Disable data output
      E_I_bar = 1;
      // Set bus value
      bus_input = 8'hAC;
      CLK = 0;
      forever #1 CLK = ~CLK;
   end
   initial begin
      // Clear the register
      CLR = 0; #1;
      CLR = 1; #1;
      CLR = 0; #1;
      // Enable loading data into the Instruction register
      L_I_bar = 0; #2;
      // Enable data output
      E_I_bar = 0; #2;
      // Set bus value
      bus_input = 8'h3D; #2;
      // Diable loading data into the Instruction register
      L_I_bar = 1; #2;
      // Set bus value
      bus_input = 8'hff; #2;
      // Disable data output
      E_I_bar = 1; #2;
      // Clear the register
      CLR = 0; #1;
      CLR = 1; #1;
      CLR = 0; #1;
      #5;

      $finish;
   end
   `endif
endmodule
