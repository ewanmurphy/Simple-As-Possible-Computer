build:
	iverilog -g2012 -o SN74LS107.o SN74LS107.v -DSN74LS107_test
	vvp SN74LS107.o
run: build
	gtkwave SN74LS107_tb.vcd SN74LS107.gtkw
