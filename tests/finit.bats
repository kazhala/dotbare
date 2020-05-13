#!/usr/bin/env bats

setup() {
  export confirm='y'
  export DOTBARE_DIR="$HOME/.local/share/dotbare_test/.cfg"
  export DOTBARE_TREE="$HOME/.local/share/dotbare_test"
}

teardown() {
  unset confirm
  if [[ "${DOTBARE_DIR}" == "$HOME/.local/share/dotbare_test/.cfg" ]] \
    && [[ "${DOTBARE_TREE}" == "$HOME/.local/share/dotbare_test" ]]; then
    rm -rf "${DOTBARE_TREE}"
  fi
  unset DOTBARE_DIR
  unset DOTBARE_TREE
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
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Usage: dotbare finit [-h] [-u URL] ..." ]
}

@test "finit init dotbare" {
  run init
  [ "${status}" -eq 0 ]
  run init
  [ "${status}" -eq 1 ]
  [ "${lines[3]}" = "${DOTBARE_DIR} already exist" ]
}

@test "finit migration" {
  [[ -d "${DOTBARE_DIR}" ]] && rm -rf "${DOTBARE_DIR}"
  run migration
  [ "${status}" -eq 0 ]
}
