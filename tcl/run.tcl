.main clear

proc run_tb {{sim_time -all} {verb 0}} {
    source ./compile.tcl
    vsim tb_top
    do ./wave.do
    if {${verb} == 0} {
        .main clear
    }
    run ${sim_time}
}

proc info_msg { } {
    echo "aliases:"
    echo "  t - testbench"
}

alias i info_msg
alias t run_tb

i
