#!/bin/bash -x 

set -euo pipefail

rm -f work

# Create link to directory with Redis binaries
cwd=$(pwd)

# Launch Redis in proper configuration
pushd / && make -f $cwd/Makefile start && popd

# Execute maven test
MAVEN_OPTS="-Duser.name=jenkins -Duser.home=/tmp/jenkins-home" ./mvnw clean test -DrunLongTests=true -U -B

# Capture resulting exit code from maven (pass/fail)
RESULT=$?

# Shutdown Redis
pushd / && make -f $cwd/Makefile stop && popd

# Return maven results
exit $RESULT