#!/bin/sh

bundle exec rails db:migrate

set -e

if [ $? != 0 ]; then
  echo
  echo "== Failed to migrate. Running setup first."
  echo
  bundle exec rails db:setup
fi

bundle exec rails server
