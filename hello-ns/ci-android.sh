#!/bin/sh
set -e
EMULATOR_PORT=18002

create_emulator() {
    echo no | android create avd --force -n x86-19-bundle-ns -t android-19 -b x86
}

kill_emulator() {
    adb -s "emulator-$EMULATOR_PORT" emu kill
}

npm install
create_emulator

if npm run appium-android-bundle ; then
    kill_emulator
    exit 0
else
    kill_emulator
    exit 1
fi
