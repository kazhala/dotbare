#!/usr/bin/env bats

setup() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
}

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fcheckout -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fcheckout -p
}

checkout_branch() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fcheckout --branch
}

checkout_commit() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fcheckout -c
}

checkout_modified_file() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fcheckout -y
}

checkout_selected_file() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fcheckout --yes -s
}

@test "fcheckout help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fcheckout [-h] [-s] [-b] [-c] [-y] ..." ]
}

@test "fcheckout invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -p" ]
}

@test "fcheckout branch" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run checkout_branch
  [ "${status}" -eq 129 ]
  [[ "${output}" =~ "fcheckout_branch" ]]
}

@test "fcheckout commit" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run checkout_commit
  [ "${status}" -eq 129 ]
  [[ "${output}" =~ "fcheckout_commit" ]]
}

@test "fcheckout modified" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run checkout_modified_file
  [ "${status}" -eq 1 ]
  [[ "${output}" =~ "fcheckout_modified" ]]
}

@test "fcheckout select" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run checkout_selected_file
  [[ "${lines[0]}" =~ "fcheckout_select_commitdiff" ]]
  [[ "${lines[1]}" =~ "fcheckout_select_gitfile" ]]
  [ "${status}" -eq 1 ]
}
