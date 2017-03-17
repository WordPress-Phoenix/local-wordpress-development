# Getting Started developing locally

A Mac users guide to getting started with developing WordPress sites locally on your computer. Unfortunately this guide is aimed to mac users, and many of the concepts will not transalte to PC's just because the operating systems do not support the same features. Some parts and concepts will work cross platform.

## Using Homebrew `brew` to manage OS pacakges

### Quickstart -> install
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Why brew?

Brew is a package manager. A package what? It manages tools your mac will need at its core, the most common package for developers is GIT. Instead of following long guides of typing CLI commands and configuring files in directories you can never remebmer, you can now have these tools "automatically" threw brew. Brew is considerably different today, then it was several years ago. Throw out your previous notions of brew and just give it a try.

## Install brew packages we will use as developers

### Quickstart -> install all packages
```
brew tap caskroom/cask && \
brew install grc git svn node imagemagick pkg-config hub && \
git config --global credential.helper osxkeychain 
brew cask install virtualbox vagrant vagrant-manager
brew cask install alfred spectacle flux slack dash imageoptim clipmenu
brew cask install iterm2 sequel-pro phpstorm 

```
