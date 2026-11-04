@ECHO off

SET REGISTRY=harbor.honeur.org
SET REPOSITORY=distributed-analytics
SET IMAGE=data-profiler
SET VERSION=latest
SET TAG=%VERSION%

docker pull %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG%
docker run --rm --name data-profiler -v %CD%/data_profiler_results:/script/data_profiler_results --env THERAPEUTIC_AREA=HONEUR --env INDICATION=mm --env SCRIPT_UUID=2d05ad3b-7f71-404b-840c-af346a4ef572 --env LOG_LEVEL=INFO --network feder8-net %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG%
