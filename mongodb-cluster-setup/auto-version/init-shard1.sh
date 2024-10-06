#!/bin/bash

# Log file
LOGFILE="/tmp/init-log.txt"

echo "Initializing shard1..." >> $LOGFILE

# Check if shard1 data directory is empty
if [ ! "$(ls -A /data/shard1)" ]; then
    echo "Starting MongoDB shard1..." >> $LOGFILE
    mongod --shardsvr --replSet shardReplSet1 --port 27019 --bind_ip_all &
    sleep 30

    # Initiate shard1 replica set
    echo "Initiating shard1 replica set..." >> $LOGFILE
    mongosh --port 27019 --eval 'rs.initiate({_id: "shardReplSet1", members: [{ _id: 0, host: "shard1:27019" }]})' >> $LOGFILE 2>&1

    # Check if shard1 replica set initiated successfully
    if [ $? -eq 0 ]; then
        echo "Shard1 replica set initiated successfully." >> $LOGFILE
    else
        echo "Failed to initiate shard1 replica set." >> $LOGFILE
        exit 1
    fi
else
    echo "Shard1 data directory is not empty, skipping initialization." >> $LOGFILE
fi
