#!/usr/bin/env bats

setup() {
  if "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    export PATH="${BATS_TEST_DIRNAME}:$PATH"
  fi
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
  run checkout_branch
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    [ "${status}" -eq 1 ]
    [ -z "${output}" ]
  else
    result=$(echo "${output}" | tr '`' "'")
    [ "${status}" -eq 129 ]
    [[ "${result}" =~ "error: unknown option 'branch'" ]]
  fi
}

@test "fchekcout commit" {
  run checkout_commit
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    [ "${status}" -eq 1 ]
    [ "${lines[0]}" = "fatal: your current branch 'master' does not have any commits yet" ]
  else
    result=$(echo "${lines[0]}" | tr '`' "'")
    [ "${status}" -eq 129 ]
    [[ "${result}" =~ "error: unknown option 'commitshow'" ]]
  fi
}

@test "fcheckout modified" {
  run checkout_modified_file
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    [ "${status}" -eq 1 ]
    [ -z "${output}" ]
  else
    [ "${status}" -eq 1 ]
    [[ "${lines[0]}" =~ "error: pathspec '$HOME/modifiedfile' did not match any file(s) known to git" ]]
  fi
}

@test "fcheckout select" {
  run checkout_selected_file
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    [ "${status}" -eq 1 ]
    [ -z "${output}" ]
  else
    [[ "${lines[0]}" =~ "error: pathspec 'commitdiff' did not match any file(s) known to git" ]]
    [[ "${lines[1]}" =~ "error: pathspec '$HOME/selectgitfile' did not match any file(s) known to git" ]]
    [ "${status}" -eq 1 ]
  fi
}
