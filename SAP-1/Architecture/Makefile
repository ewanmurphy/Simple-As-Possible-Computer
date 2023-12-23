build:
	iverilog -g2012 -o SAP_1.o SAP_1.v -DSAP_1_test -I../../
	vvp SAP_1.o
run: build
	gtkwave SAP_1_tb.vcd SAP_1.gtkw
