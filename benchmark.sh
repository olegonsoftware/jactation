#!/bin/bash

export TEST_URL=http://localhost:8080/owners

export INITIAL_STABILIZATION_TIME=30s
export WORKLOAD_TIME=130s
export POST_STABILIZATION_TIME=30s

export JAVA_OPTS=""
# source $(pwd)/jvm_specific.sh

wait-url() {
    echo "Testing $1"
    timeout --foreground -s TERM 30s bash -c \
        'while [[ "$(curl -s -o /dev/null -m 3 -L -w ''%{http_code}'' ${0})" != "200" ]];\
        do echo "Waiting URL: ${0}" && sleep 2;\
        done' ${1}
    echo "URL ready: ${1}"
}

echo "Benchmark started"

java -jar $JAVA_OPTS /home/myapp/app.jar &
pid=$!

wait-url $TEST_URL

echo "Initial stabilization"
sleep $INITIAL_STABILIZATION_TIME
echo "Initial stabilization [OK]"

echo "Watching with psrecord..."

psrecord --log /home/myapp/log $pid &
psrpid=$!

echo "Applying the workload with wrk..."
wrk -t2 -c100 -d$WORKLOAD_TIME -R2000 --latency $TEST_URL
wrkpid=$!

echo "Post stabilization"
sleep $POST_STABILIZATION_TIME
echo "Post stabilization [OK]"

echo "Clearing the resources..."
kill -9 $wrkpid
kill -9 $pid
kill -9 $psrpid
sleep 5s

echo "Benchmark finished"
