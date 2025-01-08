# Use an official Node.js runtime as a parent image
FROM node:18.7.0

# Set environment variables for code-server installation
#ENV CODE_SERVER_VERSION=v4.96.2  

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install app dependencies
RUN npm install -g playwright

# Copy the rest of the application code
COPY . .

# Install Visual Studio Code Server
  RUN powershell -Command \
    # Set Execution Policy to allow script execution \
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; \
    # Install Visual C++ Redistributable (required for running code-server on Windows) \
    Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vc_redist.x64.exe" -OutFile "vc_redist.x64.exe"; \
    Start-Process -Wait -FilePath "vc_redist.x64.exe" -ArgumentList '/quiet', '/norestart'; \
    Remove-Item -Force "vc_redist.x64.exe"; \
    # Install curl if it's not already present \
    Invoke-WebRequest -Uri "https://curl.se/windows/dl-7.79.0_1/curl-7.79.0-win64-mingw.zip" -OutFile "curl.zip"; \
    Expand-Archive -Path "curl.zip" -DestinationPath "C:\\curl"; \
    Remove-Item -Force "curl.zip"; \
    # Download and install code-server
    Invoke-WebRequest -Uri "https://github.com/coder/code-server/archive/refs/tags/${env:CODE_SERVER_VERSION}.zip" -OutFile "code-server.zip"; \
    # Check for success and extract the zip file if the download was successful \
    If ($?) { \
        Write-Host "Download successful"; \
        Expand-Archive -Path "code-server.zip" -DestinationPath "C:\\code-server"; \
        Remove-Item -Force "code-server.zip"; \
        Write-Host "Code-server extracted successfully"; \
    } Else { \
        Write-Host "Download failed"; exit 1; \
    }; \
    # Set proper permissions for the code-server directory \
    If (Test-Path "C:\\code-server") { \
        icacls "C:\\code-server" /grant "Users":(OI)(CI)F /T; \
    } Else { \
        Write-Host "Code-server directory does not exist"; exit 1; \
    }

# Expose port for application
EXPOSE 9090
ENV PASSWORD=your_password_here
ENV URL=http://localhost:9090

# Set the working directory to the code-server folder
WORKDIR C:\\code-server

# Command to run the application
CMD ["C:\\code-server\\code-server.exe", "--bind-addr", "0.0.0.0:9090", "--auth", "none"]
