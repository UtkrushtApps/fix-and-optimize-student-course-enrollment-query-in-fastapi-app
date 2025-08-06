#!/bin/bash
set -e
cd /root/task
echo "Starting docker containers..."
docker-compose up -d
echo "Waiting for PostgreSQL to be healthy..."
retries=20
until docker exec utkrusht_postgres pg_isready -U utkrusht_user -d utkrusht_students; do
    sleep 2
    retries=$((retries-1))
    if [ $retries -le 0 ]; then
        echo "Database failed to start. Exiting."
        docker-compose logs db
        exit 1
    fi
done
echo "Database is ready. Checking FastAPI health..."
retries=20
until curl -s http://localhost:8000/docs >/dev/null; do
    sleep 2
    retries=$((retries-1))
    if [ $retries -le 0 ]; then
        echo "FastAPI service failed to start. Exiting."
        docker-compose logs fastapi
        exit 1
    fi
done
echo "FastAPI service is up and running!"
docker ps
