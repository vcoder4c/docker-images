## How to use?

## 1. Backup
### a. With docker

```shell
docker run --env-file backup.env vcoder/mysql_backup_restore
```

### b. With docker-compose
See on docker-compose.yml

## 2. Restore
```shell
docker run --env-file restore.env vcoder/mysql_backup_restore restore
```
