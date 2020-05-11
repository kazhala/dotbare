#!/usr/bin/env bash
#
# confirmaiton helper

#######################################
# Helper function to get user confirmation
# Globals:
#   None
# Locals:
#   ${confirm}: user confirmation status
# Arguments:
#   $1: confirmation message to show during confirm
# Outputs:
#   ${confirm}: y or n indicating user response
#######################################
function get_confirmation() {
  local confirm
  local message="${1:-Confirm?}"
  while [ "${confirm}" != 'y' ]  && [ "${confirm}" != 'n' ]; do
    read -r -p "${message}(y/n): " confirm
  done
  echo "${confirm}"
}
