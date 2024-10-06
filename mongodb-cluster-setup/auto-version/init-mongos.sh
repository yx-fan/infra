#!/bin/bash

# Log file
LOGFILE="/tmp/init-log.txt"

echo "Initializing mongos..." >> $LOGFILE

# Add shards to mongos
echo "Adding shards to mongos..." >> $LOGFILE

# Check if shard1 is already added
mongosh --port 27017 --eval 'sh.status()' | grep -q 'shardReplSet1'
if [ $? -ne 0 ]; then
    # Add shard1
    mongosh --port 27017 --eval 'sh.addShard("shardReplSet1/shard1:27019")' >> $LOGFILE 2>&1
    if [ $? -eq 0 ]; then
        echo "Shard shardReplSet1 added successfully." >> $LOGFILE
    else
        echo "Failed to add shard shardReplSet1." >> $LOGFILE
    fi
else
    echo "Shard shardReplSet1 already added." >> $LOGFILE
fi

# Check if shard2 is already added
mongosh --port 27017 --eval 'sh.status()' | grep -q 'shardReplSet2'
if [ $? -ne 0 ]; then
    # Add shard2
    mongosh --port 27017 --eval 'sh.addShard("shardReplSet2/shard2:27020")' >> $LOGFILE 2>&1
    if [ $? -eq 0 ]; then
        echo "Shard shardReplSet2 added successfully." >> $LOGFILE
    else
        echo "Failed to add shard shardReplSet2." >> $LOGFILE
    fi
else
    echo "Shard shardReplSet2 already added." >> $LOGFILE
fi

# Enable sharding on the database
DB_NAME="chat"

mongosh --port 27017 --eval 'sh.enableSharding("'$DB_NAME'")' >> $LOGFILE 2>&1
if [ $? -eq 0 ]; then
    echo "Sharding enabled for database $DB_NAME." >> $LOGFILE
else
    echo "Failed to enable sharding for database $DB_NAME." >> $LOGFILE
    exit 1
fi
