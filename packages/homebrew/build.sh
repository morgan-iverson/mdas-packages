#!/bin/bash

# Runs BEFORE profile.d (Executions)
set -x
set -eo pipefail

PROJECT_DIR=$(cd "$(dirname $BASH_SOURCE)/.."; pwd)

HOMEBREW_TARGET=$PROJECT_DIR/homebrew/homebrew/Homebrew

mkdir -p $PROJECT_DIR/homebrew/homebrew


cd $PROJECT_DIR/homebrew
# exit 1
# INSTALL & UNPACK
curl -L -o $HOMEBREW_TARGET.tar.gz https://github.com/Homebrew/brew/tarball/master
tar -xvf $HOMEBREW_TARGET.tar.gz --strip 1
# eval "$($(pwd)/bin/brew shellenv)" 
# brew update --force --quiet
# chmod -R go-w "$(brew --prefix)/share/zsh"