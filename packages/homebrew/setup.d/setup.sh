#!/bin/bash

set -x
set -eo pipefail

PROJECT_DIR=$(cd "$(dirname $BASH_SOURCE)/.."; pwd) # /opt/packages/homebrew/

HOMEBREW_TARGET=$PROJECT_DIR/homebrew/Homebrew
# HOMEBREW_HOME=$PROJECT_DIR/homebrew/Homebrew


cd $PROJECT_DIR/homebrew
tar -xvf --strip 1 $HOMEBREW_TARGET.tar.gz
# eval "$(homebrew/bin/brew shellenv)" # ??
# brew update --force --quiet
# chmod -R go-w "$(brew --prefix)/share/zsh"

# HOMEBREW_HOME=$HOMEBREW_TARGET/bin
# PATH=$HOMW


##  ORIGINAL
# mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
# eval "$(homebrew/bin/brew shellenv)"
# brew update --force --quiet
# chmod -R go-w "$(brew --prefix)/share/zsh"
# remove .tgz