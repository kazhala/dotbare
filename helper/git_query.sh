#!/usr/bin/env bash
#
# helper functions to obtain git related information

#######################################
# let user select a commit interactively
# credit to forgit for the git log format
# Arguments:
#   $1: the helper message to display in the fzf header
#   $2: files to show diff against HEAD
# Outputs:
#   the selected commit 6 char code
#   e.g. b60b330
#######################################
# TODO: line33 "${files[*]}" cannot handle space in file names, but "${files[@]}" won't get properly
# processed by git for whatever reason just in this preview situation but works every where else, HELP needed.
# although this won't affect any real functionality or break the code, it will just print a error message in preview.
function get_commit() {
  local header="${1:-select a commit}"
  local files=("${@:2}")
  if [[ "${#files[@]}" -eq 0 ]]; then
    git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
      log --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' \
      | fzf --header="${header}" --no-multi \
          --preview "echo {} \
          | awk '{print \$1}' \
          | xargs -I __ git --git-dir=${DOTBARE_DIR} --work-tree=${DOTBARE_TREE} \
              show --color=always  __ \
          | ${DOTBARE_DIFF_PAGER}" \
      | awk '{print $1}'
  else
    git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
      log --oneline --color=always --decorate=short \
      | fzf --header="${header}" --no-multi --preview "echo {} \
          | awk '{print \$1}' \
          | xargs -I __ git --git-dir=${DOTBARE_DIR} --work-tree=${DOTBARE_TREE} \
              diff --color=always __ ${files[*]} \
          | ${DOTBARE_DIFF_PAGER}" \
      | awk '{print $1}'
  fi
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
  git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" branch -a \
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
        --preview="echo {} \
      | awk '{
          if (\$0 ~ /.*HEAD.*/) {
            print \"HEAD\"
          } else {
            print \$0
          }
        }' \
      | xargs -I __ git --git-dir=${DOTBARE_DIR} --work-tree=${DOTBARE_TREE} \
          log --color=always --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' __" 
}

#######################################
# let user select a dotbare tracked file interactively
# Arguments:
#   $1: the helper message to display in the fzf header
#   $2: print option, values (full|raw)
#   $3: if exist, don't do multi selection, do single
# Outputs:
#   the selected file path
#   e.g.$HOME/.config/nvim/init.vim
#######################################
function get_git_file() {
  local mydir
  local header="${1:-select tracked file}"
  local print_opt="${2:-full}"
  mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  set_fzf_multi "$3"
  git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
    ls-files --full-name --directory "${DOTBARE_TREE}" \
    | fzf --header="${header}" \
        --preview "${mydir}/../helper/preview.sh ${DOTBARE_TREE}/{}" \
    | awk -v home="${DOTBARE_TREE}" -v print_opt="${print_opt}" '{
        if (print_opt == "full") {
          print home "/" $0
        } else {
          print $0
        }
      }'
}

#######################################
# let user select a modified file interactively
# Arguments:
#   $1: the helper message to display in the fzf header
#   $2: display mode of modified files.
#     default: true
#     all: display all modified, include staged and unstaged
#     staged: display only staged files
#     unstaged: display only unstaged files
#   $3: output_format
#     default: name
#     name: formatted name of the file
#     raw: raw file name with status
#   $4: if exists, don't do multi selection, do single
# Outputs:
#   the selected file path
#   e.g.$HOME/.config/nvim/init.vim
#######################################
function get_modified_file() {
  local header="${1:-select a modified file}"
  local display_mode="${2:-all}"
  local output_format="${3:-name}"
  set_fzf_multi "$4"
  git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
    status --porcelain \
    | awk -v display_mode="${display_mode}" '{
        if ($0 ~ /^[A-Za-z][A-Za-z].*$/) {
          print "\033[32m" substr($0, 1, 1) "\033[31m" substr($0, 2) "\033[0m"
        } else if ($0 ~ /^[A-Za-z][ \t].*$/) {
          if (display_mode == "all" || display_mode == "staged") {
            print "\033[32m" $0 "\033[0m"
          }
        } else {
          if (display_mode == "all" || display_mode == "unstaged") {
            print "\033[31m" $0 "\033[0m"
          }
        }
      }' \
    | fzf --header="${header}" --preview "echo {} \
        | awk '{sub(\$1 FS,\"\");print \$0}' \
        | xargs -I __ git --git-dir=${DOTBARE_DIR} --work-tree=${DOTBARE_TREE} \
            diff HEAD --color=always -- ${DOTBARE_TREE}/__ \
        | ${DOTBARE_DIFF_PAGER}" \
    | awk -v home="${DOTBARE_TREE}" -v format="${output_format}" '{
        if (format == "name") {
          $1=""
          gsub(/^[ \t]/, "", $0)
          gsub(/"/, "", $0)
          print home "/" $0
        } else {
          print $0
        }
      }'
}

#######################################
# let user select a stash interactively
# Arguments:
#   $1: the helpe message to display in header
#   $2: if exists, don't do multi select, only allow single selection
# Outputs:
#   the selected stash identifier
#   e.g. stash@{0}
#######################################
function get_stash() {
  local header="${1:-select a stash}"
  set_fzf_multi "$2"
  git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
    stash list \
    | fzf --header="${header}" --preview "echo {} \
        | awk '{
            gsub(/:/, \"\", \$1)
            print \$1
          }' \
        | xargs -I __ git --git-dir=${DOTBARE_DIR} --work-tree=${DOTBARE_TREE} \
            stash show -p __ --color=always \
        | ${DOTBARE_DIFF_PAGER}" \
    | awk '{
        gsub(/:/, "", $1)
        print $1
      }'
}

#######################################
# Using git grep to find word within
# all tracked files in the bare repo.
# Arguments:
#   $1: the help message to display in header
#   $2: if exists, don't do multi select, only allow single selection
# Outputs:
#   the selected file name with it's line number and line, seperated by ":"
#   e.g. .bash_profile:1:echo hello
#######################################
function grep_lines() {
  local header="${1:-select lines to edit}"
  set_fzf_multi "$2"
  cd "${DOTBARE_TREE}"
  git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
    grep --line-number -- . \
    | fzf --delimiter : --nth 3.. --header="${header}" \
        --preview "${mydir}/../helper/preview.sh ${DOTBARE_TREE}/{}" \
    | awk -F ":" -v home="${DOTBARE_TREE}" '{
        print home "/" $1 ":" $2
      }'
}
