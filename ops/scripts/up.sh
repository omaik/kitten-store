ENV_FILE=ops/compose/${ENVIRONMENT:-dev}.env docker-compose up -d
ENV_FILE=ops/compose/${ENVIRONMENT:-dev}.env docker-compose run -d app ops/scripts/migrate.sh
