#!/bin/bash

killall -q spotify

while pgrep -u $UID -x spotify > /dev/null; do sleep 1; done

spotify &
