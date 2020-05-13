#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}"/../helper/set_variable.sh

@test "check env var" {
  [ "${DOTBARE_DIR}" = "$HOME/.cfg/" ]
  [ "${DOTBARE_TREE}" = "$HOME" ]
  [ "${DOTBARE_BACKUP}" = "$HOME/.local/share/dotbare" ]
}

@test "check fzf var" {
  [ -n "${DOTBARE_KEY}" ]
  [ -n "${FZF_DEFAULT_OPTS}" ]
}
