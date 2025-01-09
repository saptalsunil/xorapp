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
    # Download code-server tarball
    RUN wget -v -fsSL --retry 5 https://github.com/coder/code-server/releases/download/v4.96.1/code-server-4.96.1-linux-amd64.tar.gz -O code-server.tar.gz && \
	echo "Download complete" && \
	
	# Check the file type to ensure it's a valid tar.gz
    file code-server.tar.gz && \
	
	# Extract the tarball
	tar -xvzf code-server.tar.gz && \
	echo "Extraction complete" && \
	
    # Move the extracted code-server binary to the correct location	
    mv code-server-*/code-server /usr/local/bin/ && \
	echo "Binary moved to /usr/local/bin/" && \
	
	# Clean up the tarball and extracted directory
    rm -rf code-server.tar.gz code-server-* && \
	 echo "Cleanup complete"
	
	
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
