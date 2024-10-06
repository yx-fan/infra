#!/bin/bash

if [ ! -f /data/shard2/.shard_initialized ]; then
  mongosh --port 27020 --eval 'rs.initiate({_id: "shard2ReplSet", members: [{ _id: 0, host: "shard2:27020" }]})'
  touch /data/shard2/.shard_initialized
fi
