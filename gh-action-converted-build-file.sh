#!/bin/bash

set -euo pipefail

# Define environment variables
PULL_IMAGE_REGISTRY="ghcr.io/ublue-os"
PUSH_IMAGE_REGISTRY="ghcr.io/jehuamanna"
BASE_IMAGE_NAME="kinoite"
BASE_IMAGE_FLAVOR="nvidia"
FEDORA_VERSION="41"
KERNEL_FLAVOR="bazzite"
KERNEL_VERSION="6.12.9-203.bazzite.fc41.x86_64"
CONTAINER_TARGET="bazzite-nvidia"
IMAGE_FLAVOR="main"
IMAGE_NAME="imba-os"
SHA_HEAD_SHORT=$(git rev-parse --short HEAD)
VERSION_TAG="unstable-${FEDORA_VERSION}-${SHA_HEAD_SHORT}"
RECHUNK_IMAGE="ghcr.io/hhd-dev/rechunk:v1.1.1"

# # Pull required images
# echo "Pulling base images..."
# podman pull $PULL_IMAGE_REGISTRY/$BASE_IMAGE_NAME-$BASE_IMAGE_FLAVOR:$FEDORA_VERSION
# podman pull $PULL_IMAGE_REGISTRY/akmods:$KERNEL_FLAVOR-$FEDORA_VERSION-$KERNEL_VERSION
# podman pull $PULL_IMAGE_REGISTRY/akmods-nvidia:$KERNEL_FLAVOR-$FEDORA_VERSION-$KERNEL_VERSION
# 
# # Verify images with cosign
# # echo "Verifying images with cosign..."
# # cosign verify \
# #   --key https://raw.githubusercontent.com/ublue-os/$BASE_IMAGE_FLAVOR/main/cosign.pub \
# #   $PULL_IMAGE_REGISTRY/$BASE_IMAGE_NAME-$BASE_IMAGE_FLAVOR:$FEDORA_VERSION
# # 
# # cosign verify \
# #   --key https://raw.githubusercontent.com/ublue-os/akmods/main/cosign.pub \
# #   $PULL_IMAGE_REGISTRY/akmods:$KERNEL_FLAVOR-$FEDORA_VERSION-$KERNEL_VERSION
# # 
# # cosign verify \
# #   --key https://raw.githubusercontent.com/ublue-os/akmods/main/cosign.pub \
# #   $PULL_IMAGE_REGISTRY/akmods-nvidia:$KERNEL_FLAVOR-$FEDORA_VERSION-$KERNEL_VERSION
# 
# # Build the container image
# echo "Building the container image..."
# sudo buildah build \
#   --target $CONTAINER_TARGET \
#   --build-arg IMAGE_NAME=$IMAGE_NAME \
#   --build-arg IMAGE_FLAVOR=$IMAGE_FLAVOR \
#   --build-arg KERNEL_FLAVOR=$KERNEL_FLAVOR \
#   --build-arg KERNEL_VERSION=$KERNEL_VERSION \
#   --build-arg FEDORA_VERSION=$FEDORA_VERSION \
#   --build-arg SHA_HEAD_SHORT=$SHA_HEAD_SHORT \
#   --tag raw-img .
# 
# # Pull and run the rechunker
# echo "Pulling and running rechunker..."
# podman pull $RECHUNK_IMAGE
# podman run --rm \
#   -v $(pwd):/workspace \
#   -e RECHUNK=$RECHUNK_IMAGE \
#   -e REF="raw-img" \
#   -e PREV_REF="" \
#   -e VERSION_TAG="$VERSION_TAG" \
#   $RECHUNK_IMAGE
# 
# # Log in to the registry
echo "Logging in to GHCR..."
sudo podman login ghcr.io -u jehuamanna --password ""

# Push the image to GHCR
echo "Pushing the image to GHCR..."
echo $PUSH_IMAGE_REGISTRY/$IMAGE_NAME:$VERSION_TAG
sudo podman tag localhost/raw-img:latest $PUSH_IMAGE_REGISTRY/$IMAGE_NAME:$VERSION_TAG
sudo podman push $PUSH_IMAGE_REGISTRY/$IMAGE_NAME:$VERSION_TAG

# Sign the container image (optional)
#echo "Signing the image..."
#cosign sign \
 # --key <path-to-your-private-key> \
  # $PUSH_IMAGE_REGISTRY/$IMAGE_NAME:$VERSION_TAG

# Completion message
echo "Build and push process completed successfully!"
