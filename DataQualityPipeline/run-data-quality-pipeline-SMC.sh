#!/usr/bin/env bash
set -euo pipefail

REGISTRY=harbor.honeur.org
REPOSITORY=distributed-analytics
IMAGE=data-quality-pipeline
VERSION=1.12
TAG=$VERSION

LOG_FOLDER_HOST=${PWD}/logs
LOG_FOLDER=/var/log/dqp
QA_FOLDER_HOST=${PWD}/qa
ENV_FILE=data-quality-pipeline.env

# The pipeline hands ownership of the qa folder to the feder8 user (UID 54321)
# of the hardened data quality scripts, so it needs no chmod here (a chmod
# would fail on a rerun, as the folder is then no longer owned by this user)
mkdir -p "$LOG_FOLDER_HOST" "$QA_FOLDER_HOST"
chmod o+w "$LOG_FOLDER_HOST"

echo "Docker login @ $REGISTRY"
docker login "$REGISTRY"
docker pull "$REGISTRY/$REPOSITORY/$IMAGE:$TAG"

trap 'rm -f "$ENV_FILE"' EXIT
cat > "$ENV_FILE" <<EOF
REGISTRY=$REGISTRY
THERAPEUTIC_AREA=honeur
INDICATION=mm
QA_FOLDER_HOST=$QA_FOLDER_HOST
LOG_FOLDER_HOST=$LOG_FOLDER_HOST
LOG_FOLDER=$LOG_FOLDER
EXCLUDED_ANALYSIS_IDS=724,824,1824
SCRIPT_UUID=2d05ad3b-7f71-404b-840c-af346a4ef572
EOF

exit_code=0
docker run \
  --rm \
  --name data-quality-pipeline \
  --env-file "$ENV_FILE" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$LOG_FOLDER_HOST:$LOG_FOLDER" \
  --network feder8-net \
  "$REGISTRY/$REPOSITORY/$IMAGE:$TAG" || exit_code=$?

echo
echo "Results: $QA_FOLDER_HOST"
echo "Logs:    $LOG_FOLDER_HOST"
if [ "$exit_code" -ne 0 ]; then
  echo "The Data Quality Pipeline finished with failed or skipped steps (exit code $exit_code)." >&2
  echo "See the summary at the end of the output above, or the log file in $LOG_FOLDER_HOST." >&2
fi
exit "$exit_code"
