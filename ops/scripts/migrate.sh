ENV_FILE=ops/compose/dev.env docker-compose run app bundle exec rake db:create db:migrate
