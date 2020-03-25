FROM ruby:2.6.5-buster

WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y build-essential libpq-dev && \
    apt-get install -y postgresql && \
    gem update --system && \
    gem install rails -v "6.0.2.2" && \
    gem install bundler && \
    gem install solargraph && \
    gem install rubocop && \
    gem install rubocop-performance && \
    gem install rubocop-rails && \
    gem install ruby-debug-ide && \
    gem install debase

# Node.js
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install nodejs

# yarn
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn && \ 
    apt-get clean && \
    rm -r /var/lib/apt/lists/*
