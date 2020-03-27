#!/bin/sh
set -e

build() {
    echo "Pulling images, this may take several minutes."
    sudo docker-compose pull
    sudo docker-compose build
}

compile() {
    sudo docker-compose run --rm web npm i
    sudo docker-compose run --rm web npm run build
}

start() {
    sudo docker-compose up -d db web
    echo "Done, please open http://localhost:8800/ in browser."
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
