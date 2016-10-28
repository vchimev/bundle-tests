#!/bin/bash
set -e

. ./emulator.sh

cd test-ng

npm install
create_emulator
start_emulator

echo "TNS CHECK"
which tns
tns --version
rm -rf platforms
tns platform add android
tns run android --justlaunch
exit 0

if npm run appium-android-bundle ; then
    kill_emulator
    exit 0
else
    kill_emulator
    exit 1
fi
