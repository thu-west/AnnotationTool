#!/bin/sh
set -e

MYSQL_USERNAME=root
MYSQL_PASSWORD=root

if [ -z "$1" ]
    then
        echo "Usage: $0 sql_file"
        exit 1
fi

sudo docker-compose up -d db

# wait mysql startup
while [ true ]
do
    sudo docker-compose run --rm dbc mysql -h db -u $MYSQL_USERNAME --password=$MYSQL_PASSWORD --execute="SHOW DATABASES;" > /dev/null
    if [ "$?" = "0" ]
        then
            break
    fi
    sleep 1
done

sudo docker-compose run --rm dbc mysql -h db -u $MYSQL_USERNAME --password=$MYSQL_PASSWORD --execute="CREATE DATABASE IF NOT EXISTS kg;"
sudo docker-compose run --rm dbc mysql -h db -u $MYSQL_USERNAME --password=$MYSQL_PASSWORD kg < $1
echo "Done, import success."
