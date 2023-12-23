build:
	iverilog -g2012 -o Controller_Sequencer.o Controller_Sequencer.v -DController_Sequencer_test -I../../../
	vvp Controller_Sequencer.o
run: build
	gtkwave Controller_Sequencer_tb.vcd Controller_Sequencer.gtkw
