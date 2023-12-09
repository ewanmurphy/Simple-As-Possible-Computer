build:
	iverilog -g2012 -o Program_Counter.o Program_Counter.v -DProgram_Counter_test
	vvp Program_Counter.o
run: build
	gtkwave Program_Counter_tb.vcd Program_Counter.gtkw
