export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="keita"

zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup


export EDITOR="nvim"
export TERM=xterm-256color


if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

plugins=(vi-mode)
INSERT_MODE_INDICATOR="%F{yellow}+%f"
bindkey -M viins 'jk' vi-cmd-mode

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)

# Golang
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GOPRIVATE=bitbucket.org/ayopop

export PATH="/usr/local/bin:$PATH"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Java
# export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
# export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH=$JAVA_HOME/bin:$PATH
export PATH="$PATH:$HOME/Downloads/server/bin"

# Android
export ANDROID=$HOME/Android
export PATH=$ANDROID/cmdline-tools:$PATH
export PATH=$ANDROID/cmdline-tools/latest:$PATH
export PATH=$ANDROID/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID/platform-tools:$PATH
# Android SDK
export ANDROID_SDK=$HOME/ANDROID
export PATH=$ANDROID_SDK:$PATH

# Flutter
PATH="$HOME/Flutter/flutter/bin:$PATH"


export PATH="$PATH:$HOME/Downloads/bin/"

# NodeJS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Rust
source "$HOME/.cargo/env"

# Functions

# Scrcpy

function scr ()
{
flag="$1"
app="$2"

case "$flag" in
    --app)
	    if [[ -n "$app" ]]; then
		    scrcpy --shortcut-mod=lctrl -b 1M --max-fps=60 -K --new-display --start-app="+?$app"
	    else
		    PKG=$(adb shell 'pm list packages' | sed 's/.*://g' | fzf)
		    [ -z "$PKG" ] && echo "No app selected"
		    scrcpy --shortcut-mod=lctrl -b 1M --max-fps=60 -K --new-display --start-app="$PKG"
	    fi
        ;;
    --sound)
	scrcpy --shortcut-mod=lctrl --audio-codec=flac --audio-bit-rate=64K -b 1M --audio-buffer=125 --no-video
        ;;
    --wireless)
        echo "[*] Switching device to TCP/IP mode on port 5555..."
  	adb tcpip 5555 || { echo "[!] Failed to switch to TCP mode"; exit 1; }

  	echo "[*] Getting device IP address..."
  	IP=$(adb shell ip addr show | grep 'inet ' | grep '192\.168\.' | awk '{print $2}' | cut -d/ -f1)

  	if [[ -z "$IP" ]]; then
    		echo "[!] Failed to get IP address of device. Is Wi-Fi enabled?"
  	fi

  	echo "[*] Connecting to $IP:5555..."
  	adb connect "$IP:5555"

  	echo "[*] Waiting for device to be authorized..."
  	for i in {1..10}; do
    		STATE=$(adb devices | grep "$IP" | awk '{print $2}')
    		echo "    Try $i: Device state = $STATE"
    		if [[ "$STATE" == "device" ]]; then
      			echo "[✓] Device authorized."
      			break
    		fi
    		sleep 1
  	done

	if [[ "$STATE" != "device" ]]; then
		echo "[!] Device not authorized or still offline. Please check your phone for authorization prompt."
	fi

	echo "[*] Launching scrcpy..."
	scrcpy --audio-bit-rate=128K --audio-buffer=125 -S -b 4M --max-size=1024 --max-fps=30 -K
  	;;

    *)
	scrcpy --audio-codec=flac --audio-bit-rate=64K --audio-output-buffer=10 -S -b 1M --max-size 1024 --max-fps=60 -K
        ;;
esac
}


# Git 
function gpf() {
	git add $(git ls-files --modified --others --exclude-standard | fzf -m --preview="git diff --color=always {}")
	if [[ -n $(git diff --name-only --cached) ]]; then
  		echo "Staged files:"
		git status --short
	else
  		echo "No staged files."
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

function h 
{
	command=$(history | grep -i "$1" | sed 's/.[ ]*.[0-9]*.[ ]*//' | uniq | fzf)
	bash -c $command
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
		docker exec -it $CONTAINER sh
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



lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

hg()
{
	command=$(history | tac | awk '{$1=""; print substr($0,2)}' | fzf)
	if [ -n $command ]; then
		eval $command
	fi
}

cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }

# Alias

# Foldering
alias ls="ls -a --color"
alias mkdir="mkdir -p"
alias fd="fdfind"

# Reload
alias reload="source ~/.zshrc"

# vimdiff
alias vimdiff="nvim -d"

# Movement
alias cp="rsync -av -P"
alias mv='mv -i'
alias v="fd --type f --hidden --exclude .git | fzf-tmux -p | xargs nvim"

# Tmux
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tk="tmux kill-session -t"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/arya/gcp/google-cloud-sdk/path.zsh.inc' ]; then . '/home/arya/gcp/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/arya/gcp/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/arya/gcp/google-cloud-sdk/completion.zsh.inc'; fi

if [ -e /home/$USER/.nix-profile/etc/profile.d/nix.sh ]; then
  . /home/$USER/.nix-profile/etc/profile.d/nix.sh
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
