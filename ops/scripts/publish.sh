docker push omaik/kitten-store:$TAG
mkdir artifacts
cat "omaik/kitten-store:$TAG" > artifacts/docker_image.txt
