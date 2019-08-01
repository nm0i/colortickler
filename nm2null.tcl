#!/usr/bin/tclsh

package require term::ansi::send
term::ansi::send::import vt
vt::init

source [file join [file dirname [info script]] functions.tcl]

# Maps color codes to vt codes.
# IN: color code
proc codeToColor {code} {
    switch $code {
        RED        {}
        B_RED      {}
        BLUE       {}
        B_BLUE     {}
        ORANGE     {}
        B_ORANGE   {}
        YELLOW     {}
        GREEN      {}
        B_GREEN    {}
        BLACK      {}
        B_BLACK    {}
        WHITE      {}
        B_WHITE    {}
        CYAN       {}
        B_CYAN     {}
        MAGENTA    {}
        B_MAGENTA  {}
        YELLOW     {}
        BOLD       {}
        ULINE      {}
        RESET      {}
    }
}

proc decodeLine {line} {
    set codeList [regexp -inline -all -- {%\^\w+%\^[^%]*} $line]
    foreach codeWord $codeList {
        set colorWord [getColorWord $codeWord]
        codeToColor $colorWord
        set segment [string map [list "%^${colorWord}%^" ""] $codeWord]
        vt::wr $segment
    }
}

vt::sda_reset
vt::sda_fgwhite

while {[gets stdin text] >= 0} {
    puts [decodeLine $text]
}

vt::sda_reset

