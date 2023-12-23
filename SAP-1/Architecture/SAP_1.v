`include "SAP-1/Architecture/Accumulator/Accumulator.v"
`include "SAP-1/Architecture/Adder_Subtractor/Adder_Subtractor.v"
`include "SAP-1/Architecture/B Register/B_Register.v"
`include "SAP-1/Architecture/Controller_Sequencer/Controller_Sequencer.v"
`include "SAP-1/Architecture/Input and MAR/Input_and_MAR.v"
`include "SAP-1/Architecture/Instruction Register/Instruction_Register.v"
`include "SAP-1/Architecture/Output Register/Output_Register.v"
`include "SAP-1/Architecture/Program Counter/Program_Counter.v"
`include "SAP-1/Architecture/RAM 16x8/RAM_16x8.v"
module SAP_1(CLK, CLK_bar, CLR, CLR_bar, programmer_address, run_or_prog, programmer_data, read_or_write, display, HLT_bar);
   input CLK, CLK_bar;
   input CLR, CLR_bar;
   output [7:0] display;
   output HLT_bar;

   // Signals for progamming the SAP-1
   input [3:0] programmer_address;
   input [7:0] programmer_data;
   input read_or_write;
   input run_or_prog;

   // W Bus
   wire [7:0] W_bus;

   // Controll Bus Wires
   wire C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar;

   // Control Unit
   Program_Counter program_counter(.C_P(C_P), .CLK_bar(CLK_bar), .CLR_bar(CLR_bar), .E_P(E_P), .address(W_bus[3:0]));
   wire [3:0] instruction;
   Instruction_Register instruction_register(.L_I_bar(L_I_bar), .CLK(CLK), .CLR(CLR), .E_I_bar(E_I_bar), .bus_input(W_bus), .data(W_bus[3:0]), .instruction(instruction));
   Controller_Sequencer controller_sequencer(.instruction(instruction), .CLK(CLK), .CLR_bar(CLR_bar), .C_P(C_P), .E_P(E_P), .L_M_bar(L_M_bar), .CE_bar(CE_bar), .L_I_bar(L_I_bar), .E_I_bar(E_I_bar), .L_A_bar(L_A_bar), .E_A(E_A), .S_U(S_U), .E_U(E_U), .L_B_bar(L_B_bar), .L_O_bar(L_O_bar), .HLT_bar(HLT_bar));

   // Memory Unit
   wire [3:0] address;
   Input_and_MAR input_and_mar(.L_M_bar(L_M_bar), .CLK(CLK), .bus_address(W_bus[3:0]), .address(address), .programmer_address(programmer_address), .run_or_prog(run_or_prog));
   RAM_16x8 ram_16x8(.address(address), .CE_bar(CE_bar), .memory_value(W_bus), .run_or_prog(run_or_prog), .read_or_write(read_or_write), .programmer_data(programmer_data));

   // ALU
   wire [7:0] accumulator_add_sub_output;
   Accumulator accumulator(.bus_input(W_bus), .L_A_bar(L_A_bar), .E_A(E_A), .CLK(CLK), .bus_output(W_bus), .add_sub_output(accumulator_add_sub_output));
   wire [7:0] B_add_sub_output;
   B_Register b_register(.bus_input(W_bus), .L_B_bar(L_B_bar), .CLK(CLK), .add_sub_output(B_add_sub_output));
   Adder_Subtractor adder_subtractor(.a_input(accumulator_add_sub_output), .b_input(B_add_sub_output), .S_U(S_U), .E_U(E_U), .bus_output(W_bus));

   // I/O
   Output_Register output_register(.bus_input(W_bus), .L_O_bar(L_O_bar), .CLK(CLK), .display_output(display));
endmodule

module SAP_1_tb;
   `ifdef SAP_1_test
   reg clock;
   assign CLK = clock;
   assign CLK_bar = !clock;
   reg clear;
   assign CLR = clear;
   assign CLR_bar = !clear;
   wire [7:0] display;
   wire HLT_bar;
   integer k;

   // Signals for progamming the SAP-1
   reg [3:0] programmer_address;
   reg [7:0] programmer_data;
   reg read_or_write;
   reg run_or_prog;

   SAP_1 DUT(CLK, CLK_bar, CLR, CLR_bar, programmer_address, run_or_prog, programmer_data, read_or_write, display, HLT_bar);

   reg [7:0] temp_mem [0:15];

   // Generate Clock Signals
   initial begin
      $readmemh("../Programs/program_3.txt", temp_mem);
      clock = 0; #17;
      forever #1 clock = ~clock;
   end
   initial begin
      // Waveform generation
      $dumpfile("SAP_1_tb.vcd");
      $dumpvars(0, SAP_1_tb);
      // Program the SAP-1
      read_or_write = 0;
      run_or_prog = 0;
      for (k=0; k<=15; k=k+1)
        begin
           programmer_data = ~temp_mem[k]; programmer_address = k; #1;
        end
      // Put the SAP-1 in running mode
      read_or_write = 1;
      run_or_prog = 1;
      // Clear the register
      clear = 0; #1;
      clear = 1; #1;
      clear = 0; #1;
      #90;
      $display("Output Display: %3d", display);
      $finish;
   end
   `endif
endmodule
