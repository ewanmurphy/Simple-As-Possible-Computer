build:
	iverilog -g2012 -o SN74LS83.o SN74LS83.v -DSN74LS83_test
	vvp SN74LS83.o
run: build
	gtkwave SN74LS83_tb.vcd SN74LS83.gtkw
