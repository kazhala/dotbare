#!/usr/bin/env bats

setup() {
  export DOTBARE_CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
}

teardown() {
  git checkout "$DOTBARE_CURRENT_BRANCH"
  unset "$DOTBARE_CURRENT_BRANCH"
}

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fupgrade -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fupgrade -p
}

upgrade() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fupgrade
}

@test "fupgrade help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fupgrade [-h] ..." ]
}

@test "fupgrade invliad option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: p" ]
}

@test "fupgrade upgrade" {
  run upgrade
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Fetching latest changes ..." ]
}
