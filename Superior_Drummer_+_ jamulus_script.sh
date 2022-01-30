#!/bin/sh

/usr/bin/qjackctl --preset=superior_drummer --active-patchbay=$HOME/jack_patchbays/jamulus+superior.xml &

env WINEPREFIX="$HOME/.wine" /opt/wine-staging/bin/wine C:\\Program\ Files\\Toontrack\\Superior\ Drummer\\Superior\ Drummer\ 3.exe   &

sleep 2

jamulus -s -F -T -6 &

#sleep 2

jamulus --ctrlmidich '1;f30*10;p80*10;s2*3;m5*3' &

#sleep 2

jack_mixer --config=$HOME/jack_mixer_configs/superior &

sleep 40

jack_disconnect 'Superior Drummer 3:out_1' system:playback_1
jack_disconnect 'Superior Drummer 3:out_2' system:playback_2
jack_disconnect system:capture_1 'Superior Drummer 3:in_1'
jack_disconnect system:capture_2 'Superior Drummer 3:in_2'
jack_disconnect system:capture_1 'Jamulus:input left'
jack_disconnect system:capture_2 'Jamulus:input right'
jack_disconnect 'Jamulus:output left' system:playback_1
jack_disconnect 'Jamulus:output right' system:playback_2
