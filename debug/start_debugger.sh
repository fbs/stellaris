#!/bin/sh

# $1 gdb executable
# $2 gdb init file
# $3 elf to debug

SCREENID='launchpad_debug'

echo $1 $2 $SCREENID

screen -U -m -d -t 'launchpad_debug' -S $SCREENID openocd --file /usr/local/share/openocd/scripts/board/ek-lm4f120xl.cfg
screen -S $SCREENID -X screen $1 $3 -x $2 
screen -S $SCREENID -r
