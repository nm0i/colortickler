#!/usr/bin/tclsh

array set arguments {-rnd 0.3 -text magenta -keyword orange -alt cyan}
array set arguments $::argv

array set rnd "
	char $arguments(-rnd)
"

array set theme "
	text $arguments(-text)
	keyword $arguments(-keyword)
	keywordalt $arguments(-alt)
"

array set col {
	red     %^RED%^           bred     %^BOLD%^%^RED%^
	blue    %^BLUE%^          bblue    %^BOLD%^%^BLUE%^
	orange  %^ORANGE%^        borange  %^BOLD%^%^ORANGE%^
	green   %^GREEN%^         bgreen   %^BOLD%^%^GREEN%^
	black   %^BOLD%^%^BLACK%^ bblack   %^BOLD%^%^BLACK%^
	white   %^WHITE%^         bwhite   %^BOLD%^%^WHITE%^
	cyan    %^CYAN%^          bcyan    %^BOLD%^%^CYAN%^
	magenta %^MAGENTA%^       bmagenta %^BOLD%^%^MAGENTA%^
	reset   %^RESET%^
}

#Randomly colors the word
# IN: word
#     main color
#     secondary color
#     percentage of secondary color accurance
# OUT: color coded string
proc wordColor {word color rcolor tolerance} {
	global rnd col
	set len [string length $word]
	set charList [regexp -inline -all -- {.} $word]
	set newWord ""
	foreach {char} $charList {
		if {[expr {rand()}] < $tolerance} {
			set newWord [string cat $newWord "$col(reset)$col($color)$char$col(reset)$col($rcolor)"]
		} else {
			set newWord [string cat $newWord $char]
		}
	}
	return $newWord
}

proc lineColor {line} {
	global rnd theme col
	if {$line == ""} {
		return ""
	}
	set wordList [regexp -inline -all -- {\S+} $line]
	foreach {word} $wordList {
		if {[string index $word 0] == "@"} {
			set color $theme(keyword)
			set altColor $theme(keywordalt)
			if {[string index $word 1] == "("} {
				set tmp [regexp -inline -all -- {\@\((\w+),(\w+)\)} $word]
				set color [lindex $tmp 1]
				set altColor  [lindex $tmp 2]
				set word [string range $word [expr [string first ")" $word] + 1] [string length $word]]
			} else {
				set word [string range $word 1 [string length $word]]
			}
			set word [wordColor $word $altColor $color $rnd(char)]
			lappend newText "$col(reset)$col($color)$word$col(reset)$col($theme(text))"
		} else {
			lappend newText $word
		}
	}
	return "$col($theme(text))[join $newText " "]$col(reset)"
}

while {[gets stdin text] >= 0} {
	puts [lineColor $text]
}

