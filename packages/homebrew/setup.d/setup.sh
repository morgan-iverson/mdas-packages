#!/bin/bash

set -x
set -eo pipefail

PROJECT_DIR=$(cd "$(dirname $BASH_SOURCE)/.."; pwd) # /opt/packages/homebrew/

HOMEBREW_TARGET=$PROJECT_DIR/homebrew/Homebrew


cd $PROJECT_DIR/homebrew
tar -xvf $HOMEBREW_TARGET.tar.gz
# eval "$(homebrew/bin/brew shellenv)" # ??
# brew update --force --quiet
# chmod -R go-w "$(brew --prefix)/share/zsh"

##  ORIGINAL
# mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
# eval "$(homebrew/bin/brew shellenv)"
# brew update --force --quiet
# chmod -R go-w "$(brew --prefix)/share/zsh"
# remove .tgz