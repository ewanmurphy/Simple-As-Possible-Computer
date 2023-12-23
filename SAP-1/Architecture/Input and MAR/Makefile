build:
	iverilog -g2012 -o Input_and_MAR.o Input_and_MAR.v -DInput_and_MAR_test -I../../../
	vvp Input_and_MAR.o
run: build
	gtkwave Input_and_MAR_tb.vcd Input_and_MAR.gtkw
