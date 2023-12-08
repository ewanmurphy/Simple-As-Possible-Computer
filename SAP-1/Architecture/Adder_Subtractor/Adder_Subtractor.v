`include "../../../7400/SN74LS83/SN74LS83.v"
`include "../../../7400/SN74LS126/SN74LS126.v"
module Adder_Subtractor(a_input, b_input, S_U, E_U, bus_output);
   input [7:0] a_input;
   input [7:0] b_input;
   input  S_U;
   input  E_U;
   output [7:0] bus_output;


   wire [3:0] a_input_first_nibble;
   wire [3:0] a_input_second_nibble;
   assign {a_input_second_nibble, a_input_first_nibble} = a_input;
   wire [3:0] b_input_first_nibble;
   wire [3:0] b_input_second_nibble;
   assign {b_input_second_nibble, b_input_first_nibble} = b_input ^ {8{S_U}};
   wire [3:0] result_first_nibble;
   wire [3:0] result_second_nibble;

   wire [3:0] bus_output_first_nibble;
   wire [3:0] bus_output_second_nibble;
   assign bus_output = {bus_output_second_nibble, bus_output_first_nibble};

   wire carry_between_nibbles;

   wire gnd = 0;

   SN74LS83 adder_1(.A(a_input_first_nibble), .B(b_input_first_nibble), .C0(S_U), .C4(carry_between_nibbles), .S(result_first_nibble));
   SN74LS83 adder_2(.A(a_input_second_nibble), .B(b_input_second_nibble), .C0(carry_between_nibbles), .C4(), .S(result_second_nibble));

   SN74LS126 tri_1(.A(result_first_nibble), .G({4{E_U}}), .Y(bus_output_first_nibble));
   SN74LS126 tri_2(.A(result_second_nibble), .G({4{E_U}}), .Y(bus_output_second_nibble));
endmodule

module Adder_Subtractor_tb;
   `ifdef Adder_Subtractor_test
   reg [7:0] a_input;
   reg [7:0] b_input;
   reg S_U;
   reg E_U;
   wire [7:0] bus_output;
   Adder_Subtractor DUT(a_input, b_input, S_U, E_U, bus_output);

   initial begin
      // Waveform generation
      $dumpfile("Adder_Subtractor_tb.vcd");
      $dumpvars(0, Adder_Subtractor_tb);
      // Set A input
      a_input = 8'd128;
      // Set B input
      b_input = 8'd32;
      // Set to adder mode
      S_U = 0;
      // Allow output to drive the bus
      E_U = 1;
      #1;
      // Don't let output to drive the bus
      E_U = 0;
      #1;
      // Set A input
      a_input = 8'd200;
      #1;
      // Allow output to drive the bus
      E_U = 1;
      #1;
      // Set to subtracter mode
      S_U = 1;
      #1;
   end
   `endif
endmodule
