#!/bin/bash
set -e

case "$1" in
  webserver)
    airflow db init
    airflow users create \
      --username admin \
      --firstname Admin \
      --lastname User \
      --role Admin \
      --email admin@example.com \
      --password admin
    exec airflow webserver
    ;;
  scheduler)
    exec airflow scheduler
    ;;
  worker)
    exec airflow celery worker
    ;;
  *)
    exec "$@"
    ;;
esac
