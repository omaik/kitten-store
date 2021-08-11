ENV_FILE=ops/compose/${ENVIRONMENT:-dev}.env docker-compose run app ops/scripts/migrate.sh
ENV_FILE=ops/compose/${ENVIRONMENT:-dev}.env docker-compose up -d
