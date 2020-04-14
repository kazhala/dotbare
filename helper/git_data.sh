#!/bin/bash
#
# helper functions to obtain git related information

#######################################
# let user select a commit interactively
# Outputs:
#   the selected commit 6 char code
#   e.g. b60b330
#######################################
function get_commit() {
  /usr/bin/git --git-dir="${DOTBARE_DIR}" --work-tree="${DOTBARE_TREE}" \
    log --oneline --color=always --decorate=short | \
    fzf --no-multi --header='select which commit to reset' --preview "echo {} | awk '{print \$1}' | \
      xargs -I __ /usr/bin/git --git-dir=${DOTBARE_DIR} --work-tree=${DOTBARE_TREE} show --color=always  __" | \
    awk '{print $1}'
}
