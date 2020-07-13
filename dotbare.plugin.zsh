0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
_path="${0:h}"

if [[ -z "${path[(r)$_path]}" ]]; then
  path+=( "${_path}" )
fi

__dotbare_completion() {
  local state line
  local -A opt_args
  ret=1

  _arguments -C \
    '(- : *)'{-h,--help}'[show help information]' \
    '(- : *)'{-v,--version}'[display dotbare version]' \
    '1:cmds:->cmds' \
    '*::options:->options' \
    && ret=0

  case "${state}" in
    cmds)
      local subcommands
      subcommands=(
        'fadd:stage files'
        'fbackup:backup files'
        'fcheckout:checkout file/branch/commit'
        'fedit:edit files'
        'finit:init/migrate dotbare'
        'flog:interactive log viewer'
        'freset:reset files/commit'
        'fstash:stage management'
        'fstat:toggle stage/unstage of files'
        'funtrack:untrack files'
        'fupgrade:update dotbare'
      )
      _describe 'command' subcommands \
        && ret=0
      ;;
    options)
      case "${line[1]}" in
        fadd)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-f --file -d --dir)'{-f,--file}'[select files from PWD and stage]' \
            '(-d --dir -f --file)'{-d,--dir}'[select directory from PWD and stage]' \
            && ret=0
        ;;
        fbackup)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-s --select -p --path)'{-s,--select}'[select tracked files to backup]' \
            '(-p --path -s --select)'{-p,--path}'[sepcify path of files to backup]:filename:_files' \
            '(-m --move)'{-m,--move}'[use mv cmd instead of cp cmd]' \
            && ret=0
          ;;
        fcheckout)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-s --select -b --branch -c --commit)'{-s,--select}'[select files and then checkout them in selected commits]' \
            '(-b --branch -s --select -c --commit)'{-b,--branch}'[checkout branch]' \
            '(-c --commit -b --branch -s --select)'{-c,--commit}'[checkout commit]' \
            '(-y --yes)'{-y,--yes}'[acknowledge all actions and skip confirmation]' \
            && ret=0
          ;;
        fedit)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-m --modified -c --commit)'{-m,--modified}'[edit modified files]' \
            '(-c --commit -m --modified)'{-c,--commit}'[edit commits]' \
            && ret=0
          ;;
        finit)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-u --url)'{-u,--url}'[migrate remote dotfiles to current system]: :->url' \
            '(-s --submodule)'{-s,--submodule}'[clone submodules during migration]' \
            '(-y --yes)'{-y,--yes}'[acknowledge all actions and skip confirmation]' \
            && ret=0
          ;;
        flog)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-r --revert -R --reset -e --edit -c --checkout)'{-r,--revert}'[revert the selected commit and skip action menu]' \
            '(-r --revert -R --reset -e --edit -c --checkout)'{-R,--reset}'[reset the selected commit and skip action menu]' \
            '(-r --revert -R --reset -e --edit -c --checkout)'{-e,--edit}'[edit the selected commit and skip action menu]' \
            '(-r --revert -R --reset -e --edit -c --checkout)'{-c,--checkout}'[checkout the selected commit and skip action menu]' \
            '(-y --yes)'{-y,--yes}'[acknowledge all actions and skip confirmation]' \
            && ret=0
          ;;
        freset)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-c --commit)'{-c,--commit}'[reset HEAD to certain commit]' \
            '(-S --soft -H --hard)'{-S,--soft}'[reset commit using --soft flag]' \
            '(-H --hard -S --soft)'{-H,--hard}'[reset commit using --hard flag]' \
            '(-y --yes)'{-y,--yes}'[acknowledge all actions and skip confirmation]' \
            && ret=0
          ;;
        fstash)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-s --select -d --delete -p --pop)'{-s,--select}'[list modified files and stash the selected files]' \
            '(-s --select -d --delete -p --pop)'{-d,--delete}'[list stash and delete the selected stash]' \
            '(-s --select -d --delete -p --pop)'{-p,--pop}'[use "stash pop" instead of "stash apply"]' \
            && ret=0
          ;;
        fstat)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            && ret=0
          ;;
        funtrack)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            '(-t --temp -r --resume)'{-t,--temp}'[temporarily ignore changes of the selected files]' \
            '(-t --temp -r --resume)'{-r,--resume}'[resume tracking changes of the selected files]' \
            '(-y --yes)'{-y,--yes}'[acknowledge all actions and skip confirmation]' \
            && ret=0
          ;;
        fupgrade)
          _arguments \
            '(- : *)'{-h,--help}'[show help information]' \
            && ret=0
          ;;
      esac
  esac

  return "${ret}";
}

_dotbare_completion_cmd() {
  local compdef_name="${1:-dotbare}"
  compdef __dotbare_completion "${compdef_name}"
}

_dotbare_completion_git() {
  local compdef_name="${1:-dotbare}"
  compdef "${compdef_name}"=git
}
