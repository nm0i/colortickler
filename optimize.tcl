#!/usr/bin/tclsh

source [file join [file dirname [info script]] functions.tcl]

proc optimizeCode {line} {
    ##Bold sequencing: removing unneeded resets and bold codes
    set codeList [regexp -inline -all -- {%\^\w+%\^[^%]*} $line]
    set newLine ""
    set boldFlag 0
    for {set i 0} {$i<[llength $codeList]} {incr i} {
        set segment [lindex $codeList $i]
        set colorWord [getColorWord $segment]
        set nextColorWord [getColorWord [lindex $codeList [expr {$i+1}]]]
        if {$boldFlag && $colorWord == "BOLD"} {
            set segment [string map {"%^BOLD%^" ""} $segment]
        }
        if {[boldWord $colorWord] && $nextColorWord == "RESET"} {
            set segment [string map {"%^BOLD%^" ""} $segment]
        }
        if {[boldWord $colorWord]} {
            set boldFlag 1
        }
        if {$colorWord == "RESET"} {
            if {[boldWord $nextColorWord]} {
                set segment [string map {"%^RESET%^" ""} $segment]
            } else {
                set boldFlag 0
            }
        }
        set newLine [string cat $newLine $segment]
    }
    set line $newLine
    
    ##Color sequencing: resets after color alterations without bold alteration
    set codeList [regexp -inline -all -- {%\^\w+%\^[^%]*} $line]
    set newLine ""
    set boldFlag 0
    for {set i 0} {$i<[llength $codeList]} {incr i} {
        set segment [lindex $codeList $i]
        set colorWord [getColorWord $segment]
        set nextColorWord [getColorWord [lindex $codeList [expr {$i+1}]]]
        if {$colorWord == "BOLD" || $colorWord == "YELLOW"} {
            set boldFlag 1
        }
        if {$colorWord == "RESET"} {
            if {$boldFlag && [boldWord $nextColorWord]} {
                set segment [string map {"%^RESET%^" ""} $segment]
            } elseif { (! $boldFlag) && (! [boldWord $nextColorWord]) } {
                set segment [string map {"%^RESET%^" ""} $segment]
            } else {
                set boldFlag 0
            }
        }
        set newLine [string cat $newLine $segment]
    }
    set line $newLine

    ##Color sequencing: color codes that account for empty space
    set codeList [regexp -inline -all -- {%\^\w+%\^[^%]*} $line]
    set newLine ""
    for {set i 0} {$i<[llength $codeList]} {incr i} {
        set segment [lindex $codeList $i]
        set colorWord [getColorWord $segment]
        if {! ([boldWord $colorWord] && $colorWord == "RESET")} {
            if {[regexp -- {%\^\w+%\^ +$} $segment]} {
                set segment " "
            }
        }
        set newLine [string cat $newLine $segment]
    }
    set line $newLine

    #General sequencing: non-resets and non-bolds that account for nothing
    set codeList [regexp -inline -all -- {%\^\w+%\^[^%]*} $line]
    set newLine ""
    for {set i 0} {$i<[llength $codeList]} {incr i} {
        set segment [lindex $codeList $i]
        set colorWord [getColorWord $segment]
        if {$colorWord != "RESET" && $colorWord != "BOLD"} {
            if {[regexp -- {%\^\w+%\^$} $segment]} {
                set segment ""
            }
        }
        set newLine [string cat $newLine $segment]
    }

    return $newLine
}

while {[gets stdin text] >= 0} {
    puts "[optimizeCode $text]"
}

