#!/usr/bin/env bats

setup() {
  export confirm='y'
  export DOTBARE_DIR="$HOME/.local/share/dotbare_test/.cfg"
  export DOTBARE_TREE="$HOME/.local/share/dotbare_test"
}

teardown() {
  unset confirm
}

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare finit -h
}

init() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare finit
}

migration() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare finit -u https://github.com/kazhala/dotfiles.git
}

@test "finit help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare finit [-h] [-u] ..." ]
}

@test "init dotbare" {
  run init
  [ "${status}" -eq 0 ]
  run init
  [ "${status}" -eq 1 ]
  [ "${lines[3]}" = "${DOTBARE_DIR} already exist" ]
}

@test "migration" {
  run migration
  [ "${status}" -eq 0 ]
}
