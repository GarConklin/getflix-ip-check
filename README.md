# Docker container running powershell that checks for external IP change and updates Getflix Registered IP
CREATED BY: Gar Conklin
2024-11-21 

Example from docker logs `n
2024-11-22 10:17:56 Starting... `n
2024-11-22 10:17:56 Using API key: b2caeaff-3e2e-211c-e422-bba24758671
2024-11-22 10:17:56 data\ exists
2024-11-22 10:17:57 IP loaded from data\ip-saved.txt - last saved ip: 129.222.99.253
2024-11-22 10:17:57 No change in IP. Current IP is still 129.222.99.253
2024-11-22 10:17:57 Sleeping for 300 seconds
2024-11-22 10:23:17 No change in IP. Current IP is still 129.222.99.253
2024-11-22 10:23:17 Sleeping for 300 seconds
2024-11-22 10:28:37 No change in IP. Current IP is still 129.222.99.253
2024-11-22 10:28:37 Sleeping for 300 seconds

## **Docker**
- Image: mcr.microsoft.com/powershell
- OS/ARCH
  - linux/amd64
  - Ubuntu 22.04
    - PS_VERSION=7.4.2

  
- Tags:mcr.microsoft.com/powershell:latest

## **Github Repo**  
garconklin/getflix-ip-check
- https://hub.docker.com/r/garconklin/getflix-ip-check
---



## **Dockerfile**


## Powershell Script used


## **Built-In  Example**
environment:  
    CHECK_INTERVAL_SECONDS=300    # default number of seconds to recheck ecternal IP
    GETFLIX_API_Key=  Getflix API Key found https://www.getflix.com.au/manage/apps


PULL
docker pull garconklin/getflix-ip-check:1.0

BUILD
docker build -t getflix-ip-check .

VOLUME 
#contains log files for changed IP and the ip-saved.txt containing the external IP maps to internal
/script/data   


RUN From
Examples:

{Windows PowerShell}
docker run -d -rm --name getflix-ip-check-cont -e CHECK_INTERVAL_SECONDS=300 -e GETFLIX_API_Key="b2caeaff-3e2e-211c-e422-bba24758671" -v ${pwd}\data:/scripts/data garconklin/getflix-ip-check:1.0

{Linux}
docker run -d -rm --name getflix-ip-check-cont -e CHECK_INTERVAL_SECONDS=300 -e GETFLIX_API_Key="b2caeaff-3e2e-211c-e422-bba24758671" -v $(pwd)/data:/scripts/data garconklin/getflix-ip-check:1.0


