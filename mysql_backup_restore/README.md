## How to use?

### 1. Backup
#### a. Manual trigger

```shell
docker run --env-file backup.env mysql_backup_restore backup
```

#### b. Cron trigger
See on docker-compose.yml

### 2. Restore
```shell
docker run --env-file restore.env vcoder/mysql_backup_restore restore
```

## Notes

### 1. For multiple databases backup, just config:
```shell
MYSQL_DB=db1,db2
```
or
```shell
MYSQL_DB=--all-databases
```

*Note: with option all database, the process will exclude: Database|information_schema|performance_schema|mysql|sys|innodb
