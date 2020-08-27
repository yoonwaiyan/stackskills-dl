FROM ruby:2.4.4-alpine3.7

# Set environment variables
ARG STACKSKILLS_EMAIL
ARG STACKSKILLS_PASSWORD

ENV STACKSKILLS_EMAIL ${STACKSKILLS_EMAIL}
ENV STACKSKILLS_PASSWORD ${STACKSKILLS_PASSWORD}

# Basic packages setup
RUN apk update && apk upgrade
RUN apk add --no-cache git vim build-base wget

# Install youtube-dl
# Reference: https://github.com/wernight/docker-youtube-dl/blob/master/Dockerfile
# https://github.com/rg3/youtube-dl
RUN set -x \
  && apk add --no-cache ca-certificates curl ffmpeg python gnupg \
  && curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem \
  && export SSL_CERT_FILE=cacert.pem \
  && curl -Lo /usr/local/bin/youtube-dl https://yt-dl.org/downloads/latest/youtube-dl \
  && curl -Lo youtube-dl.sig https://yt-dl.org/downloads/latest/youtube-dl.sig \
  && gpg --keyserver keyserver.ubuntu.com --recv-keys '7D33D762FD6C35130481347FDB4B54CBA4826A18' \
  && gpg --keyserver keyserver.ubuntu.com --recv-keys 'ED7F5BF46B3BBED81C87368E2C393E0F18A9236D' \
  && gpg --verify youtube-dl.sig /usr/local/bin/youtube-dl \
  && chmod a+rx /usr/local/bin/youtube-dl \
  # Clean-up
  && rm youtube-dl.sig \
  && apk del curl gnupg \
  # Create directory to hold downloads.
  && mkdir /downloads \
  && chmod a+rw /downloads \
  # Basic check it works.
  && youtube-dl --version

# Setup working directory and add downloads folder
RUN mkdir /usr/app
WORKDIR /usr/app
COPY . /usr/app
RUN mkdir /usr/app/downloads

# Install Ruby dependencies
COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/
RUN bundle install
