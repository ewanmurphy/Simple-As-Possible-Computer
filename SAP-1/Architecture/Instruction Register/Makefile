build:
	iverilog -g2012 -o Instruction_Register.o Instruction_Register.v -DInstruction_Register_test
	vvp Instruction_Register.o
run: build
	gtkwave Instruction_Register_tb.vcd Instruction_Register.gtkw
