#!/bin/bash

SERVER_NAME=BACKUP #Define Directory's name on cloud

TIMESTAMP=$(date +"%F")
BACKUPTIME=`date +%b-%d-%y`
BACKUP_DIR="/root/backup/$TIMESTAMP"
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump

export PATH=/bin:/usr/bin:/usr/local/bin
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='USER'
MYSQL_PASSWORD='PASS'

SECONDS=0

mkdir -p "$BACKUP_DIR/mysql"

#Dumping all available Database
echo "Starting Backup Database";
databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
for db in $databases; do
  $MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/mysql/$db.gz"
done
echo "Finished Backup Database";
echo '';

#Compressing specific directory
echo "Starting Backup Website";
tar -zcvf $BACKUP_DIR/newfile.tar.gz /path/directory
echo "Finished Compressing Source";
echo '';

#Copying Nginx Configuration Directory
echo "Starting Backup Nginx Configuration";
cp -r /etc/nginx/conf.d/ $BACKUP_DIR/nginx/
echo "Finished";
echo '';

size=$(du -sh $BACKUP_DIR | awk '{ print $1}') #Calculating backup directory size in total

#Uploading backup directory to configured Cloud
#autobackup = remote config name for rclone
echo "Starting Uploading Backup";
rclone move $BACKUP_DIR "autobackup:$SERVER_NAME/$TIMESTAMP" >> /var/log/rclone.log 2>&1
echo "Finished";

# Clean up
rm -rf $BACKUP_DIR
/usr/sbin/rclone -q --min-age 1w delete "autobackup:$SERVER_NAME" #Remove all backups older than 1 week
/usr/sbin/rclone -q --min-age 1w rmdirs "autobackup:$SERVER_NAME" #Remove all empty folders older than 1 week
/usr/sbin/rclone cleanup "autobackup:" #Cleanup Trash
echo "Finished";
echo '';

duration=$SECONDS
echo "Total $size, $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
