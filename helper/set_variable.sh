#!/usr/bin/env bash
#
# check env variables and set default variables
#
# @params
# Globals
#   ${DOTBARE_DIR}: location of the bare repo
#   ${DOTBARE_TREE}: which folder is the bare repo tracking
#   ${DOTBARE_BACKUP}: backup directory for all tracked files
#   ${DOTBARE_KEY}: defualt key bindings
#   ${FZF_DEFAULT_OPTS}: update FZF_DEFAULT_OPTS to reflect dotbare changes
#   ${DOTBARE_FZF_DEFAULT_OPTS}: user custom setting for dotbare
#   ${EDITOR}: default editor to use

export DOTBARE_DIR="${DOTBARE_DIR:-$HOME/.cfg/}"
export DOTBARE_TREE="${DOTBARE_TREE:-$HOME}"
export DOTBARE_BACKUP="${DOTBARE_BACKUP:-${XDG_DATA_HOME:-$HOME/.local/share}/dotbare}"
export DOTBARE_VERSION="v1.3.0"

export DOTBARE_DIFF_PAGER="${DOTBARE_DIFF_PAGER:-$(git config core.pager || echo 'cat')}"

export EDITOR="${EDITOR:-vim}"
if [[ -z "${DOTBARE_KEY}" ]]; then
  DOTBARE_KEY="
    --bind=alt-a:toggle-all
    --bind=alt-w:jump
    --bind=alt-0:top
    --bind=alt-s:toggle-sort
    --bind=alt-t:toggle-preview
  "
fi

[[ -z "${FZF_DEFAULT_OPTS}" ]] && export FZF_DEFAULT_OPTS='--cycle'

FZF_DEFAULT_OPTS="
  $FZF_DEFAULT_OPTS
  --ansi
  --cycle
  --exit-0
  $DOTBARE_FZF_DEFAULT_OPTS
  $DOTBARE_KEY
"

[[ -z "${COLUMNS}" ]] \
  && COLUMNS=$(stty size < /dev/tty | cut -d' ' -f2)
[[ "${COLUMNS}" -lt 80 ]] \
  && FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview-window=hidden"

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
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --multi"
  else
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --no-multi"
  fi
}
