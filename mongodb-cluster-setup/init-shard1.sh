#!/bin/bash

if [ ! -f /data/shard1/.shard_initialized ]; then
  mongosh --port 27019 --eval 'rs.initiate({_id: "shard1ReplSet", members: [{ _id: 0, host: "shard1:27019" }]})'
  touch /data/shard1/.shard_initialized
fi
