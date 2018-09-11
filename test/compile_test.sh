#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile() {
    mkdir -p ${BUILD_DIR}/node_modules/.bin
    touch    ${BUILD_DIR}/node_modules/.bin/tsc
    chmod +x ${BUILD_DIR}/node_modules/.bin/tsc

    compile

    assertCapturedSuccess

    assertCaptured "Development dependencies already installed"
    assertCaptured "Building application with tsc"
}

testDeprecatedCustomConfig() {
    mkdir -p ${BUILD_DIR}/node_modules/.bin
    touch    ${BUILD_DIR}/node_modules/.bin/tsc
    chmod +x ${BUILD_DIR}/node_modules/.bin/tsc

    export TSC_CUSTOM_FILE="tsconfig.test.json"

    compile

    assertCapturedSuccess

    assertCaptured "Found TSC_CUSTOM_FILE environment variable"
    assertCaptured "Please use TSC_CONFIG to set the path to a custom tsconfig.json for compilation"
}

testNoTSC() {
    compile

    assertCapturedError 1 "Could not find tsc executable"
}
