# How to execute the ETL for CMG

## Prerequisites
1. Git client is installed
2. Docker is installed
3. The HONEUR OMOP CDM database is running in a Docker container named 'postgres':
    * See https://github.com/Feder8-Platform/Honeur-Setup/blob/master/OMOPCDM/README.md for more info

## Execution steps
1. Open a terminal window 
2. Download the installation script:
    * `curl -L https://raw.githubusercontent.com/Feder8-Platform/Honeur-Setup/master/RunETLCMG/runETL.sh --output runETL.sh && chmod +x runETL.sh`
3. Execute the 'runETL.sh' script
4. The script will request for:
    * the path to the folder that contains the input CSV data files
    * the username and password to connect to the OMOP CDM database (a running Docker container named 'postgres')
    * Docker image tag, this will usually be left as the default 'current'
    * the date of last export in format "2021-06-01", with the double quotes included.
5. The script will run the ETL code and show the output of the code
6. The log file will be available in the /CMG/logs folder
