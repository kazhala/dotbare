#!/usr/bin/env bats

setup() {
  export DOTBARE_BACKUP="$HOME/.local/share/dotbare_test"
  export DOTBARE_DIR="${HOME}/.cfg/"
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

check_empty() {
  git log
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

@test "fbackup backup all files" {
  run check_empty
  if [ "${status}" -eq 0 ]; then
    run backup
    [ "${status}" -eq 0 ]
    [ -f "${DOTBARE_BACKUP}"/.bashrc ]
  else
    skip
  fi
}

@test "fbackup backup individual file" {
  run individual_backup
  [ "${status}" -eq 0 ]
  [ -f "${DOTBARE_BACKUP}"/fadd.bats ]
}
