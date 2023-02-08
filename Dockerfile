FROM ubuntu:18.04

ARG DEFAULT_SHELL
ARG FLAVOR

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
# Home directory
ENV HOME=/home/jamesnguyen

# Bootstrapping packages needed for installation
RUN \
  apt-get update -y && \
  apt-get install -yqq \
    locales \
    lsb-release \
    software-properties-common

# Set locale to UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN \
  localedef -i en_US -f UTF-8 en_US.UTF-8 && \
  /usr/sbin/update-locale LANG=$LANG

# Install dependencies
RUN \
  apt-get install -yqq \
    curl \
    git

# Set up zsh if it is selected as default shell
RUN \
  if [ "$DEFAULT_SHELL" = "zsh" ]; then \
    apt-get install -yqq zsh && \
    # Make zsh as login shell
    chsh -s $(which zsh); \
  fi

# Cleans up after the installation
RUN \
  apt-get -y autoremove && \
  apt-get clean autoclean && \
  rm -fr /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
