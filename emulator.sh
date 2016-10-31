#!/bin/bash

set -e
EMULATOR_PORT=18002

create_emulator() {
    echo no | android create avd --force -n x86-19-bundle-ns -t android-19 -b x86
}

kill_emulator() {
    adb -s "emulator-$EMULATOR_PORT" emu kill
}

start_emulator() {
    #emulator -memory 1024 -avd x86-19-bundle-ns -port -no-window $EMULATOR_PORT &
    emulator -memory 1024 -avd x86-19-bundle-ns -port $EMULATOR_PORT &
    wait_for_emulator
}

wait_for_emulator() {
    set +e

    bootanim=""
    failcounter=0
    timeout_in_sec=360

    until [[ "$bootanim" =~ "stopped" ]]; do
      bootanim=`adb -e shell getprop init.svc.bootanim 2>&1 &`
      if [[ "$bootanim" =~ "device not found" || "$bootanim" =~ "device offline"
        || "$bootanim" =~ "running" ]]; then
        let "failcounter += 1"
        echo "Waiting for emulator to start"
        if [[ $failcounter -gt timeout_in_sec ]]; then
          echo "Timeout ($timeout_in_sec seconds) reached; failed to start emulator"
          exit 1
        fi
      fi
      sleep 1
    done

    echo "Emulator is ready"

    set -e
}
