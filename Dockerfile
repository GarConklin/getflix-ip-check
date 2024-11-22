# Use the official PowerShell image as the base image
FROM mcr.microsoft.com/powershell:latest

# Set working directory
WORKDIR /scripts

# created in powershell script now
#RUN mkdir data


# Copy the PowerShell script to the container
COPY extipchange.ps1 .

# Set environment variables (these can also be passed at runtime)
ENV CHECK_INTERVAL_SECONDS="300" 
ENV GETFLIX_API_Key="replace with your getflix key"
#Getflix API Key found https://www.getflix.com.au/manage/apps

# Run the PowerShell script
CMD ["pwsh", "-File", "./extipchange.ps1"]