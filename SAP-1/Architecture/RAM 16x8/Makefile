build:
	iverilog -g2012 -o RAM_16x8.o RAM_16x8.v -DRAM_16x8_test
	vvp RAM_16x8.o
run: build
	gtkwave RAM_16x8_tb.vcd RAM_16x8.gtkw
