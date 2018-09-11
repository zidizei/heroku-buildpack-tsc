#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testDetect() {
    touch ${BUILD_DIR}/tsconfig.json

    detect

    assertCapturedSuccess
    assertEquals "TypeScript" "$(cat ${STD_OUT})"
    assertEquals "" "$(cat ${STD_ERR})"
}

testDetectNoConf() {
    detect

    assertEquals 1 ${rtrn}
    assertEquals "" "$(cat ${STD_OUT})"
    assertEquals "" "$(cat ${STD_ERR})"
}
