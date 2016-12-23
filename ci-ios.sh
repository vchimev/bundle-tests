#!/bin/bash
set -e

. ./tns-env.sh
. ./simulator.sh

EXIT_CODE=0
activate_node_env

prepare_simulator
start_simulator $(get_target_udid) &
SIMULATOR_PID=$!

cleanup() {
    stop_simulator
    kill -9 "$SIMULATOR_PID" 2> /dev/null || true
    exit "$EXIT_CODE"
}
trap cleanup EXIT

build_app() {
    APP="$1"
    (cd "$APP" && \
        npm install && \
        find node_modules -iname '*.gz' -delete && \
        rm -rf platforms && \
        npm run build-ios-bundle)
}

test_app() {
    APP="$1"
    (cd "$APP" && \
        npm run appium --runType=ios-simulator --verbose)
}

for app in {test-ng,test-ts,test-js} ; do
    if ! build_app "$app" ; then
        EXIT_CODE=1
        break
    fi

    wait $SIMULATOR_PID
    if ! test_app "$app" ; then
        EXIT_CODE=2
        break
    fi
done

