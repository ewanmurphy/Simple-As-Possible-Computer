build:
	iverilog -g2012 -o Output_Register.o Output_Register.v -DOutput_Register_test -I../../../
	vvp Output_Register.o
run: build
	gtkwave Output_Register_tb.vcd Output_Register.gtkw
