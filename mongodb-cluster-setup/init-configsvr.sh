#!/bin/bash

if [ ! -f /data/configdb/.config_initialized ]; then
  mongosh --port 27018 --eval 'rs.initiate({_id: "configReplSet", configsvr: true, members: [{ _id: 0, host: "configsvr:27018" }]})'
  touch /data/configdb/.config_initialized
fi
