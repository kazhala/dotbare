# Standardized $0 handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
local _path="${0:h}"

if [[ -z "${path[(r)$_path]}" ]]; then
    path+=( "$_path" )
fi

function _dotbare_completion_cmd {
  local context state state_descr line ret
  local -A opt_args
  ret=1

  _arguments -C \
    '(- : *)'{-h,--help}'[Show help information]' \
    '(- : *)'{-v,--version}'[Display dotbare version]' \
    '1:cmds:->cmds' \
    '*::options:->options' \
    && ret=0

  case "${state}" in
    cmds)
       local subcommands
       subcommands=(
        'fadd:Stage files'
        'fbackup:Backup files'
        'fcheckout:Checkout file/branch/commit'
        'fedit:Edit files'
        'finit:Init/migrate dotbare'
        'flog:Interactive log viewer'
        'freset:Reset files/commit'
        'fstash:Stage management'
        'fstat:Toggle stage/unstage of files'
        'funtrack:Untrack files'
        'fupgrade:Update dotbare'
       )
      _describe -t commands 'command' subcommands \
        && ret=0
      ;;
    options)
      case "${line[1]}" in
        fadd)
          __dotbare_complete_fadd
        ;;
        fbackup)
          __dotbare_complete_fbackup
          ;;
        fcheckout)
          __dotbare_complete_fcheckout
          ;;
      esac
  esac

  return "${ret}";
}

function __dotbare_complete_fadd() {
  local context state state_descr line
  typeset -A opt_args
  ret=1
  _arguments \
    '(- : *)'{-h,--help}'[Show help information]' \
    '(-f --file -d --dir)'{-f,--file}'[Select files from PWD and stage]' \
    '(-d --dir -f --file)'{-d,--dir}'[Select directory from PWD and stage]' \
    && ret=0
  return "${ret}"
}

function __dotbare_complete_fbackup() {
  local context state state_descr line
  typeset -A opt_args
  ret=1
  _arguments \
    '(- : *)'{-h,--help}'[Show help information]' \
    '(-s --select -p --path)'{-s,--select}'[Select tracked files to backup]' \
    '(-p --path -s --select)'{-p,--path}'[Sepcify path of files to backup]:filename:_files' \
    '(-m --move)'{-m,--move}'[Use mv cmd instead of cp cmd]' \
    && ret=0
  return "${ret}"
}

function __dotbare_complete_fcheckout() {
  local context state state_descr line
  typeset -A opt_args
  ret=1
  _arguments \
    '(- : *)'{-h,--help}'[Show help information]' \
    '(-s --select -b --branch -c --commit)'{-s,--select}'[Select files and then checkout them in selected commits]' \
    '(-b --branch -s --select -c --commit)'{-b,--branch}'[Checkout branch]' \
    '(-c --commit -b --branch -s --select)'{-c,--commit}'[Checkout commit]' \
    '(-y --yes)'{-y,--yes}'[Acknowledge all actions and skip confirmation]' \
    && ret=0
  return "${ret}"
}

compdef _dotbare_completion_cmd dotbare
