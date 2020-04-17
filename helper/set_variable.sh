#!/bin/bash
#
# check env variables and set default variables
#
# @params
# Globals
#		${DOTBARE_DIR}: string, location of the bare repo
#   ${DOTBARE_TREE}: string, which folder is the bare repo tracking
#   ${DOTBARE_KEY}: string, defualt key bindings
#   ${FZF_DEFAULT_OPTS}: string, update FZF_DEFAULT_OPTS to reflect dotbare changes
#   ${DOTBARE_FZF_DEFAULT_OPTS}: string, user custom setting for dotbare

DOTBARE_DIR="${DOTBARE_DIR:-$HOME/.cfg/}"
DOTBARE_TREE="${DOTBARE_TREE:-$HOME}"
if [[ -z "${DOTBARE_KEY}" ]]; then
  DOTBARE_KEY="
    --bind=alt-a:toggle-all
    --bind=alt-w:jump
    --bind=alt-0:top
    --bind=alt-c:clear-query
    --bind=alt-s:toggle-sort
    --bind=alt-t:toggle-preview
  "
fi

FZF_DEFAULT_OPTS="
  $FZF_DEFAULT_OPTS
  --ansi
  --cycle
  --exit-0
  $DOTBARE_FZF_DEFAULT_OPTS
  $DOTBARE_KEY
"

#######################################
# determine to set multi selection or not
# Globals:
#   ${FZF_DEFAULT_OPTS}: fzf options
# Arguments:
#   $1: if exists, disable multi, set single
#######################################
function set_fzf_multi() {
  local no_multi="$1"
  if [[ -z "${no_multi}" ]]; then
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --multi"
  else
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --no-multi"
  fi
}
