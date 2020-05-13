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

normal_git() {
  "${BATS_TEST_DIRNAME}"/../dotbare status
}

invalid_command() {
  "${BATS_TEST_DIRNAME}"/../dotbare hello
}

@test "main help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare [-h] [COMMANDS] [OPTIONS] ..." ]
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

@test "main git command" {
  run normal_git
  [ "${status}" -eq 0 ]
}

@test "main invliad command" {
  run invalid_command
  [ "${status}" -eq 1 ]
}
