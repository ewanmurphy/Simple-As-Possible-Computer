build:
	iverilog -g2012 -o B_Register.o B_Register.v -DB_Register_test
	vvp B_Register.o
run: build
	gtkwave B_Register_tb.vcd B_Register.gtkw
