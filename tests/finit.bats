#!/usr/bin/env bats

setup() {
  export DOTBARE_DIR="$HOME/.local/share/dotbare_test/.cfg"
  export DOTBARE_TREE="$HOME/.local/share/dotbare_test"
}

teardown() {
  if [[ "${DOTBARE_DIR}" == "$HOME/.local/share/dotbare_test/.cfg" ]] && \
    [[ "${DOTBARE_TREE}" == "$HOME/.local/share/dotbare_test" ]]; then
    rm -rf "${DOTBARE_TREE}"
  fi
  unset DOTBARE_DIR
  unset DOTBARE_TREE
}

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare finit -h
}

init() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare finit --yes
}

migration() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare finit -u https://github.com/kazhala/dotfiles.git
}

submodule() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare finit -u https://github.com/kazhala/dotfiles.git -s --submodule
}

@test "finit help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare finit [-h] [-y] [-s] [-u URL] ..." ]
}

@test "finit init dotbare" {
  [[ -d "${DOTBARE_DIR}" ]] && rm -rf "${DOTBARE_DIR}"
  run init
  [ "${status}" -eq 0 ]
  run init
  [ "${status}" -eq 1 ]
  [[ "${output}" =~ "${DOTBARE_DIR} already exist" ]]
}

@test "finit migration" {
  [[ -d "${DOTBARE_DIR}" ]] && rm -rf "${DOTBARE_DIR}"
  run migration
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ "Migration completed" ]]
}

@test "finit submodule" {
  [[ -d "${DOTBARE_DIR}" ]] && rm -rf "${DOTBARE_DIR}"
  run submodule
  [ "${status}" -eq 0 ]
  result=$(echo "${output}" | tr "\n" " ")
  [[ "${result}" =~ "Cloning submodules ... Migration completed" ]]
}
