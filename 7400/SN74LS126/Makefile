build:
	iverilog -g2012 -o SN74LS126.o SN74LS126.v -DSN74LS126_test
	vvp SN74LS126.o
run: build
	gtkwave SN74LS126_tb.vcd SN74LS126.gtkw
