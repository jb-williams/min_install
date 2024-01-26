#!/usr/bin/env bash
SLEEP_SEC=30

check_caps_lock() {
	caps_lock_status="$(xset -q | sed -n 's/^.*Caps Lock:\s*\(\S*\).*$/\1/p')"
	if [ "$caps_lock_status" == "on" ]; then
		#printf "CAPS ON: Turning OFF\n"
		/usr/bin/notify-send -t 1500 "CAPS ON: Turning OFF"
		xdotool key Caps_Lock
		#exit 0
	#else
		#printf "OFF: Turning ON\n"
		#exit 0
	fi
}

check_caps_lock
sleep $SLEEP_SEC
check_caps_lock
exit 0
