#!/bin/sh

if [ "$DESKTOP_SESSION" = "openbox" ]; then 
   sleep 20s
   killall conky
   cd "$HOME/.conky/syclo"
   conky -c "$HOME/.conky/syclo/syclo-orange-topleft.conkyrc" &
   exit 0
fi
if [ "$DESKTOP_SESSION" = "ubuntu" ]; then 
   sleep 20s
   killall conky
   cd "$HOME/.conky/MX-LSD"
   conky -c "$HOME/.conky/MX-LSD/conkyrc" &
   exit 0
fi
