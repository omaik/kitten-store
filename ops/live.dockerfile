FROM ruby:2.4.9-alpine AS GEMS

RUN apk add --update --no-cache build-base postgresql-dev

RUN gem install bundler -v 1.17.3
COPY Gemfile Gemfile.lock /app/

WORKDIR /app

RUN bundle install --no-cache

FROM ruby:2.4.9-alpine

RUN apk add --update --no-cache postgresql-client

COPY --from=GEMS /usr/local/bundle/ /usr/local/bundle/

COPY . /app/

WORKDIR /app

ENTRYPOINT ["bundle", "exec"]
CMD ["rackup"]
