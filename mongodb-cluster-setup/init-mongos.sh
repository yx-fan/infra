#!/bin/bash

if [ ! -f /data/configdb/.mongos_initialized ]; then
  mongosh --port 27017 --eval '
    sh.addShard("shard1ReplSet/shard1:27019");
    sh.addShard("shard2ReplSet/shard2:27020");
  '
  touch /data/configdb/.mongos_initialized
fi
