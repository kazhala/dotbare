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
  run checkout_branch
  echo "${status}" >&3
  echo "${output}" >&3
  result=$(echo "${output}" | tr '`' "'")
  [ "${status}" -eq 129 ]
  [[ "${result}" =~ "error: unknown option 'branch'" ]]
}

@test "fchekcout commit" {
  run checkout_commit
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    [[ "${lines[0]}" =~ "fatal: your current branch 'master' does not have any commits yet" ]]
    result=$(echo "${lines[1]}" | tr '`' "'")
  else
    result=$(echo "${lines[0]}" | tr '`' "'")
  fi
  [ "${status}" -eq 129 ]
  [[ "${result}" =~ "error: unknown option 'commitshow'" ]]
}

@test "fcheckout modified" {
  run checkout_modified_file
  [ "${status}" -eq 1 ]
  [[ "${lines[0]}" =~ "error: pathspec '$HOME/modifiedfile' did not match any file(s) known to git" ]]
}

@test "fcheckout select" {
  run checkout_selected_file
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    [[ "${lines[0]}" =~ "fatal: your current branch 'master' does not have any commits yet" ]]
    [[ "${lines[1]}" =~ "error: pathspec 'commitdiff' did not match any file(s) known to git" ]]
    [[ "${lines[2]}" =~ "error: pathspec '$HOME/selectgitfile' did not match any file(s) known to git" ]]
  else
    [[ "${lines[0]}" =~ "error: pathspec 'commitdiff' did not match any file(s) known to git" ]]
    [[ "${lines[1]}" =~ "error: pathspec '$HOME/selectgitfile' did not match any file(s) known to git" ]]
  fi
  [ "${status}" -eq 1 ]
}
