#!/bin/bash

export TEST_URL=http://localhost:8080/owners

export INITIAL_STABILIZATION_TIME=30s
export WORKLOAD_TIME=130s
export POST_STABILIZATION_TIME=30s

export JAVA_OPTS=""
export J9_OPTS="-Xmx2G -Xshareclasses:name=mvn"
export OPENJDK_OPTS="-Xmx2G -XX:SharedArchiveFile=app-cds.jsa -XX:TieredStopAtLevel=1"

#export VMNAME=`java -XshowSettings:properties -version 2>&1 | grep "java.vm.name"  | sed 's/.*=//' | sed -e 's/^[[:space:]]*//'`
#echo "Virtual machine: $VMNAME"
#
## Different VMs must have different initial values
## https://bell-sw.com/announcements/2022/06/28/hotspot-vs-openj9-performance-comparison/
#if [[ $VMNAME == *J9* ]];
#then
#  echo "Applying J9-specific VM options"
#  export JAVA_OPTS=$J9_OPTS
#else
#  echo "Applying standard VM options"
#  export JAVA_OPTS=$OPENJDK_OPTS
#fi

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
