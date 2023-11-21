module Instruction_Register(L_I_bar, CLK, CLR, E_I_bar, bus_input, data, instruction);
    input  L_I_bar;
    input  CLK;
    input  CLR;
    input  E_I_bar;
    input [7:0] bus_input;
    output [3:0] data;
    output [3:0] instruction;
endmodule

module Instruction_Register_tb;
endmodule
