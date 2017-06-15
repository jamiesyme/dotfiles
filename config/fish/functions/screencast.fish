#!/usr/bin/env fish

function screencast --describe "Pick a window and record a screencast"
	ffcast -w ffmpeg -f x11grab -show_region 1 -framerate 30 -s \%s -i \%D+%c+nomouse -c:v libx264 -qp 0 -preset ultrafast -filter:v "scale=trunc(iw/2)*2:trunc(ih/2)*2" $argv[1]
end
