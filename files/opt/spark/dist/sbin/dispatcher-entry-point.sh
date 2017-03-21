#!/usr/bin/env bash

echo "Starting Mesos Dispatcher";

echo "All logging redirected to stdout... ignore messages for log locations"

if [ "$MESOS_MASTER" = "" ]; then
    echo "MESOS_MASTER environment variable not set... exiting"
    exit 1;
fi

if [ "$ZOOKEEPER" = "" ]; then
    echo "ZOOKEEPER environment variable not set... exiting"
    exit 1;
fi

if [ "$FRAMEWORK_NAME" = "" ]; then
    echo "FRAMEWORK_NAME environment variable not set... exiting"
    exit 1;
fi

exec /opt/spark/dist/sbin/start-mesos-dispatcher.sh --master $MESOS_MASTER --zk $ZOOKEEPER --name $FRAMEWORK_NAME 2>&1

