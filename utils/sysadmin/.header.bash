#!/usr/bin/env bash

# silent push, pop
function pushd () {
  command pushd "$@" > /dev/null
}
function popd () {
  command popd "$@" > /dev/null
}

# exit on success
function exit_on_success() {
  popd
  exit_success
}

# exit on failure
function exit_on_error() {
  error $1
  popd
  exit_failure
}

