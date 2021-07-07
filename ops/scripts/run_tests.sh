ENV_FILE=ops/compose/test.env docker-compose  run app bundle exec rake db:create db:schema:load
ENV_FILE=ops/compose/test.env docker-compose run app bundle exec rspec
