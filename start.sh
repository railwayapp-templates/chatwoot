#!/bin/sh

set -e

echo Waiting for database...

while ! pg_isready -h ${PGHOST} -p ${PGPORT}; do sleep 0.25; done; 

echo Database is now available

bundle exec rails db:chatwoot_prepare

bundle exec rails db:migrate

multirun \
    "bundle exec sidekiq -C config/sidekiq.yml" \
    "bundle exec rails s -b 0.0.0.0 -p $PORT"

false
