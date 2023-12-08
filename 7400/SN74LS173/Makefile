build:
	iverilog -g2012 -o SN74LS173.o SN74LS173.v -DSN74LS173_test
	vvp SN74LS173.o
run: build
	gtkwave SN74LS173_tb.vcd SN74LS173.gtkw
