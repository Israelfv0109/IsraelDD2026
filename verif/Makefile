src=lvl1
testname=mac_tb
top      = tb_mac_top
verbosity=UVM_MEDIUM
.DEFAULT_GOAL := help

list: # target
    @echo "# rtl" > list.f
    @echo "../rtl/lvl3_rtl.sv" >> list.f
    @echo "../rtl/lvl2_rtl.sv" >> list.f
    @echo "../rtl/lvl1_rtl.sv" >> list.f
    @echo "# verification" >> list.f
    @echo "./${testname}.sv" >> list.f
    
ana: list
    xvlog -sv -f list.f -L uvm
elab: ana
    xelab -debug typical --relax ${top}
sim: elab
    xsim work.${top} -runall

waves:
    xsim work.${top}.wdb -autoloadwcfg -gui &

sim_gui: elab
    xsim work.${top} -runall -gui
cov: 
    xcrg -report_format html -dir xsim.covdb
sim_uvm: elab
    xsim work.${top} "UVM_TESTNAME=${testname}"
    
sim_uvm_gui: elab
    xsim work.${top} -gui "UVM_TESTNAME=${testname}"
help:
    @echo ""
    @echo "==== Basic Vivado Compile/Simulator makefile ======"
    @echo " Targets:"
    @echo " ana    --> Analyzes the HDL file with xvlog command"
    @echo " elab   --> Elaborates de design with xelab command"
    @echo " sim    --> Simulates the design with xsim command"
    @echo " clean  --> Clean support files"
    @echo " help   --> this help menu =)"
    @echo ""
clean:
    rm -rf xvlog* xelab* xsim* webtalk* tr_db* ana elab sim .Xil vivado* work*
    rm -rf xsim.dir


logs     = ./logs
defines  = XCELIUM
verb     = UVM_MEDIUM

compile_switches = -f list.f -l ${logs}/comp.log +define+${testname}+ -access +rwc -timescale 1ns/1ps -sv
compile_switches_uvm = -f list.f -uvmhome CDNS-1.2 -uvm -l ${logs}/comp.log +define+${testname}+ +UVM_TESTNAME=${testname} +UVM_VERBOSITY=${verb} -access +rwc -timescale 1ns/1ps -sv
compile_switches_pa = -f list.f -uvmhome CDNS-1.2 -uvm -l ${logs}/comp.log +define+${defines}+ +UVM_TESTNAME=${testname} +UVM_VERBOSITY=${verb} -access +rwc -timescale 1ns/1ps -sv -define UPF -covoverwrite -lps_1801 ../power/chip_wrapper.upf -lps_dbc -lps_relax_1801 -lps_verbose 5 -lps_common_options

csim:
	xrun ${compile_switches}
	
csim_uvm:
	xrun ${compile_switches_uvm} -abvevalnochange 

csim_uvm_gui:
	xrun ${compile_switches_uvm} -gui

csim_cov:
	xrun $(compile_switches) -cov_cgsample -covoverwrite -coverage u -covtest $(testname)

ccov_merge:
	imc -exec cov_merge.tcl

csim_uvm_cov:
	xrun ${compile_switches_uvm} -cov_cgsample
ccov_gui:
	imc -load test

csimvision:
	simvision shm_db

cformal:
	jaspergold ../formal/static_fv_jg.tcl -acquire_proj -no_gui

cformal_gui:
	jaspergold ../formal/static_fv_jg.tcl -acquire_proj

cclean:
	rm -rf xrun* waves* xcelium* logs shm_db .sim* .svm* *.diag uvm_test_name.svh

csim_pa:
	echo "\`include \"../../verif/test/${testname}.svh\""  > uvm_test_name.svh
	xrun ${compile_switches_pa}