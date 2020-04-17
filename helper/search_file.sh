#!/bin/bash
#
# search local file or directory taking consideration of optional dependency

#######################################
# search local file
# Arguments:
#   $1: stirng, f or d, search file or directory
# Outputs:
#   A user selected file path
#######################################
function search_file() {
  local search_type="$1"
  local exe_fd
  exe_fd="$(fd_exists)"
  if [[ "${search_type}" == "f" ]]; then
    if [[ "${exe_fd}" -eq 0 ]]; then
      fd -H -d 1 -t f | fzf --multi --preview "head -50 {}"
    else
      find . -maxdepth 1 -type f | sed "s|\./||g" | fzf --multi --preview "head -50 {}"
    fi
  elif [[ "${search_type}" == "d" ]]; then
    exe_tree="$(tree_exists)"
    if [[ "${exe_fd}" -eq 0 && "${exe_tree}" -eq 0 ]]; then
      fd -H -d 1 -t d -E .git | fzf --multi --preview "tree -L 1 -C --dirsfirst {}"
    elif [[ "${exe_fd}" -eq 0 && "${exe_tree}" -ne 0 ]]; then
      fd -H -d 1 -t d -E .git | fzf --multi
    elif [[ "${exe_fd}" -ne 0 && "${exe_tree}" -eq 0 ]]; then
      find . -maxdepth 1 -type d | awk '{if ($0 != "." && $0 != "./.git"){print $0}}' | sed "s|\./||g" | fzf --multi --preview "tree -L 1 -C --dirsfirst {}"
    else
      find . -maxdepth 1 -type d | awk '{if ($0 != "." && $0 != "./.git"){print $0}}' | sed "s|\./||g" | fzf --multi
    fi
  fi
}

function fd_exists() {
  fd -V &>/dev/null
  echo "$?"
}

function tree_exists() {
  tree --version &>/dev/null
  echo "$?"
}
