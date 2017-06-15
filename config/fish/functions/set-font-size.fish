#!/usr/bin/env fish

function set-font-size --description "Set terminal font size"
	printf '\033]710;%s%d\007' "xft:Monaco:pixelsize=" $argv[1]
	printf '\033]711;%s%d\007' "xft:Monaco:pixelsize=" $argv[1]
end
