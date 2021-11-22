#!/bin/sh

/usr/bin/qjackctl --preset=superior_drummer_eq --active-patchbay=$HOME/jack_patchbays/jamulus+superior_eq.xml &

env WINEPREFIX="$HOME/.wine" /opt/wine-stable/bin/wine C:\\Program\ Files\\Toontrack\\Superior\ Drummer\\Superior\ Drummer\ 3.exe &

sleep 2

jamulus -s -F -T -6 &

#sleep 2

jamulus --ctrlmidich '1;f30*10;p80*10;s2*3;m5*3' &

#sleep 2

jack_mixer --config=$HOME/jack_mixer_configs/superior &

carla $HOME/carla_projects/superior_drummer_3.carxp &

sleep 40

jack_disconnect 'Superior Drummer 3:out_1' system:playback_1
jack_disconnect 'Superior Drummer 3:out_2' system:playback_2
jack_disconnect system:capture_1 'Superior Drummer 3:in_1'
jack_disconnect system:capture_2 'Superior Drummer 3:in_2'
jack_disconnect system:capture_1 'Jamulus:input left'
jack_disconnect system:capture_2 'Jamulus:input right'
jack_disconnect 'Jamulus:output left' system:playback_1
jack_disconnect 'Jamulus:output right' system:playback_2
jack_disconnect 'EQ10Q Stereo:Output1' 'Jamulus:input left'
jack_disconnect 'EQ10Q Stereo:Output2' 'Jamulus:input right'
jack_disconnect 'Jamulus:output left' 'jack_mixer:Jamulus Out L'
jack_disconnect 'Jamulus:output right' 'jack_mixer:Jamulus Out R'
jack_disconnect 'jack_mixer:superior_in Out L' 'EQ10Q Stereo:Input1'
jack_disconnect 'jack_mixer:superior_in Out R' 'EQ10Q Stereo:Input2'
