pdl:
	iverilog -o pdl pdl.v pdl_tb.v

sim: pdl
	vvp pdl

clean:
	rm -rf pdl
	rm -rf *.vcd
	
