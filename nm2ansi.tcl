#!/usr/bin/tclsh

package require term::ansi::send
term::ansi::send::import vt
vt::init

source [file join [file dirname [info script]] functions.tcl]

# Maps color codes to vt codes.
# IN: color code
proc codeToColor {code} {
	switch $code {
		RED        {vt::sda_fgred}
        B_RED      {vt::sda_bgred}
        BLUE       {vt::sda_fgblue}
        B_BLUE     {vt::sda_bgblue}
        ORANGE     {vt::sda_fgyellow}
        B_ORANGE   {vt::sda_bgyellow}
        YELLOW     {vt::sda_bgyellow}
        GREEN      {vt::sda_fggreen}
        B_GREEN    {vt::sda_bggreen}
        BLACK      {vt::sda_fgblack}
        B_BLACK    {vt::sda_bgblack}
        WHITE      {vt::sda_fgwhite}
        B_WHITE    {vt::sda_bgwhite}
        CYAN       {vt::sda_fgcyan}
        B_CYAN     {vt::sda_bgcyan}
        MAGENTA    {vt::sda_fgmagenta}
        B_MAGENTA  {vt::sda_fgmagenta}
        YELLOW   {
            vt::sda_bold
            vt::sda_fgyellow
        }
        BOLD     {vt::sda_bold}
        ULINE    {vt::sda_underline}
        RESET    {vt::sda_reset
            vt::sda_fgwhite}
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


while {[gets stdin text] >= 0} {
	puts [decodeLine $text]
}

vt::sda_reset

