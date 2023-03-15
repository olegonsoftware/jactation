#!/bin/bash

export TEST_URL=http://localhost:8080/owners

export SLEEP_TIME=30s

echo "Benchmark started"

java -jar /home/myapp/app.jar &
pid=$!
echo "Preparing"
sleep $SLEEP_TIME
echo "Preparing [OK]"

echo "Watching with psrecord..."
echo $pid
psrecord --log /home/myapp/log $pid &
psrpid=$!

echo "Applying the workload with wrk..."
wrk -t2 -c100 -d30s -R2000 --latency $TEST_URL
wrkpid=$!

echo "Clearing the resources..."
kill -9 $wrkpid
kill -9 $pid
kill -9 $psrpid
sleep 5s

echo "Benchmark finished"