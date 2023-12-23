`ifndef SN74LS173
   `define SN74LS173
   `include "7400/SN74LS173/SN74LS173.v"
`endif
module Output_Register(bus_input, L_O_bar, CLK, display_output);
   input L_O_bar;
   input CLK;
   input [7:0] bus_input;
   output [7:0] display_output;

   wire [3:0] bus_input_first_nibble;
   wire [3:0] bus_input_second_nibble;
   assign {bus_input_second_nibble, bus_input_first_nibble} = bus_input;

   wire [3:0] display_output_first_nibble;
   wire [3:0] display_output_second_nibble;
   assign display_output = {display_output_second_nibble, display_output_first_nibble};

   wire gnd = 0;

   SN74LS173 register_1(.D(bus_input_first_nibble), .Q(display_output_first_nibble), .CLK(CLK), .CLR(gnd), .G_bar({2{L_O_bar}}), .M(gnd), .N(gnd));
   SN74LS173 register_2(.D(bus_input_second_nibble), .Q(display_output_second_nibble), .CLK(CLK), .CLR(gnd), .G_bar({2{L_O_bar}}), .M(gnd), .N(gnd));
endmodule

module Output_Register_tb;
   `ifdef Output_Register_test
   reg [7:0] bus_input;
   reg L_O_bar;
   reg CLK;
   wire [7:0] display_output;
   Output_Register DUT(bus_input, L_O_bar, CLK, display_output);

   initial begin
      // Waveform generation
      $dumpfile("Output_Register_tb.vcd");
      $dumpvars(0, Output_Register_tb);
      // Enable loading instructions into the Output register
      L_O_bar = 0;
      // Set bus value
      bus_input = 8'h32;
      CLK = 0;
      forever #1 CLK = ~CLK;
   end
   initial begin
      #2;
      // Disable loading instructions into the Output register
      L_O_bar = 1;
      #1;
      // Set bus value
      bus_input = 8'hD8;
      #1;
      // Enable loading instructions into the Output register
      L_O_bar = 0;
      #2;
      $finish;
   end
   `endif
endmodule
