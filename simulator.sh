#!/bin/bash

prepare_simulator() {
    npm install -g ios-sim
}

start_simulator() {
    udid=$1
    echo "Starting device: $udid..."
    #xcrun instruments -w "$udid" || true
    #open -a "Simulator" --args -CurrentDeviceUDID "$udid"
    ios-sim start --devicetypeid "iPhone-6, 10.0"

    for i in $(seq 1 60) ; do  # 10 minutes max wait
        if xcrun simctl list devices | grep "$udid" | grep -q "Booted" ; then
            echo "Simulator booted. Waiting 10 more seconds..."
            sleep 10
            break;
        else
            echo "Simulator not booted yet. Waiting 10 seconds..."
            sleep 10
        fi
    done
}

stop_simulator() {
    killall "Simulator"
}
