#!/bin/bash

set -x
set -eo pipefail

PROJECT_DIR=$(cd "$(dirname $BASH_SOURCE)/.."; pwd) # /opt/packages/homebrew/

HOMEBREW_TARGET=$PROJECT_DIR/homebrew/Homebrew


cd $PROJECT_DIR/homebrew
tar -xvf $HOMEBREW_TARGET.tar.gz --strip 1
eval "$(homebrew/bin/brew shellenv)" 
brew update --force --quiet
chmod -R go-w "$(brew --prefix)/share/zsh"

rm HOMEBREW_TARGET

HOMEBREW_HOME=$(pwd)
PATH=$HOMEBREW/bin:$PATH
