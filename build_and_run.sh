#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME="isaac-sim:6.0-dev"
CONTAINER_NAME="isaac-sim"

docker build -t "${IMAGE_NAME}" "${SCRIPT_DIR}"

xhost +local:docker

mkdir -p ~/docker/isaac-sim/cache/{ov,glcache,computecache}
mkdir -p ~/docker/isaac-sim/{logs,config,data,documents}

docker run -it --rm \
    --name "${CONTAINER_NAME}" \
    --network host \
    --gpus all \
    --runtime=nvidia \
    -e DISPLAY="${DISPLAY}" \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -e ACCEPT_EULA=Y \
    -e PRIVACY_CONSENT=Y \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "${HOME}/.Xauthority:/root/.Xauthority:ro" \
    -v /usr/share/vulkan/icd.d/nvidia_icd.json:/etc/vulkan/icd.d/nvidia_icd.json:ro \
    -v "${SCRIPT_DIR}:/workspace/isaacsim:rw" \
    -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim/config:/root/.nvidia-omniverse/config:rw \
    -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim/documents:/root/Documents:rw \
    -v /dev/shm:/dev/shm \
    "${IMAGE_NAME}"