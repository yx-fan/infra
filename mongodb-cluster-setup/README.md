# MongoDB Cluster and Application Setup

## 1. Create shared network
```bash
docker network create shared_network
```

## 2. Create MongoDB cluster
```bash
cd mongo-cluster
docker-compose -f docker-compose.mongo.yml build
docker-compose -f docker-compose.mongo.yml up -d
```

## 3. Initialize MongoDB replica set
```bash
cd mongo-cluster
```
### 3.1 Initialize shard1 replica set
```bash
docker-compose -f docker-compose.mongo.yml exec shard1 bash
```
inside shard1 container
```bash
mongosh --port 27019
```
inside mongosh shell
```bash
rs.initiate({
  _id: "shard1ReplSet",
  members: [
    { _id: 0, host: "shard1:27019" }
  ]
})
```
exit
```bash
CTRL+c
CTRL+d
CTRL+d
```

### 3.2 Initialize shard2 replica set
```bash
docker-compose -f docker-compose.mongo.yml exec shard2 bash
```
inside shard2 container
```bash
mongosh --port 27020
```
inside mongosh shell
```bash
rs.initiate({
  _id: "shard2ReplSet",
  members: [
    { _id: 0, host: "shard2:27020" }
  ]
})
```
exit
```bash
CTRL+c
CTRL+d
CTRL+d
```

### 3.3 Initialize configsvr replica set
```bash
docker-compose -f docker-compose.mongo.yml exec configsvr bash
```
inside configsvr container
```bash
mongosh --port 27018
```
inside mongosh shell
```bash
rs.initiate({
  _id: "configReplSet",
  configsvr: true,
  members: [
    { _id: 0, host: "configsvr:27018" }
  ]
})
```
exit
```bash
CTRL+c
CTRL+d
CTRL+d
```

### 3.4 Initialize mongos
```bash
docker-compose -f docker-compose.mongo.yml exec mongos bash
```
inside mongos container
```bash
mongosh --port 27017
```
inside mongosh shell
```bash
sh.addShard("shard1ReplSet/shard1:27019")
sh.addShard("shard2ReplSet/shard2:27020")
sh.enableSharding("chat")
```
exit
```bash
CTRL+c
CTRL+d
CTRL+d
```

## 4. Create application
```bash
cd ..
./start-dev-in-docker.sh
```

# Start and Stop Application
Please make sure you have started MongoDB cluster before starting the application.
## 1. Start Application
```bash
./start-dev-in-docker.sh
```
## 2. Stop Application
```bash
./stop-dev-in-docker.sh
```

# Start and Stop MongoDB Cluster
## 1. Start MongoDB Cluster
```bash
./start-mongo-cluster.sh
```
## 2. Stop MongoDB Cluster
```bash
./stop-mongo-cluster.sh
```
