#!/bin/bash
source .env
TAG="${1:-latest}"
export NODE_RED_VERSION=$(grep -oE "\"node-red\": \"(\w*.\w*.\w*.\w*.\w*.)" package.json | cut -d\" -f4)

echo "#########################################################################"
echo "node-red version: ${NODE_RED_VERSION}"
echo "#########################################################################"

docker buildx build \
    --build-arg ARCH=amd64 \
    --build-arg NPM_TOKEN=${NPM_TOKEN} \
    --build-arg NODE_VERSION=16 \
    --build-arg NODE_RED_VERSION=${NODE_RED_VERSION} \
    --build-arg OS=alpine \
    --build-arg BUILD_DATE="$(date +"%Y-%m-%dT%H:%M:%SZ")" \
    --build-arg TAG_SUFFIX=minimal \
    --network=host \
    --file Dockerfile.custom \
    --platform linux/amd64,linux/arm64/v8 \
    --push \
    --tag kadzaa/private:${TAG} .
