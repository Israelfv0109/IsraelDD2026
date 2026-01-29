# ==============================================================================
#  MASTER MAKEFILE - ISRAEL DD 2026
#  Integración Total: Vivado + Cadence (Xrun, JasperGold, IMC)
# ==============================================================================

# --- VARIABLES GLOBALES ---
src       = lvl1
testname  = mac_tb
top       = tb_mac_top
verbosity = UVM_MEDIUM
logs      = ./logs
defines   = XCELIUM

# --- FLAGS DE CADENCE ---
# Simulación estándar
compile_switches     = -f list.f -l ${logs}/comp.log +define+${testname} -access +rwc -timescale 1ns/1ps -sv
# Simulación UVM
compile_switches_uvm = -f list.f -uvmhome CDNS-1.2 -uvm -l ${logs}/comp.log +define+${testname} +UVM_TESTNAME=${testname} +UVM_VERBOSITY=${verbosity} -access +rwc -timescale 1ns/1ps -sv
# Power Analysis (PA) con UPF
compile_switches_pa  = -f list.f -uvmhome CDNS-1.2 -uvm -l ${logs}/comp.log +define+${defines} +UVM_TESTNAME=${testname} +UVM_VERBOSITY=${verbosity} -access +rwc -timescale 1ns/1ps -sv -define UPF -covoverwrite -lps_1801 ../power/chip_wrapper.upf -lps_dbc -lps_relax_1801 -lps_verbose 5 -lps_common_options

# --- TARGET DEFAULT ---
.DEFAULT_GOAL := help

# ==============================================================================
#  1. GENERADOR DE LISTA (COMÚN)
# ==============================================================================
list:
	@mkdir -p $(logs)
	@echo "# Generando list.f..."
	@echo "# rtl" > list.f
	@echo "../rtl/lvl3_rtl.sv" >> list.f
	@echo "../rtl/lvl2_rtl.sv" >> list.f
	@echo "../rtl/lvl1_rtl.sv" >> list.f
	@echo "# verification" >> list.f
	@echo "./${testname}.sv" >> list.f

# ==============================================================================
#  2. VIVADO (LOCAL - MSI)
# ==============================================================================
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

# ==============================================================================
#  3. CADENCE: SIMULACIÓN (XCELIUM)
# ==============================================================================
csim: list
	xrun ${compile_switches}

csim_uvm: list
	xrun ${compile_switches_uvm} -abvevalnochange

csim_gui: list
	xrun ${compile_switches} -gui

csimvision:
	simvision shm_db &

# ==============================================================================
#  4. CADENCE: POWER ANALYSIS & COVERAGE
# ==============================================================================
# Power Analysis
csim_pa: list
	echo "\`include \"../../verif/test/${testname}.svh\"" > uvm_test_name.svh
	xrun ${compile_switches_pa}

# Coverage
csim_cov: list
	xrun $(compile_switches) -cov_cgsample -covoverwrite -coverage u -covtest $(testname)

csim_uvm_cov: list
	xrun ${compile_switches_uvm} -cov_cgsample

ccov_merge:
	imc -exec cov_merge.tcl

ccov_gui:
	imc -load test &

# ==============================================================================
#  5. CADENCE: FORMAL VERIFICATION (JASPERGOLD)
# ==============================================================================
cformal:
	jaspergold ../formal/static_fv_jg.tcl -acquire_proj -no_gui

cformal_gui:
	jaspergold ../formal/static_fv_jg.tcl -acquire_proj &

# ==============================================================================
#  6. UTILIDADES
# ==============================================================================
clean:
	# Limpia Vivado
	rm -rf xvlog* xelab* xsim* webtalk* tr_db* ana elab sim .Xil vivado* work* xsim.dir
	# Limpia Cadence
	rm -rf xrun* waves* xcelium* logs shm_db .sim* .svm* *.diag uvm_test_name.svh list.f jgproject

help:
	@echo ""
	@echo "==== MASTER MAKEFILE COMMANDS ===="
	@echo " LOCAL (Vivado):"
	@echo "   make sim          -> Compila y corre simulación"
	@echo "   make waves        -> Abre ondas en Vivado"
	@echo ""
	@echo " SERVIDOR (Cadence):"
	@echo "   make csim         -> Simulación básica (RTL)"
	@echo "   make csim_uvm     -> Simulación UVM"
	@echo "   make csim_gui     -> Simulación con GUI"
	@echo "   make csim_pa      -> Power Analysis"
	@echo "   make cformal      -> JasperGold Formal Verification"
	@echo "   make ccov_gui     -> Ver cobertura en IMC"
	@echo ""
	@echo " COMUNES:"
	@echo "   make clean        -> Borra todo"