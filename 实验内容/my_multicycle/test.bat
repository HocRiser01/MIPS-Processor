set iverilog_path=D:\iverilog\bin;
set gtkwave_path=D:\iverilog\gtkwave\bin;
set path=%iverilog_path%%gtkwave_path%%path%

iverilog -s testbench_ -o "testbench.vvp" testbench.v mips.v .\control\controller.v .\datapath\alu.v .\datapath\dm.v .\datapath\ext.v .\datapath\gpr.v .\datapath\im.v .\datapath\mux.v .\datapath\npc.v .\datapath\pc.v .\datapath\be.v .\datapath\dmext.v .\datapath\sgate.v .\datapath\muldiv.v

vvp -n "testbench.vvp" -lxt2

gtkwave "testbench.vcd"

pause