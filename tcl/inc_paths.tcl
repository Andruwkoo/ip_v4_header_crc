set tb_path ./../src/tb
set rtl_path {
    ./../src/rtl
}
set sim_path ./../sim

if { ![file isdirectory ${sim_path}] } {
    file mkdir ${sim_path}
}


vlib ${sim_path}/work
vmap work ${sim_path}/work
