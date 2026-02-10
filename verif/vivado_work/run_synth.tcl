# 1. Leer los archivos RTL
read_verilog -sv [glob rtl/*.sv]

# 2. Ejecutar Síntesis definiendo el chip (part) aquí mismo
# Asegúrate que el top se llame mac_top
synth_design -top mac_top -part xc7a35ticsg324-1L -flatten_hierarchy none

# 3. Generar Reportes
report_utilization -file utilization_report.txt
report_timing_summary -file timing_report.txt

# Guardar el diseño sintetizado para abrirlo después sin esperar
write_checkpoint -force mac_radix4_synth.dcp