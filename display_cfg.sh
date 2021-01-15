#!/bin/bash

log_file="/home/miro/.screenlayout/log.txt"
date >> "$log_file"
sleep 1 #give the system time to setup the connection

dmode_hdmi1="$(cat /sys/class/drm/card0-HDMI-A-1/status)"
dmode_dp4="$(cat /sys/class/drm/card0-DP-4/status)"
dmode_dp3="$(cat /sys/class/drm/card0-DP-3/status)"
dmode_dp5="$(cat /sys/class/drm/card0-DP-5/status)"
dmode_dp6="$(cat /sys/class/drm/card0-DP-6/status)"
dmode_edp1="$(cat /sys/class/drm/card0-eDP-1/status)"
dmode_dp1="$(cat /sys/class/drm/card0-DP-1/status)"
dmode_dp2="$(cat /sys/class/drm/card0-DP-2/status)"

export DISPLAY=:0
export XAUTHORITY=/home/miro/.Xauthority

if [ -L /dev/arduino -a \( "${ACTION}" = "add" \) ]; then
    /home/miro/.screenlayout/sheetmusic-stand.sh
    exit 0
fi

if [ \( "${dmode_hdmi1}" = "disconnected" -o -z "${dmode_hdmi1}" \) -a \( "${dmode_dp4}" = "connected" \) \
    -a "${dmode_edp1}" = "connected" -a \( "${dmode_dp1}" = "disconnected" -o -z "${dmode_dp1}" \) -a \( "${dmode_dp2}" = "connected" \) ]; then
    if xrandr -q | grep -q "1920x1200" && xrandr -q | grep -q "1366x768"; then
        /home/miro/.screenlayout/corona-2.sh 2>&1 | tee -a "$log_file"
        echo "success" >> "$log_file"
    else
        echo "no resolution, bad setup" >> "$log_file"
    fi
elif [ "${dmode_hdmi1}" = "disconnected" -a \( "${dmode_dp4}" = "disconnected" -o -z "${dmode_dp4}" \) \
    -a \( "${dmode_dp3}" = "disconnected" -o -z "${dmode_dp3}" \) -a "${dmode_edp1}" = "connected" -a \
    "${dmode_dp1}" = "disconnected" -a \( "${dmode_dp2}" = "disconnected" -o -z "${dmode_dp2}" \) ]; then
    if xrandr -q | grep -q "1920x1080"; then
        /home/miro/.screenlayout/laptop-only.sh 2>&1 | tee -a "$log_file"
        echo "success" >> "$log_file"
    else
        echo "no resolution, bad setup" >> "$log_file"
    fi
elif [ "${dmode_hdmi1}" = "disconnected" -a \( "${dmode_dp4}" = "disconnected" -o -z "${dmode_dp4}" \) \
    -a "${dmode_edp1}" = "connected" -a "${dmode_dp1}" = "connected" -a \( "${dmode_dp2}" = "disconnected" -o -z "${dmode_dp2}" \) ]; then
    if xrandr -q | grep -q "1366x768"; then
        /home/miro/.screenlayout/home-1.sh 2>&1 | tee -a "$log_file"
        echo "success" >> "$log_file"
    else
        echo "no resolution, bad setup" >> "$log_file"
    fi
elif [ "${dmode_hdmi1}" = "connected" -a \( "${dmode_dp4}" = "disconnected" -o -z "${dmode_dp4}" \) \
    -a "${dmode_edp1}" = "connected" -a \( "${dmode_dp1}" = "disconnected" -o -z "${dmode_dp1}" \) -a \( "${dmode_dp2}" = "disconnected" -o -z "${dmode_dp2}" \) ]; then
    if xrandr -q | grep -q "1920x1200" && xrandr -q | grep -q "1920x1080"; then
        /home/miro/.screenlayout/corona-1.sh 2>&1 | tee -a "$log_file"
        echo "success" >> "$log_file"
    else
        echo "no resolution, bad setup" >> "$log_file"
    fi
else
    echo "unknown event" >> "$log_file"
fi
