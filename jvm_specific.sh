#!/bin/bash

export J9_OPTS="-Xmx2G -Xshareclasses:name=mvn"
export OPENJDK_OPTS="-Xmx2G -XX:SharedArchiveFile=app-cds.jsa -XX:TieredStopAtLevel=1"

export VMNAME=`java -XshowSettings:properties -version 2>&1 | grep "java.vm.name"  | sed 's/.*=//' | sed -e 's/^[[:space:]]*//'`
echo "Virtual machine: $VMNAME"

# Different VMs may have different initial values
# It's useful for enabling AppCDS for example
# https://bell-sw.com/announcements/2022/06/28/hotspot-vs-openj9-performance-comparison/
if [[ $VMNAME == *J9* ]];
then
  echo "Applying J9-specific VM options"
  export JAVA_OPTS=$J9_OPTS
else
  echo "Applying standard VM options"
  export JAVA_OPTS=$OPENJDK_OPTS
fi