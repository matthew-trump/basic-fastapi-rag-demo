#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <ecr_repository_url> <tag>"
  exit 1
fi

ECR_URL="$1"
TAG="$2"

echo "Building and pushing linux/amd64 image to: ${ECR_URL}:${TAG}"
docker buildx build \
  --platform linux/amd64 \
  -t "${ECR_URL}:${TAG}" \
  -f docker/Dockerfile \
  --push \
  .
echo "Done."
