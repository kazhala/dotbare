#!/usr/bin/env bats

setup() {
  source "${BATS_TEST_DIRNAME}"/../helper/set_variable.sh
}

@test "env check env var" {
  [ "${DOTBARE_DIR}" = "$HOME/.cfg/" ]
  [ "${DOTBARE_TREE}" = "$HOME" ]
  [ "${DOTBARE_BACKUP}" = "$HOME/.local/share/dotbare" ]
}

@test "env check fzf var" {
  [ -n "${DOTBARE_KEY}" ]
  [ -n "${FZF_DEFAULT_OPTS}" ]
  [ -n "${DOTBARE_VERSION}" ]
}
