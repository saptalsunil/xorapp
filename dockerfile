# Use an official Node.js runtime as a parent image
FROM node:18.7.0

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Copy the downloaded tarball into the container
#COPY code-server-4.96.1-linux-amd64.tar.gz /tmp/code-server.tar.gz

# Install app dependencies
RUN npm install -g playwright

# Copy the rest of the application code
COPY . .

# Install Visual Studio Code Server
    RUN apt-get update && apt-get install -y wget

    RUN wget -v -fsSL --retry 5 https://github.com/coder/code-server/releases/download/v4.96.1/code-server-4.96.1-linux-amd64.tar.gz -O code-server.tar.gz && \
    tar -xvzf code-server.tar.gz && \
    mv code-server-*/code-server /usr/local/bin/ && \
    rm -rf code-server.tar.gz code-server-*
	
# Extract and install code-server	
#	RUN tar -xvzf /tmp/code-server.tar.gz && \
#    mv code-server-*/code-server /usr/local/bin/ && \
#    rm -rf /tmp/code-server.tar.gz code-server-*
	
# Expose port for application
EXPOSE 9090
ENV PASSWORD=your_password_here
ENV URL=http://localhost:9090

# Command to run the application
CMD ["code-server", "--bind-addr", "0.0.0.0:9090", "--auth", "none"]
