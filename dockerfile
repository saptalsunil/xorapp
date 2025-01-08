# Use an official Node.js runtime as a parent image
FROM node:18.7.0

# Set environment variables for code-server installation
ENV CODE_SERVER_VERSION=v4.96.2  

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install app dependencies
RUN npm install -g playwright

# Copy the rest of the application code
COPY . .

# Install Visual Studio Code Server
    Invoke-WebRequest -Uri "https://github.com/coder/code-server/archive/refs/tags/${env:CODE_SERVER_VERSION}.zip" -OutFile "code-server-${env:CODE_SERVER_VERSION}.zip"; \
    If ($?) { \
        Write-Host "Download successful"; \
        # Check if the zip file exists before trying to extract
        If (Test-Path "code-server-${env:CODE_SERVER_VERSION}.zip") { \
            Expand-Archive -Path "code-server-${env:CODE_SERVER_VERSION}.zip" -DestinationPath "C:\\code-server"; \
            Remove-Item -Force "code-server-${env:CODE_SERVER_VERSION}.zip"; \
            Write-Host "Code-server extracted successfully"; \
        } Else { \
            Write-Host "Code-server zip file does not exist"; exit 1; \
        } \
    } Else { \
        Write-Host "Download failed"; exit 1; \
    }; \
	
# Set proper permissions for the code-server directory
    If (Test-Path "C:\\code-server") { \
        icacls "C:\\code-server" /grant "Users":(OI)(CI)F /T; \
    } Else { \
        Write-Host "Code-server directory does not exist"; exit 1; \
    }


# Expose port for application
EXPOSE 9090
ENV PASSWORD=your_password_here
ENV URL=http://localhost:9090

# Command to run the application
CMD ["C:\\code-server\\code-server.exe", "--bind-addr", "0.0.0.0:9090", "--auth", "none"]
