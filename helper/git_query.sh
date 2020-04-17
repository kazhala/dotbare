#!/bin/bash
#
# helper functions to obtain git related information

#######################################
# let user select a commit interactively
# Arguments:
#   $1: the helper message to display in the fzf header
# Outputs:
#   the selected commit 6 char code
#   e.g. b60b330
#######################################
function get_commit() {
  local header="${1:-select a commit}"
  /usr/bin/git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
  log --oneline --color=always --decorate=short \
    | fzf --no-multi --header="${header}" \
      --preview "echo {} \
        | awk '{print \$1}' \
        | xargs -I __ /usr/bin/git --git-dir=${DOTBARE_DIR} --work-tree=${DOTBARE_TREE} \
          show --color=always  __" \
    | awk '{print $1}'
}

#######################################
# let user select a branch interactively
# Arguments:
#   $1: the helper message to display in the fzf header
# Outputs:
#   the selected branch name
#   e.g. master
#######################################
function get_branch() {
  local header="${1:-select a branch}"
  /usr/bin/git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" branch -a \
    | awk '{
        if ($0 ~ /\*.*\(HEAD.*/) {
          gsub(/\* /, "", $0)
          print "\033[32m" $0 "\033[0m"
        } else if (match($1, "\\*") != 0) {
          print "\033[32m" $2 "\033[0m"
        } else if ($0 ~ /^[ \t]+remotes\/.*/) {
          gsub(/[ \t]+/, "", $0)
          print "\033[31m" $0 "\033[0m"
        } else {
          gsub(/^[ \t]+/, "", $0)
          print $0
        }
      }' \
    | fzf --no-multi --header="${header}" \
      --preview="/usr/bin/git --git-dir=${DOTBARE_DIR} --work-tree=${DOTBARE_TREE} \
      log --oneline --graph --color=always --decorate=short {}"
}

#######################################
# let user select a dotbare tracked file interactively
# Arguments:
#   $1: the helper message to display in the fzf header
#   $2: if exist, don't do multi selection, do single
# Outputs:
#   the selected file path
#   e.g.$HOME/.config/nvim/init.vim
#######################################
function get_git_file() {
  local header="${1:-select a file}"
  local no_multi="$2"
  if [[ -z "${no_multi}" ]]; then
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --multi"
  else
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --no-multi"
  fi
  /usr/bin/git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
  ls-files --full-name --directory "${DOTBARE_TREE}" \
    | fzf --header="${header}" \
      --preview "head -50 ${DOTBARE_TREE}/{}" \
    | awk -v home="${DOTBARE_TREE}" '{print home "/" $0}'
}

#######################################
# let user select a modified file interactively
# Arguments:
#   $1: the helper message to display in the fzf header
#   $2: if exists, don't do multi selection, do single
# Outputs:
#   the selected file path
#   e.g.$HOME/.config/nvim/init.vim
#######################################
function get_modified_file() {
  local header="${1:-select a modified file}"
  local no_multi="$2"
  if [[ -z "${no_multi}" ]]; then 
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --multi"
  else
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --no-multi"
  fi
  /usr/bin/git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
  status --porcelain\
    | awk '{
        if ($0 ~ /^[A-Za-z].*$/) {
          print "\033[32m" substr($0, 1, 1) "\033[31m" substr($0, 2)
        } else {
          print "\033[31m" $0 "\033[0m"
        }
      }' \
    | fzf --header="${header}" --preview "echo {} \
        | awk '{print \$2}' \
        | xargs -I __ /usr/bin/git --git-dir=${DOTBARE_DIR} --work-tree=${DOTBARE_TREE} \
          diff --color=always ${DOTBARE_TREE}/__" \
    | awk -v home="${DOTBARE_TREE}" '{print home "/" $2}'
}
