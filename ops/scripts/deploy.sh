 helm upgrade -i kitten-store ./ops/charts/kitten-chart \
  -f ops/deployment/values.yml \
  --debug \
  --wait \
  --namespace $NAMESPACE \
  --set "app.version=$VERSION" \
  --set "app.image=$DOCKER_IMAGE" \
  --set "database_url=$DATABASE_URL" \
