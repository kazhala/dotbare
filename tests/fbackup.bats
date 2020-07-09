#!/usr/bin/env bats

setup() {
  export DOTBARE_BACKUP="$HOME/.local/share/dotbare_test"
  export DOTBARE_DIR="${HOME}/.cfg/"
}

teardown() {
  [ -d "${DOTBARE_BACKUP}" ] && rm -r "${DOTBARE_BACKUP}"
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

move_file() {
  touch bats_test.txt
  bash "${BATS_TEST_DIRNAME}"/../dotbare fbackup --path bats_test.txt -m
}

@test "fbackup help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fbackup [-h] [-m] [-s] [-p PATH] ..." ]
}

@test "fbackup invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = 'Invalid option: -f' ]
}

@test "fbackup backup all files" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    run backup
    [ "${status}" -eq 1 ]
  else
    run backup
    [ "${status}" -eq 0 ]
    [ -f "${DOTBARE_BACKUP}"/.bashrc ]
  fi
}

@test "fbackup backup individual file" {
  run individual_backup
  [ "${status}" -eq 0 ]
  [ -f "${DOTBARE_BACKUP}"/fadd.bats ]
}

@test "fbackup move file" {
  run move_file
  [ "${status}" -eq 0 ]
  [ -f "${DOTBARE_BACKUP}"/bats_test.txt ]
  [ ! -f "${BATS_TEST_DIRNAME}"/bats_test.txt ]
}
