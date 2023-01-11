#!/bin/bash

if ! pgrep -x a2jamidid >/dev/null
then
    cpupower-gui -p

        if ! pgrep -x VirtualBoxVM >/dev/null
        then
        sudo /home/daryl/scripts/misc/smt-manager.pl --offline
        fi
fi
