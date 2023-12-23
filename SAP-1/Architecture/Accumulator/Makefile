build:
	iverilog -g2012 -o Accumulator.o Accumulator.v -DAccumulator_test -I../../../
	vvp Accumulator.o
run: build
	gtkwave Accumulator_tb.vcd Accumulator.gtkw
