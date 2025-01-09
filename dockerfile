# Use the official Windows Server Core with Node.js 18.x
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set the working directory in the container
WORKDIR C:\usr\src\app

# Install Node.js (v18.7.0) via the MSI package for Windows
RUN powershell -Command \
    Invoke-WebRequest -Uri https://nodejs.org/dist/v18.7.0/node-v18.7.0-x64.msi -OutFile nodejs.msi; \
    Start-Process msiexec.exe -ArgumentList '/i', 'nodejs.msi', '/quiet', '/norestart' -NoNewWindow -Wait; \
    Remove-Item -Force nodejs.msi

# Copy the package.json and package-lock.json files
COPY package*.json .\

# Install app dependencies (including Playwright globally)
RUN npm install -g playwright

# Copy the rest of the application code
COPY . .\

# Install Visual Studio Code Server (code-server) by downloading and running the installer script
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/coder/code-server/releases/download/v4.14.1/code-server-4.14.1-win-x86_64.zip -OutFile code-server.zip; \
    Expand-Archive -Path code-server.zip -DestinationPath C:\code-server; \
    Remove-Item -Force code-server.zip
	
# Expose port for application
EXPOSE 9090

# Set environment variables
ENV PASSWORD=your_password_here
ENV URL=http://localhost:9090

# Command to run the application (start code-server)
CMD ["cmd", "/c", "code-server --bind-addr 0.0.0.0:9090 --auth none"]
