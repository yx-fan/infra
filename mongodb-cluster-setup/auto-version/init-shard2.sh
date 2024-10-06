#!/bin/bash

# Log file
LOGFILE="/tmp/init-log.txt"

echo "Initializing shard2..." >> $LOGFILE

# Check if shard2 data directory is empty
if [ ! "$(ls -A /data/shard2)" ]; then
    echo "Starting MongoDB shard2..." >> $LOGFILE
    mongod --shardsvr --replSet shardReplSet2 --port 27020 --bind_ip_all &
    sleep 30

    # Initiate shard2 replica set
    echo "Initiating shard2 replica set..." >> $LOGFILE
    mongosh --port 27020 --eval 'rs.initiate({_id: "shardReplSet2", members: [{ _id: 0, host: "shard2:27020" }]})' >> $LOGFILE 2>&1

    # Check if shard2 replica set initiated successfully
    if [ $? -eq 0 ]; then
        echo "Shard2 replica set initiated successfully." >> $LOGFILE
    else
        echo "Failed to initiate shard2 replica set." >> $LOGFILE
        exit 1
    fi
else
    echo "Shard2 data directory is not empty, skipping initialization." >> $LOGFILE
fi
