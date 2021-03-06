#!/bin/bash
set -e

. ./tns-env.sh
. ./emulator.sh

EXIT_CODE=0
set +e
activate_node_env
set -e

create_emulator
start_emulator &
EMULATOR_PID=$!

cleanup() {
    kill_emulator
    kill -9 "$EMULATOR_PID" 2> /dev/null || true
    exit "$EXIT_CODE"
}
trap cleanup EXIT

build_app() {
    APP="$1"
    (cd "$APP" && make_app)
}

make_app() {
    npm install
    npm run upgrade-ng-app
    rm -rf node_modules/nativescript-angular
    ./node_modules/.bin/remove-ns-webpack
    ./node_modules/.bin/install-ns-webpack
    find node_modules -iname '*.gz' -delete
    rm -rf platforms
    npm run build-android-bundle
}

test_app() {
    APP="$1"
    (cd "$APP" && \
        npm run appium --runType=android)
}

for app in {test-ng,test-ts,test-js} ; do
    if ! build_app "$app" ; then
        EXIT_CODE=1
        break
    fi

    wait $EMULATOR_PID
    if ! test_app "$app" ; then
        EXIT_CODE=2
        break
    fi
done
