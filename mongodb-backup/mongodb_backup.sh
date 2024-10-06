#!/bin/bash

# set variables
BACKUP_DIR="/home/ubuntu/lawrence/backup"
TIMESTAMP=$(date +"%F")
LOG_FILE="/home/ubuntu/mongodb_backup.log"

echo "Backup started at $(date)" >> $LOG_FILE

# create dir on host
mkdir -p $BACKUP_DIR/configsvr/$TIMESTAMP
mkdir -p $BACKUP_DIR/shard1/$TIMESTAMP
mkdir -p $BACKUP_DIR/shard2/$TIMESTAMP
echo "Created backup directories $BACKUP_DIR/configsvr/$TIMESTAMP, $BACKUP_DIR/shard1/$TIMESTAMP, $BACKUP_DIR/shard2/$TIMESTAMP" >> $LOG_FILE

# backup config server
echo "Backing up config server..." >> $LOG_FILE
sudo docker exec mongo-cluster-configsvr-1 mongodump --host localhost --port 27018 --out /backup/$TIMESTAMP --gzip >> $LOG_FILE 2>&1
if [ $? -eq 0 ]; then
    echo "Backed up config server" >> $LOG_FILE
else
    echo "Failed to back up config server" >> $LOG_FILE
fi

# backup shard1
echo "Backing up shard1..." >> $LOG_FILE
sudo docker exec mongo-cluster-shard1-1 mongodump --host localhost --port 27019 --out /backup/$TIMESTAMP --gzip >> $LOG_FILE 2>&1
if [ $? -eq 0 ]; then
    echo "Backed up shard1" >> $LOG_FILE
else
    echo "Failed to back up shard1" >> $LOG_FILE
fi

# backup shard2
echo "Backing up shard2..." >> $LOG_FILE
sudo docker exec mongo-cluster-shard2-1 mongodump --host localhost --port 27020 --out /backup/$TIMESTAMP --gzip >> $LOG_FILE 2>&1
if [ $? -eq 0 ]; then
    echo "Backed up shard2" >> $LOG_FILE
else
    echo "Failed to back up shard2" >> $LOG_FILE
fi

echo "Backup completed at $(date)" >> $LOG_FILE