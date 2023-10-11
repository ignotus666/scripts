#!/bin/bash

sudo apt remove wine-staging-* &&
sudo aptitude install wine-staging-amd64=8.2~jammy-1 &&
sudo aptitude install wine-staging-i386=8.2~jammy-1 &&
sudo aptitude install wine-staging=8.2~jammy-1
