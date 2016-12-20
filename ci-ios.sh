#!/bin/bash
set -e

. ./tns-env.sh

EXIT_CODE=0
activate_node_env

cleanup() {
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
        npm run appium --runType=ios-simulator)
}

for app in {test-ng,test-ts,test-js} ; do
    if ! build_app "$app" ; then
        EXIT_CODE=1
        break
    fi

    if ! test_app "$app" ; then
        EXIT_CODE=2
        break
    fi
done

