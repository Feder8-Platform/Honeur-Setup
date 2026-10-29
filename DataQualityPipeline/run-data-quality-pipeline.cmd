@ECHO off
SETLOCAL

SET REGISTRY=harbor.honeur.org
SET REPOSITORY=distributed-analytics
SET IMAGE=data-quality-pipeline
SET VERSION=1.12
SET TAG=%VERSION%
SET QA_FOLDER_HOST=%CD%\qa
SET LOG_FOLDER_HOST=%CD%\logs
SET LOG_FOLDER=/var/log/dqp

IF NOT EXIST "%QA_FOLDER_HOST%" MKDIR "%QA_FOLDER_HOST%"
IF NOT EXIST "%LOG_FOLDER_HOST%" MKDIR "%LOG_FOLDER_HOST%"

ECHO Docker login @ %REGISTRY%
docker login %REGISTRY% || EXIT /B 1
docker pull %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG% || EXIT /B 1

docker run --rm --name data-quality-pipeline ^
 --env "REGISTRY=%REGISTRY%" ^
 --env THERAPEUTIC_AREA=honeur ^
 --env INDICATION=mm ^
 --env "QA_FOLDER_HOST=%QA_FOLDER_HOST%" ^
 --env "LOG_FOLDER_HOST=%LOG_FOLDER_HOST%" ^
 --env "LOG_FOLDER=%LOG_FOLDER%" ^
 --env SCRIPT_UUID=2d05ad3b-7f71-404b-840c-af346a4ef572 ^
 -v /var/run/docker.sock:/var/run/docker.sock ^
 -v "%LOG_FOLDER_HOST%:%LOG_FOLDER%" ^
 --network feder8-net ^
 %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG%
SET EXIT_CODE=%ERRORLEVEL%

ECHO.
ECHO Results: %QA_FOLDER_HOST%
ECHO Logs:    %LOG_FOLDER_HOST%
IF NOT "%EXIT_CODE%"=="0" ECHO The Data Quality Pipeline finished with failed or skipped steps, exit code %EXIT_CODE%. See the summary at the end of the output above, or the log file in %LOG_FOLDER_HOST%.
EXIT /B %EXIT_CODE%
