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
    Invoke-WebRequest -Uri https://github.com/coder/code-server/releases/download/v4.14.1/code-server-4.14.1-win-x86_64.zip -OutFile code-server.zip; \
    Expand-Archive -Path code-server.zip -DestinationPath C:\code-server; \
    Remove-Item -Force code-server.zip

# Expose port for application
EXPOSE 9090
ENV PASSWORD=your_password_here
ENV URL=http://localhost:9090

# Set the working directory to the code-server folder
WORKDIR C:\\code-server

# Command to run the application
CMD ["cmd", "/c", "C:\\code-server\\code-server.exe", "--bind-addr", "0.0.0.0:9090", "--auth", "none"]
