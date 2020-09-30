#!/bin/sh -eu

apk add --no-cache $DEV_DEPS
bundle install
yarn install
