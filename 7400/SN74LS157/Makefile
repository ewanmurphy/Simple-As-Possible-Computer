build:
	iverilog -g2012 -o SN74LS157.o SN74LS157.v -DSN74LS157_test
	vvp SN74LS157.o
run: build
	gtkwave SN74LS157_tb.vcd SN74LS157.gtkw
