# Found on the ZshWiki
#  http://zshwiki.org/home/config/prompt
#
#
prompt_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" && -n "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    prompt_segment blue black "(${VIRTUAL_ENV:t:gs/%/%%})"
  fi
}

PROMPT="%{$fg[white]%}%c (%m) >%{$reset_color%} "
RPROMPT='%{$fg[$NCOLOR]%} $(git_prompt_info)%{$reset_color%}$(prompt_virtualenv)' 

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

