CURRENT_DATE=$(date "+%Y-$m-%d-%H:%M:%S")
BACKUP_DIR_NAME="backup_${CURRENT_DATE}"

pg_ctl stop -D $HOME/eaw92

rsync -avz $HOME/eaw92 $HOME/agt19 $HOME/iat59 postgres0@pg173:~/backups/$BACKUP_DIR_NAME

postgres -D $HOME/eaw92 >~/logfile 2>&1 &

ssh postgres0@pg173 "bash /var/db/postgres0/remove_script.sh"

echo "$(date): Backup $BACKUP_DIR_NAME was successfully created in directory ~/backups"