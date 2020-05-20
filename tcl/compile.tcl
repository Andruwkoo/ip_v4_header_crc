source ./inc_paths.tcl

set paths ${rtl_path}
lappend paths ${tb_path}
foreach a ${paths} {
    lappend vhd_files [glob -directory ${a} -nocomplain *.vhd]
    lappend v_files [glob -directory ${a} -nocomplain *.v]
    lappend sv_files [glob -directory ${a} -nocomplain *.sv]
}

foreach a ${vhd_files} {
    if {[llength ${a}] != 0} {
        foreach b ${a} {
            vcom ${b}
        }
    }
}
foreach a ${v_files} {
    if {[llength ${a}] != 0} {
        foreach b ${a} {
            vlog -timescale 1ns/1ps -warning 3009 ${b}
        }
    }
}
foreach a ${sv_files} {
    if {[llength ${a}] != 0} {
        foreach b ${a} {
            vlog -timescale 1ns/1ps -warning 3009 -sv ${b}
        }
    }
}
