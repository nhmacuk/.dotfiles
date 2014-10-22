#!/bin/sh
if [ "$1" == "connect" ]; then
    blueutil power 1 && networksetup -setairportpower en1 on
elif [ "$1" == "disconnect" ]; then
    diskutil eject /Volumes/Buddy/
    blueutil power 0 && networksetup -setairportpower en1 off
else
    echo "Error: needs \"connect\" or \"disconnect\" argument"
fi
