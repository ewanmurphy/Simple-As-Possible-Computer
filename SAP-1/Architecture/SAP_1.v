`include "./Accumulator/Accumulator.v"
`include "./Adder_Subtractor/Adder_Subtractor.v"
`include "./B Register/B_Register.v"
`include "./Controller_Sequencer/Controller_Sequencer.v"
`include "./Input and MAR/Input_and_MAR.v"
`include "./Instruction Register/Instruction_Register.v"
`include "./Output Register/Output_Register.v"
`include "./Program Counter/Program_Counter.v"
`include "./RAM 16x8/RAM_16x8.v"
module SAP_1(display);
   output [7:0] display;

   wire W_bus[7:0];
   // Clock
   wire CLK, CLK_bar;
   // Clear
   wire CLR, CLR_bar;

   // Controll Bus Wires
   wire C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar;
   // Connect Control bus
   wire [11:0] CON;
   assign CON[0] = C_P;
   assign CON[1] = E_P;
   assign CON[2] = L_M_bar;
   assign CON[3] = CE_bar;
   assign CON[4] = L_I_bar;
   assign CON[5] = E_I_bar;
   assign CON[6] = L_A_bar;
   assign CON[7] = E_A;
   assign CON[8] = S_U;
   assign CON[9] = E_U;
   assign CON[10] = L_B_bar;
   assign CON[11] = L_O_bar;

   // Control Unit
   Program_Counter program_counter(.C_P(C_P), .CLK_bar(CLK_bar), .CLR_bar(CLR_bar), .E_P(E_P));
   Controller_Sequencer controller_sequencer(.CON(CON),.CLK_bar(CLK_bar), .CLR(CLR), .CLR_bar(CLR_bar));
   Instruction_Register instruction_register(.L_I_bar(L_I_bar), .CLK(CLK), .CLR(CLR), .E_I_bar(E_I_bar));

   // Memory Unit
   Input_and_MAR input_and_mar(.L_M_bar(L_M_bar), .CLK(CLK));
   RAM_16x8 ram_16x8(.CE_bar(CE_bar));

   // ALU
   Accumulator accumulator(.L_A_bar(L_A_bar), .CLK(CLK), .E_A(E_A));
   Adder_Subtractor adder_subtractor(.S_U(S_U), .E_U(E_U));
   B_Register b_register(.L_B_bar(L_B_bar), .CLK(CLK));

   // I/O
   Output_Register output_register(.L_O_bar(L_O_bar), .CLK(CLK));
endmodule

module SAP_1_tb;
endmodule
