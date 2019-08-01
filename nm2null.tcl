#!/usr/bin/tclsh

while {[gets stdin text] >= 0} {
    puts [string map {%^RED%^ {} %^B_RED%^ {} %^BLUE%^ {} %^B_BLUE%^ {} %^ORANGE%^ {} %^B_ORANGE%^ {} %^YELLOW%^ {} %^GREEN%^ {} %^B_GREEN%^ {} %^BLACK%^ {} %^B_BLACK%^ {} %^WHITE%^ {} %^B_WHITE%^ {} %^CYAN%^ {} %^B_CYAN%^ {} %^MAGENTA%^ {} %^B_MAGENTA%^ {} %^YELLOW%^ {} %^BOLD%^ {} %^ULINE%^ {} %^RESET%^ {}} $text]
}

