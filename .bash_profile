RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"
LIGHT_BLUE="\[\033[0;36m\]"

function parse_git_branch {
  if [[ -d .git ]]; then
    git rev-parse --git-dir &> /dev/null
    git_status="$(git status 2> /dev/null)"
    branch_pattern="^# On branch ([^${IFS}]*)"
    remote_pattern="# Your branch is (.*) of"
    diverge_pattern="# Your branch and (.*) have diverged"
    if [[ $git_status ]]; then
      if [[ ! ${git_status}} =~ "working directory clean" ]]; then
        state="${RED}⚡"
      fi
      if [[ ${git_status} =~ "Changed but not updated" ]]; then
        state="${YELLOW}∆"
      fi
      if [[ ${git_status} =~ "Changes to be committed" ]]; then
        state="${RED}∆"
      fi
      if [[ ${git_status} =~ ${remote_pattern} ]]; then
        if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
          remote="${RED}↑"
        else
          remote="${YELLOW}↓"
        fi
      fi
      if [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote="${YELLOW}↕"
      fi
      if [[ ${git_status} =~ ${branch_pattern} ]]; then
        branch="${COLOR_NONE}[${GREEN}${BASH_REMATCH[1]}${COLOR_NONE}]"
      fi
      echo "${branch} ${remote}${state}"
    fi
  fi
}

function prompt_func() {
    previous_return_value=$?;
    # prompt="${TITLEBAR}$BLUE[$RED\w$GREEN$(__git_ps1)$YELLOW$(git_dirty_flag)$BLUE]$COLOR_NONE "
    prompt="${LIGHT_BLUE}\h${COLOR_NONE}:\W (${YELLOW}\u${COLOR_NONE})\n$(parse_git_branch)"
    if test $previous_return_value -eq 0
    then
        PS1="${prompt}${LIGHT_GRAY}\$${COLOR_NONE} "
    else
        PS1="${prompt}${RED}\$${COLOR_NONE} "
    fi
}

PROMPT_COMMAND=prompt_func
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

zsh --
