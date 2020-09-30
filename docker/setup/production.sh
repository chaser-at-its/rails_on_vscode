#!/bin/sh -eu

BUNDLE_WITHOUT="development test" bundle install
yarn install

SECRET_KEY_BASE=for_assets_precompile bundle exec rails assets:precompile

apk del --purge $BUILD_DEPS
rm -rf /usr/local/share/.cache/yarn /${APP_NAME}/node_modules
