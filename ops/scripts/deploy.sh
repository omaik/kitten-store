 helm upgrade -i kitten-store ./ops/charts/kitten-chart -f ops/deployment/values.yml --debug --wait --set "app.version=$VERSION"
