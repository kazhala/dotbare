#!/usr/bin/env bats

setup() {
  export DOTBARE_BACKUP="$HOME/.local/share/dotbare_test"
}

teardown() {
  rm -r "$DOTBARE_BACKUP"
  unset DOTBARE_BACKUP
}

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fbackup -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fbackup -f
}

backup() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fbackup
}

individual_backup() {
  cd "${BATS_TEST_DIRNAME}"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fbackup -p fadd.bats
}

@test "fbackup help" {
  run help
  [ "${status}" -eq 0 ]
}

@test "fbackup invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = 'Invalid option: f' ]
}

@test "backup all files" {
  run backup
  [ "${status}" -eq 0 ]
}

@test "backup individual file" {
  run individual_backup
  [ "${status}" -eq 0 ]
}
