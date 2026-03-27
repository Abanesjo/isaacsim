FROM nvidia/opengl:1.2-glvnd-runtime-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential gcc-11 g++-11 \
        git git-lfs cmake \
        python3 python3-pip rsync \
        libvulkan1 libvulkan-dev vulkan-tools \
        libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev \
        libxkbcommon-dev libxkbcommon-x11-0 \
        libgl1-mesa-dev libegl1-mesa-dev libglu1-mesa \
        libatomic1 libgomp1 libsm6 libxt6 \
        libfreetype-dev libfontconfig1 \
        openssl libssl-dev libasound2 \
        curl wget ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 200 \
 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 200

RUN mkdir -p /etc/vulkan/icd.d && \
    echo '{"file_format_version":"1.0.0","ICD":{"library_path":"libGLX_nvidia.so.0","api_version":"1.3.0"}}' \
    > /etc/vulkan/icd.d/nvidia_icd.json

ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV ACCEPT_EULA=Y
ENV PRIVACY_CONSENT=Y
ENV OMNI_KIT_ALLOW_ROOT=1

WORKDIR /workspace/isaacsim

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]