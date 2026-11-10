#!/usr/bin/env bash
set -ex

REGISTRY=harbor.honeur.org
REPOSITORY=library
IMAGE=etl-runner
VERSION=1.1.5
TAG=$VERSION

DATA_FOLDER_HOST=${PWD}/data
LOG_FOLDER_HOST=${PWD}/log
QA_FOLDER_HOST=${PWD}/qa

echo "Pull ETL runner image"
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "Create the log and QA folders, owned by the current user"
mkdir -p "$LOG_FOLDER_HOST" "$QA_FOLDER_HOST"

echo "Download ETL questions"
curl -fsSL https://raw.githubusercontent.com/Feder8-Platform/Honeur-Setup/master/RunETLUHL/questions.json --output questions.json

touch etl-runner.env
echo "THERAPEUTIC_AREA=honeur" >> etl-runner.env
echo "REGISTRY=$REGISTRY" >> etl-runner.env
echo "LOG_LEVEL=INFO" >> etl-runner.env
echo "LOG_FOLDER_HOST=$LOG_FOLDER_HOST" >> etl-runner.env
echo "LOG_FOLDER=/var/log" >> etl-runner.env
# The ETL container runs as the host user, so it can write to the log folder and the files there belong to that user
echo "ETL_USER=$(id -u):$(id -g)" >> etl-runner.env
echo "ETL_IMAGE_NAME=etl-uhl/etl" >> etl-runner.env
echo "ETL_IMAGE_TAG=1.6.0" >> etl-runner.env
echo "DATA_FOLDER_HOST=$DATA_FOLDER_HOST" >> etl-runner.env
echo "DATA_FOLDER=/etl/data" >> etl-runner.env
echo "DATA_FILE=UHL_src_2026-10-08.xlsx" >> etl-runner.env
echo "SOURCE_RELEASE_DATE=2026-10-08" >> etl-runner.env
echo "DATA_SHEET=MM 2012 onwards" >> etl-runner.env
echo "QA_FOLDER_HOST=$QA_FOLDER_HOST" >> etl-runner.env
echo "RUN_DQD=false" >> etl-runner.env
#echo "SCRIPT_UUID=9719aeb1-84c4-49c5-a2a1-c6ea3af00305" >> etl-runner.env
#echo "DATA_SET=" >> etl-runner.env

echo "Run ETL"
docker run -it --rm --name etl-runner \
--env-file etl-runner.env \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ${PWD}/questions.json:/script/questions.json \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "End of ETL run"
rm -rf etl-runner.env
