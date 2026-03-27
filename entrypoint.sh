#!/bin/bash
set -e

BUILD_DIR="/workspace/isaacsim/_build/linux-x86_64/release"

if [ ! -d "${BUILD_DIR}" ]; then
    echo "=== Building Isaac Sim (first run, this takes a while)... ==="
    cd /workspace/isaacsim
    git lfs install
    git lfs pull
    ./build.sh -r --skip-compiler-version-check
    echo "=== Build complete ==="
fi

cd "${BUILD_DIR}"
exec "$@"