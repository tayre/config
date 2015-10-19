export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# A few usefull aliases
alias l='ls -la'
alias ll='ls -l'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Create simple aliases for colors
export BLACK="\033[01;30m"
export MAGENTA="\033[1;31m"
export ORANGE="\033[1;33m"
export GREEN="\033[1;32m"
export PURPLE="\033[1;35m"
export WHITE="\033[1;37m"
export BOLD=""
export RESET="\033[m"

if [[ $- == *i* ]]
then
    c_cyan=`tput setaf 6`
    c_red=`tput setaf 1`
    c_green=`tput setaf 2`
    c_sgr0=`tput sgr0`
fi

parse_git_branch ()
{
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        git_status="$(git status 2> /dev/null)"
        branch_pattern="On branch ([^${IFS}]*)"
        remote_pattern="# Your branch is (.*) of"
        diverge_pattern="# Your branch and (.*) have diverged"
        # add an else if or two here if you want to get more specific
        if [[ ${git_status} =~ ${remote_pattern} ]]; then
          if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
            remote="↑"
          elif [ ${BASH_REMATCH[1]} == "behind" ]]; then
            remote="↓"
          fi
        fi
        if [[ ${git_status} =~ ${diverge_pattern} ]]; then
          remote=":arrow_up_down:"
        fi
        if [[ ${git_status} =~ ${branch_pattern} ]]; then
          branch=${BASH_REMATCH[1]}
          echo "[${branch}${remote}]"
        fi
    else
        return 0
    fi
}
branch_color ()
{
    if git rev-parse --git-dir >/dev/null 2>&1
    then
        git_status="$(git status 2> /dev/null)"
        color=""
        if [[ ${git_status} =~ "working directory clean" ]]; then
            color="${c_green}"
        else
            color=${c_red}
        fi
    else
        return 0
    fi
    echo -ne $color
}

export PS1='\w\[${c_sgr0}\] \[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]: '
