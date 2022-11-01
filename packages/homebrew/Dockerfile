FROM fedora:37
# FROM ubuntu:latest
# SHELL ["/bin/bash", "-c"]

# RUN apt-get -y update
# RUN apt-get -y install git
# RUN apt-get install curl -y
# RUN apt install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev -y

# # INSTALL RUBY
# RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer
# RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
# RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
# RUN "source ~/.bashrc"

COPY . /opt/packages/homebrew/

WORKDIR /opt/packages/homebrew

RUN ./build.sh
