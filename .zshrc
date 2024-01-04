export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="keita"

export EDITOR="nvim"
export TERM=xterm-256color


if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

plugins=()

source $ZSH/oh-my-zsh.sh

# Golang
export GOPATH=/home/aya/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


export PATH="$PATH:$HOME/Sandbox/lua-language-server/bin/"

# NodeJS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Rust
source "$HOME/.cargo/env"

# Functions

# Git 
function gpf() {
	git add $(git ls-files --modified --others --exclude-standard | fzf -m --preview="git diff --color=always {}")
	if [[ -n $(git diff --name-only --cached) ]]; then
  		echo "Staged files:"
		git status --short
		echo "Commit message: "
		read message 
		git commit -m "$message"
	else
  		echo "No staged files."
	fi

}
function gaf() {
	git add $(git ls-files --modified --others --exclude-standard | fzf -m --preview="git diff --color=always {}")
	if [[ -n $(git diff --name-only --cached) ]]; then
  		echo "Staged files:"
		git status --short
		echo "Commit message: "
		read message 
		git commit -m "$message"
	else
  		echo "No staged files."
	fi

}




function gifz ()
{
	local ignore_file=".gitignore"
	local selected_file

  	selected_file=$(fzf --prompt="Select file to add to .gitignore: " --preview="bat --color=always {}")

  	if [ -n "$selected_file" ]; then
	  	[ -e "$ignore_file" ] || touch "$ignore_file"

    		if ! grep -q "^$selected_file$" "$ignore_file"; then
	    		echo "$selected_file" >> "$ignore_file"
	    		echo "Added '$selected_file' to .gitignore."
    		else
	    		echo "'$selected_file' is already in .gitignore."
    		fi
	else
		echo "No file selected."
  	fi
}

function gcf(){
 	git rev-parse HEAD > /dev/null 2>&1 || return

	branch=$(git branch --color=always --all --sort=-committerdate |
        	grep -v HEAD |
        	fzf --height 50% --ansi --no-multi --preview-window right:65% \
            	--preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        	sed "s/.* //")
 	if [[ "$branch" = "" ]]; then
        	echo "No branch selected."
        	return
    	fi

    	if [[ "$branch" = 'remotes/'* ]]; then
        	git checkout --track $branch
    	else
        	git checkout $branch;
    	fi
}

function glf(){
	local out shas sha q k
	while out=$(
		git log --graph --color=always \
			--format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
			fzf --ansi --multi --no-sort --reverse --query="$q" \
			--print-query --expect=ctrl-d --toggle-sort=\`); do
					q=$(head -1 <<< "$out")
					k=$(head -2 <<< "$out" | tail -1)
					shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
					[ -z "$shas" ] && continue
					if [ "$k" = ctrl-d ]; then
						git diff --color=always $shas | less -R
					else
						for sha in $shas; do
							git show --color=always $sha | less -R
						done
					fi
				done
}


function ex {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

# Docker

function dex() {
	CONTAINER=`docker ps | rg -v CONTAINER | awk '-F ' ' {print $NF}' | fzf`
	if [ ! -z $CONTAINER ]
	then
		docker exec -it $CONTAINER bash
	fi
}

function drm ()
{
	IMAGE=`docker image ls | rg -v CONTAINER | awk '-F ' ' {print $1}' | fzf`
	if [ ! -z $IMAGE ]
	then
		docker image rm --force $IMAGE
		echo "Succesfully remove image $IMAGE"
	fi
}

function dst ()
{
	CONTAINER=`docker ps | rg -v CONTAINER | awk '-F ' ' {print $NF}' | fzf`
	if [ ! -z $CONTAINER ]
	then
		docker stop $CONTAINER
		echo "Succesfully stop container $CONTAINER"
	fi
}

# Java

# Change java version
cj() {
	# Get the list of available Java versions
	java_versions=$(sudo update-java-alternatives --list 2>/dev/null | awk '{print $1}')

	# Check if there are available Java versions
	if [ -z "$java_versions" ]; then
  		echo "No Java versions found."
  		exit 1
	fi

	# Use fzf to select a Java version
	selected_version=$(echo "$java_versions" | fzf --prompt "Select Java Version: ")

	# Check if a version was selected
	if [ -n "$selected_version" ]; then
  		# Use sudo to set the selected Java version as the default
  		sudo update-java-alternatives --set "$selected_version"
  		echo "Java version set to $selected_version"
	else
  		echo "No version selected. Exiting."
	fi
}

# Extract
function ex {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}


# File 
function f() {
	cd && cd $(find * -type d | fzf)
}

# PID 
nuke() {
  local pid
  pid=$(ps -ef | grep -v ^root | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Carriage enter
function nvim_paste ()
{
	# Check for win32yank.exe executable
if command -v win32yank.exe >/dev/null 2>/dev/null; then
    # The --lf option pastes data unix style. Which is what I almost always want.
    win32yank.exe -o --lf
else
    # Else rely on PowerShell being installed and available.
    powershell.exe Get-Clipboard | tr -d '\r' | sed -z '$ s/\n$//'
fi
}


lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# Alias

# Reload
alias reload="source ~/.zshrc"

# vimdiff
alias vimdiff="nvim -d"

# Movement
alias cp="rsync -av -P"
alias mv='mv -i'
alias v="fd --type f --hidden --exclude .git | fzf-tmux -f | xargs nvim"

# Tmux
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tk="tmux kill-session -t"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
