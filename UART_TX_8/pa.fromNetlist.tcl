
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name UART_TX_Final -dir "C:/Users/pc/Documents/UART/UART_TX_Final/planAhead_run_2" -part xc6slx16csg324-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/pc/Documents/UART/UART_TX_Final/UART_TOP.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/pc/Documents/UART/UART_TX_Final} {ipcore_dir} }
set_property target_constrs_file "uart_top.ucf" [current_fileset -constrset]
add_files [list {uart_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
