# Standardized $0 handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
local _path="${0:h}"

if [[ -z "${path[(r)$_path]}" ]]; then
    path+=( "$_path" )
fi
