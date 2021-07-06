FROM ruby:2.7.3-alpine3.13 AS GEMS

RUN apk add --update --no-cache build-base postgresql-dev

RUN gem install bundler -v 1.17.3
COPY . /app/

WORKDIR /app

RUN bundle install --no-cache

FROM ruby:2.7.3-alpine3.13

RUN apk add --update --no-cache postgresql-client

COPY --from=GEMS /usr/local/bundle/ /usr/local/bundle/
COPY --from=GEMS /app/ /app/

WORKDIR /app

ENTRYPOINT ["bundle", "exec"]
CMD ["rackup"]
