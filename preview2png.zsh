#!/bin/zsh

dir=$1
for i in ${dir}/**/*.code
do
	if [[ ! -f "$i.png" ]]
	then	   
		urxvt -fg '#ffffff' -fn '-*-terminus-medium-*-*-*-24-*-*-*-*-*-iso10646-*' -e zsh -c "cat \"$i\"|./preview.tcl;read A" &
		procpid=$!
		sleep 0.5s
		scrot "$i.png"
		mogrify -crop 960x1046+0+34 "$i.png"
		optipng "$i.png"
		kill $procpid
	fi
done

