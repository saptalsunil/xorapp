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
    RUN powershell -Command \
    Invoke-WebRequest -Uri "https://github.com/coder/code-server/archive/refs/tags/v4.96.2.zip" -OutFile "code-server-4.96.2.zip"; \
    Expand-Archive -Path "code-server-4.96.2.zip" -DestinationPath "C:\\code-server"; \
    Remove-Item -Force "code-server-4.96.2.zip"; \
	
# Set proper permissions for the code-server directory
    icacls "C:\\code-server" /grant "Users":(OI)(CI)F /T

# Expose port for application
EXPOSE 9090
ENV PASSWORD=your_password_here
ENV URL=http://localhost:9090

# Command to run the application
CMD ["C:\\code-server\\code-server.exe", "--bind-addr", "0.0.0.0:9090", "--auth", "none"]
