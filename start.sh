#!/bin/sh

set -e

pg_isready -h $PGHOST -p $PGPORT

bundle exec rails db:chatwoot_prepare

bundle exec rails db:migrate

exec parallel --ungroup --halt now,done=1 ::: \
    "bundle exec sidekiq -C config/sidekiq.yml" \
    "bundle exec rails s -b 0.0.0.0 -p $PORT"