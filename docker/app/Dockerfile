FROM node:14.5.0-alpine as node

RUN apk add --no-cache bash curl && \
    curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 1.22.4


FROM ruby:2.7.1-alpine

ARG APP_ROOT
ARG BUILD_CONTEXT
ARG APP_DEPS=' \
    postgresql-client \
    xz-dev \
    '
ARG BUILD_DEPS=' \
    build-base \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    tzdata \
    '
ARG DEV_DEPS=' \
    git \
    less \
    nano \
    openssh \
    '
ENV RAILS_ENV $BUILD_CONTEXT
ENV NODE_ENV $BUILD_CONTEXT
ENV LANG=ja_JP.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR $APP_ROOT

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /opt/yarn-* /opt/yarn
COPY . .

RUN ln -fs /opt/yarn/bin/yarn /usr/local/bin/yarn && \
    apk add --no-cache $APP_DEPS $BUILD_DEPS && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    gem update --system && \
    gem install --no-document bundler:2.1.4 && \
    chmod +x ./docker/app/setup-${BUILD_CONTEXT}.sh && \
    ./docker/app/setup-${BUILD_CONTEXT}.sh
