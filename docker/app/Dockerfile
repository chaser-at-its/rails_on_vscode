FROM ruby:2.6.6-slim

WORKDIR /tmp

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY package.json package.json
COPY yarn.lock yarn.lock

# 警告 "debconf: delaying package configuration, since apt-utils is not installed" 抑止のため
ENV DEBCONF_NOWARNINGS yes
# Node.js 最新版インストールのため
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE 1

RUN appdeps=' \
    build-essential \
    libpq-dev \
    postgresql-client \
    locales \
    ' \
    tmpdeps=' \
    curl \
    apt-transport-https \
    wget \
    ' && \
    apt-get -q update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $appdeps $tmpdeps && \
    echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    gem install bundler && \
    gem install rails -v "6.0.2.2" && \
    bundle install && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get -q update && \
    apt-get install -y --no-install-recommends nodejs yarn && \
    yarn install && \
    apt-get purge -y --auto-remove $tmpdeps && \
    apt-get clean && \
    rm -r /tmp/*

ENV LC_ALL ja_JP.UTF-8

# 開発環境ではホストのアプリディレクトリをマウントするため不要だが、リリース時に必要
WORKDIR /myapp
COPY . .
