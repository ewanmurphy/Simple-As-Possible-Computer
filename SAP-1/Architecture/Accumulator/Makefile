build:
	iverilog -g2012 -o Accumulator.o Accumulator.v -DAccumulator_test
	vvp Accumulator.o
run: build
	gtkwave Accumulator_tb.vcd Accumulator.gtkw
