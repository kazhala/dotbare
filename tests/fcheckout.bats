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
  run checkout_branch
  [[ "${output}" =~ "checkout" ]]
  [[ "${output}" =~ "--no-multi --header=select a branch to checkout" ]]
}

@test "fcheckout commit" {
  run checkout_commit
  [[ "${output}" =~ "checkout --header=select" ]]
}

@test "fcheckout modified" {
  run checkout_modified_file
  [[ "${output}" =~ "checkout" ]]
  [[ "${output}" =~ "file to checkout version in HEAD" ]]
  [[ "${output}" =~ "diff HEAD --color=always" ]]
}

@test "fcheckout select" {
  run checkout_selected_file
  [[ "${output}" =~ "checkout" ]]
  [[ "${output}" =~ "--header=select a file to checkout" ]]
  [[ "${output}" =~ "preview.sh" ]]
}
