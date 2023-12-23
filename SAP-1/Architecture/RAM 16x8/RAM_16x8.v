`ifndef SN74189
   `define SN74189
   `include "7400/SN74189/SN74189.v"
`endif
module RAM_16x8(address, CE_bar, memory_value, run_or_prog, read_or_write, programmer_data);
   input [3:0] address;
   input CE_bar;
   output [7:0] memory_value;
   input run_or_prog;
   input read_or_write;
   input [7:0] programmer_data;

   wire [3:0] ram_output_first_nibble;
   wire [3:0] ram_output_second_nibble;
   assign memory_value = {ram_output_second_nibble, ram_output_first_nibble};

   wire gnd = 0;

   wire chip_select = run_or_prog ? CE_bar : gnd;

   SN74189 ram_1(.A(address), .DI(programmer_data[3:0]), .DO(ram_output_first_nibble),  .S_bar(chip_select), .W_bar(read_or_write));
   SN74189 ram_2(.A(address), .DI(programmer_data[7:4]), .DO(ram_output_second_nibble), .S_bar(chip_select), .W_bar(read_or_write));
endmodule

module RAM_16x8_tb;
   `ifdef RAM_16x8_test
   reg [3:0] address;
   reg CE_bar;
   wire [7:0] memory_value;
   reg run_or_prog;
   reg read_or_write;
   reg [7:0] programmer_data;
   integer k, myseed;

   RAM_16x8 DUT(address, CE_bar, memory_value, run_or_prog, read_or_write, programmer_data);

   initial begin
      // Waveform generation
      $dumpfile("RAM_16x8_tb.vcd");
      $dumpvars(0, RAM_16x8_tb);
      // Drive the bus when in run mode
      CE_bar = 0;
      // Write data into memory
      run_or_prog = 0;
      read_or_write = 0;
      for (k=0; k<=15; k=k+1)
        begin
           programmer_data = (k-3) % 16; address = k; #1;
        end
      // Read data from memory
      run_or_prog = 1;
      read_or_write = 1;
      #1;
      repeat (20)
        begin
           address = $random(myseed) % 16;
           #1;
           $display ("Address : %2d, Data: %2d", address, memory_value);
        end
      CE_bar = 1;
      #5;
   end
   initial myseed = 314;
   `endif
endmodule
