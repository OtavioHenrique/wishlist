FROM ruby:2.7.1-alpine3.12

ENV LANG C.UTF-8

WORKDIR /app

COPY Gemfile* ./

RUN bundle config build.nokogiri --use-system-libraries && \
    apk --update add --no-cache make gcc g++ git curl libxslt-dev mariadb-dev libgcrypt-dev bash libxml2-dev tzdata \
      libgcc libstdc++ libx11 glib && \
    bundle install --no-cache && \
    bundle binstubs puma && \
    apk del make gcc g++ git && \
    rm -rf /var/cache/apk/*

ADD . /app

CMD ["bin/", "puma", "-C", "config/puma.rb"]
