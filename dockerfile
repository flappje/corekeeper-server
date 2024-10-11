######## BUILDER ########

# Set the base image
FROM steamcmd/steamcmd:ubuntu-24 AS builder

## install game + steam sdk
RUN steamcmd +force_install_dir /home/corekeeper-server +login anonymous +app_update 1007 validate +app_update 1963720 validate +quit

######## INSTALL ########

# Set the base image
FROM ghcr.io/linuxserver/baseimage-ubuntu:noble

# set version label
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="flappje"

# environment settings
ENV \
  WORLD_INDEX=0 \
  WORLD_NAME="Core Keeper Server" \
  WORLD_SEED=0 \
  WORLD_MODE=0 \
  GAME_ID="" \
  DATA_PATH="/config" \
  MAX_PLAYERS=10 \
  SEASON=-1 \
  SERVER_IP="" \
  SERVER_PORT="" \
  LD_LIBRARY_PATH="/corekeeper-server/linux64/"

# Install prerequisites
RUN \
  echo "start" \
  && apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
    libxi6 \
    xvfb \
  \
  ## clean up
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Copy steamcmd files from builder
COPY --from=builder /home/corekeeper-server /corekeeper-server

# copy local files
COPY --chmod=0755 root/ /

# ports and volumes
VOLUME /config
