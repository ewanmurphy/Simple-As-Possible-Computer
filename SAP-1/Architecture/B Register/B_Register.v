`include "../../../7400/SN74LS173/SN74LS173.v"
module B_Register(bus_input, L_B_bar, CLK, add_sub_output);
   input [7:0] bus_input;
   input  L_B_bar;
   input  CLK;
   output [7:0] add_sub_output;

   wire [3:0] bus_input_first_nibble;
   wire [3:0] bus_input_second_nibble;
   assign {bus_input_second_nibble, bus_input_first_nibble} = bus_input;

   wire [3:0] add_sub_output_first_nibble;
   wire [3:0] add_sub_output_second_nibble;
   assign add_sub_output = {add_sub_output_second_nibble, add_sub_output_first_nibble};

   wire gnd = 0;

   SN74LS173 register_1(.D(bus_input_first_nibble), .Q(add_sub_output_first_nibble), .CLK(CLK), .CLR(gnd), .G_bar({2{L_B_bar}}), .M(gnd), .N(gnd));
   SN74LS173 register_2(.D(bus_input_second_nibble), .Q(add_sub_output_second_nibble), .CLK(CLK), .CLR(gnd), .G_bar({2{L_B_bar}}), .M(gnd), .N(gnd));

endmodule

module B_Register_tb;
   `ifdef B_Register_test
   reg [7:0] bus_input;
   reg L_B_bar;
   reg CLK;
   wire [7:0] add_sub_output;
   B_Register DUT(bus_input, L_B_bar, CLK, add_sub_output);

   initial begin
      // Waveform generation
      $dumpfile("B_Register_tb.vcd");
      $dumpvars(0, B_Register_tb);
      // Enable loading data into the B register
      L_B_bar = 0;
      // Set bus value
      bus_input = 8'hAC;
      CLK = 0;
      forever #1 CLK = ~CLK;
   end
   initial begin
      #2;
      // Disable loading data into the B register
      L_B_bar = 1;
      #1;
      // Set bus value
      bus_input = 8'hF1;
      #1;
      // Enable loading data into the B register
      L_B_bar = 0;
      #2;
      $finish;
   end
   `endif
endmodule
