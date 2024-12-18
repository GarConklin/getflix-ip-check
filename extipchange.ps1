#Created by Gar Conklin
# 2024-11-21
# get extranl IP and check to see if it changed from the registered ip in Getflix

# Get the environment variables for file path and sleep time
$filePath = "data\"
$savedipfile = "ip-saved.txt"
$loadfile = $filePath + $savedipfile

#$sleepTime = 60
$sleepTime = [int]$env:CHECK_INTERVAL_SECONDS

# GETFLIX API Key 
$apikey = [string]$env:GETFLIX_API_Key

# Initialize variable to store the last IP
$lastIP = ""

$URI = "https://www.getflix.com.au/api/helper/ip-address/"+$apikey

Write-host "Starting..."
Write-host "Using API key: $apikey"

# get external IP and write to save file
function GetWrite-ExtIP {
		$lastIP = ((Invoke-RestMethod -Uri  https://www.getflix.com.au/api/v1/check.json).clientIp).trim()
		$lastIP | out-file $loadfile
	return "$lastIP"
}

# Function to generate a log file name based on current date and time
function Get-LogFileName {
    $currentDateTime = Get-Date -Format "yyyyMMdd-HHmmssfff"
    return "$filePath\$currentDateTime.log"
}

# Function to log messages to a file
function Log-Message {
    param (
        [string]$message
    )
    $logFile = Get-LogFileName
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    
    # Write to log file
    Add-Content -Path $logFile -Value $logEntry
    Write-Host "Logged: $logEntry"
}

# Function to check for IP changes
function Check-IPChange {
	# $currentIP = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()
	$currentIP = ((Invoke-RestMethod -Uri  https://www.getflix.com.au/api/v1/check.json).clientIp).trim()

    # Compare current IP with the last known IP
    if ($currentIP -ne $lastIP) {
        $logMessage = "IP has changed from $lastIP to $currentIP"
        Log-Message $logMessage

        Write-host "Updating Getflix registered IP to $currentIP"
		Invoke-RestMethod -Uri $URI
		
		#Update external IP and save
		#$lastIP = ((Invoke-WebRequest ifconfig.me/ip).Content.Trim())
		$lastIP = GetWrite-ExtIP
		Write-host "Updating $loadfile with current ip: $lastIP "
		
    } else {
        Write-Host "No change in IP. Current IP is still $currentIP"
    }
}

# start Program here

if ($apikey -eq "replace with your getflix key") {
	write-host "forgot your Getflix API key"
	write-host 'add -e GETFLIX_API_Key="yourkeyhere" to the docker run`n`n'
} Else {

	# Ensure the log folder exists
	if (-not (Test-Path $filePath)) {
		New-Item -Path $filePath -ItemType Directory#
		Write-host "$filePath missing! - creating"
	} else { 
		Write-host "$filePath exists"
	}

	# Ensure ip-saved.txt exists and load contents or if not create it
	if (-not (Test-Path $loadfile)) {
		 # $lastIP  = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()
		 $lastIP = GetWrite-ExtIP
		 Write-host "$loadfile missing! - creating with current ip: $lastIP "
	}
	else { 
	     # load last ip
         # Read the file content (assuming the file contains the IP only)
		 $lastIP = [string](get-content -Path $loadfile).trim()
		 Write-host "IP loaded from $loadfile - last saved ip: $lastIP"
	}


	# Run the check every specified interval
	while ($true) {
		Check-IPChange
		Write-host "Sleeping for $sleepTime seconds"
		Start-Sleep -Seconds $sleepTime
	}
}