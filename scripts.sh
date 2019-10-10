#!/bin/sh
set -e

MYSQL_USERNAME=root
MYSQL_PASSWORD=root

waitdbstartup() {
    while [ true ]
    do
        sudo docker-compose run --rm dbc mysql -h db -u $MYSQL_USERNAME --password=$MYSQL_PASSWORD --execute="SHOW DATABASES;" > /dev/null
        RET=$?
        if [ "$RET" = "0" ]
            then
                break
        fi
        sleep 1
    done
}

build() {
    echo "Pulling images, this may take several minutes."
    sudo docker-compose pull
    sudo docker-compose build
}

compile() {
    sudo docker-compose run --rm maven mvn clean compile package
}

start() {
    sudo docker-compose up -d db
    waitdbstartup
    sudo docker-compose up -d tomcat
    echo "Done, please open http://localhost:8080/annotationTool in browser."
}

stop() {
    sudo docker-compose stop
}

status() {
    sudo docker-compose ps
}

case "$1" in
    build)
        build
        ;;
    compile)
        compile
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 {build|compile|start|stop|restart|status}"
        exit 1
        ;;
esac
