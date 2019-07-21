#Returns color codes that are in string
# IN: string
# OUT: list
proc getColorWord {text} {
    return [lindex [regexp -inline -- {%\^(\w+)%\^} $text] 1]
}

#Tells whether this color code one that causes bold vt sequence
# IN: word
# OUT: boolean
proc boldWord {word} {
    if {$word == "BOLD" || $word == "YELLOW"} {
        return 1
    } else {
        return 0
    }
}

#Word Wrapper
# IN: max line lenght
#     string
# OUT: string
proc wordWrap {max msg} {
    if { [string length $msg] > $max } {
        regsub -all "(.{1,$max})( +|$)" $msg "\\1\\3\n" msg
    }
    return $msg
}

