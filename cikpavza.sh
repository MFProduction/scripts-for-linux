#!/bin/bash
# Script for locking sccren after 1H and 30minutes to go on the coffe break; need to set up cron-job

echo "Coffee Break!!!"
xmessage -nearmouse -time 20 Coffee Break!!! Go out, you have 15 seconds to finish what you started! &
sleep 15
gnome-screensaver-command -l
