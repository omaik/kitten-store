ENV_FILE=ops/compose/${ENVIRONMENT:-dev}.env docker-compose run app ops/scripts/$1.sh
