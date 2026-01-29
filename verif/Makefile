# ==============================================================================
#  MASTER MAKEFILE - ISRAEL DD 2026
#  Soporta: Xilinx Vivado (Local) y Cadence Xcelium (Server)
# ==============================================================================

# --- VARIABLES COMUNES ---
testname  = mac_tb
top       = tb_mac_top
verbosity = UVM_MEDIUM
logs      = ./logs

# --- TARGET DEFAULT (Ayuda) ---
.DEFAULT_GOAL := help

list:
	@mkdir -p $(logs)
	@echo "# Generando list.f para RTL y Verificacion..."
	@echo "# rtl" > list.f
	@echo "../rtl/lvl3_rtl.sv" >> list.f
	@echo "../rtl/lvl2_rtl.sv" >> list.f
	@echo "../rtl/lvl1_rtl.sv" >> list.f
	@echo "# verification" >> list.f
	@echo "./${testname}.sv" >> list.f

# ==============================================================================
#  FLUJO VIVADO
# ==============================================================================
ana: list
	xvlog -sv -f list.f -L uvm

elab: ana
	xelab -debug typical --relax ${top}

sim: elab
	xsim work.${top} -runall

waves:
	xsim work.${top}.wdb -autoloadwcfg -gui &

# ==============================================================================
#  FLUJO CADENCE (PARA EL SERVIDOR - ESTUDIANTES2)
# ==============================================================================
# Flags de compilación para Xcelium (xrun)
compile_switches = -f list.f -l ${logs}/comp.log +define+${testname}+ -access +rwc -timescale 1ns/1ps -sv

# Simulación Pura (RTL)
csim: list
	xrun ${compile_switches}

# Simulación con Interfaz Gráfica (SimVision)
csim_gui: list
	xrun ${compile_switches} -gui

# Abrir SimVision solo para ver ondas guardadas
waves_c:
	simvision shm_db &

# ==============================================================================
#  UTILIDADES
# ==============================================================================
help:
	@echo ""
	@echo "==== MASTER MAKEFILE COMMANDS ===="
	@echo " LOCAL (Vivado):"
	@echo "   make sim       -> Compila y corre simulación en terminal"
	@echo "   make waves     -> Abre las ondas en Vivado GUI"
	@echo ""
	@echo " SERVIDOR (Cadence):"
	@echo "   make csim      -> Compila y corre simulación (xrun)"
	@echo "   make csim_gui  -> Corre xrun con interfaz gráfica"
	@echo "   make waves_c   -> Abre SimVision para ver ondas grabadas"
	@echo ""
	@echo " COMUNES:"
	@echo "   make clean     -> Borra basura de ambos simuladores"
	@echo ""

clean:
	# Limpieza Vivado
	rm -rf xvlog* xelab* xsim* webtalk* tr_db* ana elab sim .Xil vivado* work* xsim.dir
	# Limpieza Cadence
	rm -rf xrun* waves* xcelium* logs shm_db .sim* .svm* *.diag uvm_test_name.svh list.f