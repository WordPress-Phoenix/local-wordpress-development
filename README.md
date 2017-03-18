# Getting Started developing locally

A Mac users guide to getting started with developing WordPress sites locally on your computer. Unfortunately this guide is aimed to mac users, and many of the concepts will not transalte to PC's just because the operating systems do not support the same features. Some parts and concepts will work cross platform.

## Using Homebrew `brew` to manage OS pacakges

### Quickstart -> install
```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Why brew?

Brew is a package manager. A package what? It manages tools your mac will need at its core, the most common package for developers is GIT. Instead of following long guides of typing CLI commands and configuring files in directories you can never remebmer, you can now have these tools "automatically" threw brew. Brew is considerably different today, then it was several years ago. Throw out your previous notions of brew and just give it a try.

## Install brew packages we will use as developers

### Quickstart -> install all packages
#### Suggested for Development
```bash
brew tap caskroom/cask && \
brew install grc git svn node imagemagick pkg-config hub && \
git config --global credential.helper osxkeychain 
brew cask install virtualbox vagrant vagrant-manager
brew cask install iterm2 sequel-pro 
```
#### Recommended for productivity
```
brew cask install phpstorm slack
brew cask install alfred spectacle flux dash imageoptim clipmenu
brew cask install filezilla google-chrome parallels-desktop spotify snagit
```

## Setup Bash Profile and Features
Setting up your terminal profile is very important for productivity. We recommend the following enhancements. Being by opening your bash profile configuration file. 

### Using terminal to setup .bash_profile
```bash
nano ~/.bash_profile
```
Then copy the following and past it into the terminal text editor we just used to open the file.
```bash
alias ls="ls -GHf"
alias ll='ls -lartG'
alias hosts='sudo nano /private/etc/hosts'
alias flushdns='sudo dscacheutil -flushcache'
alias vup="vagrant up --provision"
export PATH="/usr/local/sbin:$PATH"
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder/System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias pruneknownhosts="sed -i -e s/*.*//g ~/.ssh/known_hosts"
alias prunedevhosts="sed -i -e s/.*\.dev.*//g ~/.ssh/known_hosts"

alias dke="docker exec -i -t"
alias dkps="docker ps -a"
alias dkls="docker images"

# REST HELPER
httpHeaders () { /usr/bin/curl -I -L $@ ; }

# docker functions
dkRun () { docker run -dit $@ ; }
dkBuild () { docker build . -t $@ ; }
dkClean () { [[ $(docker ps -a -q -f status=exited) ]] && docker rm -v $(docker ps -a -q -f status=exited) ; }
dkCleanImages () { docker rmi $(docker images | grep "^<none>" | awk '{print $3}') ; }
```

Lastly save and close the file with `Ctrl+X` then `Enter` and one more `Enter`.

### Using terminal to setup .inputrc
Input RC controls what happens as you type in terminal. We are going to setup a feature that allows terminal to use "per command history". When in terminal you can hit the up and down arrows to cycle through previously used commands. With this extra configuration file, it will allow you to track "per command" history. So if you typed "git push" then "cd www", you may want to only search your history for "git" commands. To do so, simply type "git" and then press up, it will only search your history for git commands and find "git push" as desired.

Open the .inputrc file from terminals nano editor:
```
nano ~/.inputrc
```

Then copy and paste the following into the editor.
```
"\e[B": history-search-forward
"\e[A": history-search-backward
set completion-ignore-case On
```

Lastly save and close the file with `Ctrl+X` then `Enter` and one more `Enter`.

### Enabling new terminal profile features

The easiest way to enable new terminal features is to restart terminal, or open a new terminal tab. You can however, alternatively force your current terminal sessions profile to be updated with
```
source ~/.bash_profile
```
