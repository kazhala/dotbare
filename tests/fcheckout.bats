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

@test "fchekcout invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -p" ]
}

@test "fchekcout branch" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run checkout_branch
  result=$(echo "${output}" | tr '`' "'")
  [ "${status}" -eq 129 ]
  [[ "${result}" =~ "error: unknown option 'branch'" ]]
}

@test "fchekcout commit" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run checkout_commit
  result=$(echo "${lines[0]}" | tr '`' "'")
  [ "${status}" -eq 129 ]
  [[ "${result}" =~ "error: unknown option 'commitshow'" ]]
}

@test "fcheckout modified" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run checkout_modified_file
  [ "${status}" -eq 1 ]
  [[ "${lines[0]}" =~ "error: pathspec '$HOME/modifiedfile' did not match any file(s) known to git" ]]
}

@test "fcheckout select" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run checkout_selected_file
  [[ "${lines[0]}" =~ "error: pathspec 'commitdiff' did not match any file(s) known to git" ]]
  [[ "${lines[1]}" =~ "error: pathspec '$HOME/selectgitfile' did not match any file(s) known to git" ]]
  [ "${status}" -eq 1 ]
}
