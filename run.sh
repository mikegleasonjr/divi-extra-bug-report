#!/bin/bash

set -e

cleanup() {
    docker-compose down
}

trap "cleanup" EXIT

docker-compose run --rm wait_for_database
docker-compose run --rm migrations
docker-compose up wordpress
