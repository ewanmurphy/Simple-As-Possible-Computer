build:
	iverilog -g2012 -o SN74189.o SN74189.v -DSN74189_test
	vvp SN74189.o
run: build
	gtkwave SN74189_tb.vcd SN74189.gtkw
