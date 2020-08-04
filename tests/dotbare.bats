#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare -h
}

addall() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare add --all
}

routing() {
  "${BATS_TEST_DIRNAME}"/../dotbare fadd -h
}

routing2() {
  "${BATS_TEST_DIRNAME}"/../dotbare flog -h
}

normal_git() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  "${BATS_TEST_DIRNAME}"/../dotbare add -h
}

invalid_command() {
  "${BATS_TEST_DIRNAME}"/../dotbare hello
}

version() {
  "${BATS_TEST_DIRNAME}"/../dotbare --version
}

no_argument() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  "${BATS_TEST_DIRNAME}"/../dotbare
}

generic_git_operation_block_finit() {
  "${BATS_TEST_DIRNAME}"/../dotbare --git finit
}

generic_git_operation_block_fbackup() {
  "${BATS_TEST_DIRNAME}"/../dotbare --git fbackup
}

generic_git_operation_block_fupgrade() {
  "${BATS_TEST_DIRNAME}"/../dotbare --git fupgrade
}

generic_git_operation_init() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  "${BATS_TEST_DIRNAME}"/../dotbare --git init
}

generic_git_operation_fadd() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  "${BATS_TEST_DIRNAME}"/../dotbare --git fadd
}

@test "main generic git fadd" {
  run generic_git_operation_fadd
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ "--git-dir=rev-parse --show-toplevel/.git --work-tree=rev-parse --show-toplevel" ]]
  [[ "${output}" =~ "fadd_stage_modified" ]]
}

@test "main generic git commands" {
  run generic_git_operation_init
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ "--git-dir=rev-parse --show-toplevel/.git --work-tree=rev-parse --show-toplevel" ]]
  [[ "${output}" =~ "init" ]]
}

@test "main generic git flag block finit" {
  run generic_git_operation_block_finit
  [ "${status}" -eq 1 ]
  [ "${output}" = "dotbare finit is not supported when using dotbare as a generic fuzzy git tool" ]
}

@test "main generic git flag block fbackup" {
  run generic_git_operation_block_fbackup
  [ "${status}" -eq 1 ]
  [ "${output}" = "dotbare fbackup is not supported when using dotbare as a generic fuzzy git tool" ]
}

@test "main generic git flag block fupgrade" {
  run generic_git_operation_block_fupgrade
  [ "${status}" -eq 1 ]
  [ "${output}" = "dotbare fupgrade is not supported when using dotbare as a generic fuzzy git tool" ]
}

@test "main help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare [-h] [-v] [COMMANDS] [OPTIONS] ..." ]
}

@test "main version" {
  run version
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ "Current dotbare version: ${DOTBARE_VERSION}" ]]
}

@test "main disable add --all" {
  run addall
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "If you intend to stage all modified file, run dotbare add -u" ]
}

@test "main routing" {
  run routing
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fadd [-h] [-f] [-d] ..." ]
}

@test "main routing2" {
  run routing2
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare flog [-h] [-r] [-R] [-e] [-c] [-y] ..." ]
}

@test "main git command" {
  run normal_git
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ "add -h" ]]
}

@test "main invliad command" {
  run invalid_command
  [ "${status}" -eq 1 ]
}

@test "main no argument" {
  run no_argument
  [[ "${output}" =~ "Available commands" ]]
}
