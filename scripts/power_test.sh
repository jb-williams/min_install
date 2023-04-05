#!/usr/bin/env bash
SLEEP_SEC=30
basedir="/proc/acpi/button/lid/"

if [[ -d "$basedir"LID ]]; then
    handler=$basedir"LID/"
elif [[ -d "$basedir"LID0 ]]; then
    handler=$basedir"LID0/"
else
    printf '%s\n' "Unable to find the proper LID directory"
    exit 1
fi

check_status="$handler""state"
while :; do
    if grep -qi "closed" "${check_status}" &>/dev/null && grep -q 0 /sys/class/power_supply/AC*/online &>/dev/null; then
        #dm-tool lock && systemctl suspend #pm-suspend
        /usr/bin/slock 2>/dev/null && systemtcl suspend
    elif grep -qi "closed" "${check_status}" &>/dev/null; then 
        /usr/bin/slock 2>/dev/null
        #systemctl suspend #pm-suspend
    fi
    sleep $SLEEP_SEC
done
