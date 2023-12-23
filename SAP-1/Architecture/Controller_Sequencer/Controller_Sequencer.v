`ifndef SN74LS107
   `define SN74LS107
   `include "7400/SN74LS107/SN74LS107.v"
`endif
module Controller_Sequencer(instruction, CLK, CLR_bar, C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar, HLT_bar);
   input [7:4] instruction;
   input CLK;
   input CLR_bar;
   output C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar;
   output HLT_bar;

   wire [7:4] not_instruction = ~instruction;

   // Instruction Decoder
   wire LDA = (not_instruction[7] & not_instruction[6] & not_instruction[5] & not_instruction[4]);
   wire ADD = (not_instruction[7] & not_instruction[6] & not_instruction[5] & instruction[4]);
   wire SUB = (not_instruction[7] & not_instruction[6] & instruction[5] & not_instruction[4]);
   wire OUT = (instruction[7] & instruction[6] & instruction[5] & not_instruction[4]);
   assign HLT_bar = ~(instruction[7] & instruction[6] & instruction[5] & instruction[4]);

   // Control Matrix
   wire [6:1] T;
   assign C_P = T[2];
   assign E_P = T[1];
   assign L_M_bar = ~|{T[1],LDA & T[4],ADD & T[4],SUB & T[4]};
   assign CE_bar = ~|{T[3],LDA & T[5],ADD & T[5],SUB & T[5]};
   assign L_I_bar = ~T[3];
   assign E_I_bar = ~|{LDA & T[4],ADD & T[4],SUB & T[4]};
   assign L_A_bar = ~|{LDA & T[5],ADD & T[6],SUB & T[6]};
   assign E_A = OUT & T[4];
   assign S_U = SUB & T[6];
   assign E_U = |{ADD & T[6], SUB & T[6]};
   assign L_B_bar = ~|{ADD & T[5],SUB & T[5]};
   assign L_O_bar = ~(OUT & T[4]);

   wire [6:1] Q;
   wire [6:1] Q_bar;

   assign T = {Q[6:2], Q_bar[1]};

   // Ring Counter
   SN74LS107 dualFF_1(.CLK_1(!CLK), .CLR_bar_1(CLR_bar), .J_1(Q_bar[6]), .K_1(Q[6]), .Q_1(Q[1]), .Q_bar_1(Q_bar[1]),
                      .CLK_2(!CLK), .CLR_bar_2(CLR_bar), .J_2(Q_bar[1]), .K_2(Q[1]), .Q_2(Q[2]), .Q_bar_2(Q_bar[2]));
   SN74LS107 dualFF_2(.CLK_1(!CLK), .CLR_bar_1(CLR_bar), .J_1(Q[2]), .K_1(Q_bar[2]), .Q_1(Q[3]), .Q_bar_1(Q_bar[3]),
                      .CLK_2(!CLK), .CLR_bar_2(CLR_bar), .J_2(Q[3]), .K_2(Q_bar[3]), .Q_2(Q[4]), .Q_bar_2(Q_bar[4]));
   SN74LS107 dualFF_3(.CLK_1(!CLK), .CLR_bar_1(CLR_bar), .J_1(Q[4]), .K_1(Q_bar[4]), .Q_1(Q[5]), .Q_bar_1(Q_bar[5]),
                      .CLK_2(!CLK), .CLR_bar_2(CLR_bar), .J_2(Q[5]), .K_2(Q_bar[5]), .Q_2(Q[6]), .Q_bar_2(Q_bar[6]));
endmodule

module Controller_Sequencer_tb;
   `ifdef Controller_Sequencer_test
   reg [7:4] instruction;
   reg CLK;
   reg CLR_bar;
   wire C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar;
   wire HLT_bar;
   integer k;
   reg [11:0] CON;

   Controller_Sequencer DUT(instruction, CLK, CLR_bar, C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar, HLT_bar);


   // Generate Clock Signals
   initial begin
      CLK = 0; #1;
      forever #1 CLK = ~CLK;
   end
   initial begin
      // Waveform generation
      $dumpfile("Controller_Sequencer_tb.vcd");
      $dumpvars(0, Controller_Sequencer_tb);
      // Clear the register
      CLR_bar = 1; #1;
      CLR_bar = 0; #1;
      CLR_bar = 1; #1;

      $display("Instruction : HLT");
      // Set an instruction HLT (1111)
      instruction = 4'b1111;
      for (k=0; k<6; k=k+1)
        begin
           CON = {C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar};
           case ((k%6)+1)
              1 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b010111100011, CON,  12'b010111100011 ^ CON);
              2 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b101111100011, CON, 12'b101111100011 ^ CON);
              3 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b001001100011, CON, 12'b001001100011 ^ CON);
              4 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h3E3, CON, 12'h3E3 ^ CON);
              5 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h3E3, CON, 12'h3E3 ^ CON);
              6 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h3E3, CON, 12'h3E3 ^ CON);
              default: $display("Execution State");
           endcase
         #2;
        end

      $display("Instruction : LDA");
      // Set an instruction LDA (0000)
      instruction = 4'b0000;
      for (k=0; k<6; k=k+1)
        begin
           CON = {C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar};
           case ((k%6)+1)
              1 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b010111100011, CON,  12'b010111100011 ^ CON);
              2 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b101111100011, CON, 12'b101111100011 ^ CON);
              3 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b001001100011, CON, 12'b001001100011 ^ CON);
              4 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h1A3, CON, 12'h1A3 ^ CON);
              5 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h2C3, CON, 12'h2C3 ^ CON);
              6 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h3E3, CON, 12'h3E3 ^ CON);
              default: $display("Execution State");
           endcase
         #2;
        end

      $display("Instruction : ADD");
      // Set an instruction ADD (0001)
      instruction = 4'b0001;
      for (k=0; k<6; k=k+1)
        begin
           CON = {C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar};
           case ((k%6)+1)
              1 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b010111100011, CON,  12'b010111100011  ^  CON);
              2 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b101111100011, CON, 12'b101111100011  ^  CON);
              3 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b001001100011, CON, 12'b001001100011  ^  CON);
              4 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h1A3, CON, 12'h1A3  ^  CON);
              5 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h2E1, CON, 12'h2E1  ^  CON);
              6 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h3C7, CON, 12'h3C7  ^  CON);
              default: $display("Execution State");
           endcase
         #2;
        end

      $display("Instruction : SUB");
      // Set an instruction SUB (0010)
      instruction = 4'b0010;
      for (k=0; k<6; k=k+1)
        begin
           CON = {C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar};
           case ((k%6)+1)
              1 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b010111100011, CON,  12'b010111100011 ^ CON);
              2 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b101111100011, CON, 12'b101111100011 ^ CON);
              3 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b001001100011, CON, 12'b001001100011 ^ CON);
              4 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h1A3, CON, 12'h1A3 ^ CON);
              5 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h2E1, CON, 12'h2E1 ^ CON);
              6 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h3CF, CON, 12'h3CF ^ CON);
              default: $display("Execution State");
           endcase
         #2;
        end

      $display("Instruction : OUT");
      // Set an instruction OUT (1110)
      instruction = 4'b1110;
      for (k=0; k<6; k=k+1)
        begin
           CON = {C_P, E_P, L_M_bar, CE_bar, L_I_bar, E_I_bar, L_A_bar, E_A, S_U, E_U, L_B_bar, L_O_bar};
           case ((k%6)+1)
              1 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b010111100011, CON,  12'b010111100011 ^ CON);
              2 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b101111100011, CON, 12'b101111100011 ^ CON);
              3 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'b001001100011, CON, 12'b001001100011 ^ CON);
              4 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h3F2, CON, 12'h3F2 ^ CON);
              5 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h3E3, CON, 12'h3E3 ^ CON);
              6 : $display("T%1d : Correct Control Bus  = %12b, Measured Control Bus = %4b, Agreement = %12b", (k%6)+1, 12'h3E3, CON, 12'h3E3 ^ CON);
              default: $display("Execution State");
           endcase
         #2;
        end
      $finish;
   end
   `endif
endmodule
