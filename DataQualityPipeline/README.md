# How to execute the Data Quality Pipeline

## Prerequisites
1. The local installation for HONEUR is installed and running
2. The user has access to the HONEUR Harbor repository

## Execution steps
1. Open a terminal window
2. Download the 'Data Quality Pipeline' run script:
    * Linux:
      ```
       curl -L https://raw.githubusercontent.com/Feder8-Platform/Honeur-Setup/master/DataQualityPipeline/run-data-quality-pipeline.sh --output run-data-quality-pipeline.sh  && chmod +x run-data-quality-pipeline.sh
      ```
    * Windows:
      ```
      curl -L https://raw.githubusercontent.com/Feder8-Platform/Honeur-Setup/master/DataQualityPipeline/run-data-quality-pipeline.cmd --output run-data-quality-pipeline.cmd
      ```
3. Execute the script (from the directory where the script is downloaded)
    * Linux:
      ```
      ./run-data-quality-pipeline.sh
      ```
    * Windows:
      ```
      run-data-quality-pipeline.cmd
      ```
4. The script will run the Data Quality Pipeline (version 1.12) and show the output of each step
5. The result files will be available in a subfolder 'qa', the log files in a subfolder 'logs'

## Result
At the end, the pipeline prints a summary with the status of every step:
* `SUCCEEDED`: the step completed
* `FAILED`: the step returned an error; the other steps still run
* `SKIPPED`: the step was not run because a step it depends on failed

The script exits with a non-zero exit code when a step failed or was skipped.
Please share the summary and the log file from the 'logs' folder when reporting an issue.

## Variants
* `run-data-quality-pipeline-54.sh` / `.cmd`: falls back to OMOP CDM 5.4 when the CDM version can't be detected from the database
* `run-data-quality-pipeline-54-offline.sh`: for sites without internet access; the pipeline image and the images of all its steps must be loaded locally beforehand
* `run-data-quality-pipeline-2.sh`: sets `OPENBLAS_CORETYPE=Generic`, for hosts whose CPU isn't detected by OpenBLAS
* `run-data-quality-pipeline-SMC.sh`: excludes Achilles analyses 724, 824 and 1824
