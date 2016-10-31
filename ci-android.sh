#!/bin/bash
set -e

. ./tns-env.sh
. ./emulator.sh

activate_node_env

cd test-ng
npm install
find node_modules -iname '*.gz' -delete

create_emulator
start_emulator &
EMULATOR_PID=$!

rm -rf platforms
npm run build-android &
BUILD_PID=$!

wait $EMULATOR_PID
wait $BUILD_PID

if npm run appium-android-only ; then
    kill_emulator
    exit 0
else
    kill_emulator
    exit 1
fi
