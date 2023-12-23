build:
	iverilog -g2012 -o Adder_Subtractor.o Adder_Subtractor.v -DAdder_Subtractor_test -I../../../
	vvp Adder_Subtractor.o
run: build
	gtkwave Adder_Subtractor_tb.vcd Adder_Subtractor.gtkw
