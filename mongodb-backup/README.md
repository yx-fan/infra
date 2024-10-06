# MongoDB Backup Script

This script is used to backup MongoDB databases. It is a simple bash script that uses `mongodump` to backup the databases and `gzip` to compress the backup files.

## Files
- `mongodb_back,sh`: The main script file.
- `README.md`: This file.

## Usage

### 1. Config Docker Compose

Make sure you have the following volumes in your `docker-compose.yml` file for different MongoDB services.

```yml
volumes:
  - /home/ubuntu/lawrence/backup/configsvr:/backup
  - /home/ubuntu/lawrence/backup/shard1:/backup
  - /home/ubuntu/lawrence/backup/shard2:/backup
```

### 2. Run the Script

Run the script on the host machine to backup the MongoDB databases.

```bash
sudo ./mongodb_back.sh
```

### 3. Schedule Backup

You can schedule the backup using `cron` job. Open the crontab file using the following command.
```bash
crontab -e
```

Add the following line to the crontab file to run the script every day at 2:00 AM.
```bash
0 2 * * * /path/to/mongodb_back.sh >> /path/to/mongodb_backup.log 2>&1
```

### 4. Restore Backup

To restore the backup, you can use the `mongorestore` command. For example, to restore the backup of the `configsvr` database, you can use the following command.

```bash
mongorestore --gzip --archive=/path/to/backup/configsvr.gz
```
