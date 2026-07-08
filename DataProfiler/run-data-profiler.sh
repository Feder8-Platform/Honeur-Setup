#!/usr/bin/env bash
set -e

REGISTRY=harbor.honeur.org
REPOSITORY=distributed-analytics
IMAGE=data-profiler
VERSION=latest
TAG=$VERSION

docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

# Pre-create with write access for the container's non-root user (feder8,
# uid 54321) — otherwise Docker creates it root-owned/755 on first mount
# and save_results() fails with PermissionError.
mkdir -p ${PWD}/data_profiler_results
chmod o+w ${PWD}/data_profiler_results

docker run --rm --name data-profiler \
-v ${PWD}/data_profiler_results:/script/data_profiler_results \
--env THERAPEUTIC_AREA=HONEUR \
--env INDICATION=mm \
--env SCRIPT_UUID=30220b6a-a1c2-4e72-8ad3-f0873f53908b \
--env LOG_LEVEL=INFO \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG
