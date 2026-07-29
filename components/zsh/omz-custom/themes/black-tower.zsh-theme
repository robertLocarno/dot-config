CURRENT_BG='NONE'
SEGMENT_SEPARATOR_RIGHT='\ue0c7'
SEGMENT_SEPARATOR_LEFT='\ue0b0'

ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
ZSH_THEME_GIT_PROMPT_DIRTY=''
ZSH_THEME_GIT_PROMPT_STASHED=' ⚑'
ZSH_THEME_GIT_PROMPT_DIVERGED=' ⚡'
ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
ZSH_THEME_GIT_PROMPT_AHEAD=' ⬆'
ZSH_THEME_GIT_PROMPT_BEHIND=' ⬇'
ZSH_THEME_GIT_PROMPT_DIRTY=' ±'

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR_LEFT%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_segment_right() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    echo -n "%K{$CURRENT_BG}%F{$1}$SEGMENT_SEPARATOR_RIGHT%{$bg%}%{$fg%} "
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR_LEFT"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

prompt_user_hostname() {
  local user=`whoami`

	# prompt_segment white black "%(!.%{%F{yellow}%}.)$user@%m"
	prompt_segment white black

	echo -ne "%B$user"
}

prompt_dir() {
  # '': default, 15: bright-white
  prompt_segment '' 15 '%~'
}

prompt_user_input() {
	prompt_segment '' 13 "\ue0c7\ue0b0"
}

prompt_git() {
  local ref dirty _bg
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null)

		if [[ -n $dirty ]]; then
			_bg=red
		else
			_bg=green
		fi

		prompt_segment_right $_bg black
		# echo -n "\ue0a0 ${ref/refs\/heads\//}$dirty"$(git_prompt_status)" %F{$_bg}%k\ue0c6"
		echo -n "\ue0a0 ${ref/refs\/heads\//}$dirty"$(git_prompt_status)" "
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{yellow}%}✖"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

build_prompt() {
	RETVAL=$?
	prompt_status

  prompt_user_hostname
  prompt_dir
	prompt_user_input
  prompt_end
}

#Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

build_rprompt() {
  prompt_git
}

PROMPT='%{%f%b%k%}$(build_prompt) '
RPROMPT='%{%f%b%k%}$(build_rprompt)'
