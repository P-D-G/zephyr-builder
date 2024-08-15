FROM debian:stable-slim as base

ARG ZEPHYR_SDK_VERSION=0.16.8
ARG ZEPHYR_SDK_OPTIONS=""
ARG ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk-${ZEPHYR_SDK_VERSION}
ENV ZEPHYR_SDK_DIR="${ZEPHYR_SDK_INSTALL_DIR}"

# OS dependencies and packages

RUN \
  apt-get -y update \
  && apt-get -y install --no-install-recommends \
  ccache \
  cmake \
  device-tree-compiler \
  dfu-util \
  file \
  gcc \
  gcc-multilib \
  g++-multilib \
  git \
  gperf \
  libmagic1 \
  libsdl2-dev \
  make \
  ninja-build \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-tk \
  python3-wheel \
  wget \
  xz-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN pip install --break-system-packages --no-cache-dir wheel west \
  && pip install --break-system-packages -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/main/scripts/requirements.txt \
  && pip install --break-system-packages -r https://raw.githubusercontent.com/mcu-tools/mcuboot/main/scripts/requirements.txt
RUN export sdk_file_name="zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-$(uname -m)_minimal.tar.xz" \
  && wget -q "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/${sdk_file_name}" \
  && mkdir -p ${ZEPHYR_SDK_INSTALL_DIR} \
  && tar -xvf ${sdk_file_name} -C ${ZEPHYR_SDK_INSTALL_DIR} --strip-components=1 \
  && ${ZEPHYR_SDK_INSTALL_DIR}/setup.sh -c ${ZEPHYR_SDK_OPTIONS} \
  && rm ${sdk_file_name}
