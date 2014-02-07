#!/bin/sh
(sleep 2; jack_connect csoundGrain:output1 simpler:input) &
csound grainnoui.csd
