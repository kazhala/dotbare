#!/usr/bin/env bats

# inital setup in CI/CD pipeline

migrate() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare finit -u https://github.com/kazhala/dotfiles.git
}

@test "set up test environment" {
  [[ -d "${DOTBARE_DIR}" ]] && skip
  migrate
  [ "${status}" -eq 0 ]
}
