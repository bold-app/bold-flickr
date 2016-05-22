#!/usr/bin/env bash

set -e

export RAILS_ENV=test

DUMMY_APP="${PWD}/test/dummy"

if [ "${PLUGIN}x" = "x" ]; then
  PLUGIN="${PWD##*/}"
fi
export PLUGIN

if [ "${REPO_URL}x" = "x" ]; then
  REPO_URL="https://github.com/bold-app/bold.git"
fi
if [ "${APP_VERSION}x" = "x" ]; then
  APP_VERSION=master
fi

GEMS="${DUMMY_APP}/vendor/gems"
VENDOR_DIR="${GEMS}/${PLUGIN}"

if [ ! -d $DUMMY_APP ]; then
  echo "cloning ${REPO_URL}..."
  git clone --depth 50 --branch=${APP_VERSION} ${REPO_URL} ${DUMMY_APP}
  cp "${DUMMY_APP}/test/support/database.travis.yml" "${DUMMY_APP}/config/database.yml"
  # make sure the plugin is not already mentioned in the master Gemfile
  grep -v $PLUGIN "${DUMMY_APP}/Gemfile" > Gemfile.new
  mv Gemfile.new "${DUMMY_APP}/Gemfile"
  # and add the checked out path to Gemfile.local
  echo "gem '${PLUGIN}', path: '${VENDOR_DIR}'" > "${DUMMY_APP}/Gemfile.local"
fi


mkdir -p $GEMS
ln -sf $PWD $VENDOR_DIR

cd $DUMMY_APP
bundle install
#psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname = 'travis_ci_test' AND pg_stat_activity.pid <> pg_backend_pid();" -U postgres
bundle exec rake bold:plugin:test

