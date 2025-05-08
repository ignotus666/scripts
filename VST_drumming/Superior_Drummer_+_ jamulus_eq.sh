#!/bin/sh

$HOME/scripts/misc/SMT_performance_on.sh &

# $HOME/audiorelay/opt/audiorelay/bin/AudioRelay &

pw-metadata -n settings 0 clock.force-quantum 48 &
pw-metadata -n settings 0 clock.force-rate 48000 &

qpwgraph -a -x -m $HOME/qpwgraph_patchbays/Pipewire_SD_jamulus_EQ.qpwgraph &

sleep 2

jamulus -s -F -T -6 &

#sleep 2

jamulus --ctrlmidich '1;f30*10;p80*10;s2*3;m5*3' &

#sleep 2

carla $HOME/carla_projects/superior_drummer_3.carxp &

jack_mixer --config=$HOME/jack_mixer_configs/superior &&

pw-metadata -n settings 0 clock.force-quantum 1024 &&

pkill qpwgraph &&
pkill jamulus &&

sudo $HOME/scripts/misc/smt-manager.pl --online; sudo cpupower-gui pr Schedutil
