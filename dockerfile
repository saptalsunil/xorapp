# Use an official Node.js runtime as a parent image
FROM node:18.7.0

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install app dependencies
RUN npm install -g playwright

# Copy the rest of the application code
COPY . .

# Install Visual Studio Code Server
Invoke-WebRequest -Uri "https://github.com/coder/code-server/archives/refs/tags/v.4.96.1.zip" -OutFile "code-server.zip"; \
    Expand-Archive -Path "code-server.zip" -DestinationPath "C:\\code-server"; \
    Remove-Item -Force "code-server.zip"; \
	
# Set proper permissions for the code-server directory
    icacls "C:\\code-server" /grant "Users":(OI)(CI)F /T

# Expose port for application
EXPOSE 9090
ENV PASSWORD=your_password_here
ENV URL=http://localhost:9090

# Command to run the application
CMD ["code-server", "--bind-addr", "0.0.0.0:9090", "--auth", "none"]
