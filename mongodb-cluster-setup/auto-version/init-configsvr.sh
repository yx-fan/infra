#!/bin/bash

# Log file
LOGFILE="/tmp/init-log.txt"

echo "Initializing config server..." >> $LOGFILE

# Check if config server data directory is empty
if [ ! "$(ls -A /data/configdb)" ]; then
    echo "Starting MongoDB as configsvr..." >> $LOGFILE
    mongod --configsvr --replSet configReplSet --port 27018 --bind_ip_all &
    sleep 30

    # Initiate config server replica set
    echo "Initiating config server replica set..." >> $LOGFILE
    mongosh --port 27018 --eval 'rs.initiate({_id: "configReplSet", configsvr: true, members: [{ _id: 0, host: "configsvr:27018" }]})' >> $LOGFILE 2>&1

    # Check if config server replica set initiated successfully
    if [ $? -eq 0 ]; then
        echo "Config server replica set initiated successfully." >> $LOGFILE
    else
        echo "Failed to initiate config server replica set." >> $LOGFILE
        exit 1
    fi
else
    echo "Config server data directory is not empty, skipping initialization." >> $LOGFILE
fi
