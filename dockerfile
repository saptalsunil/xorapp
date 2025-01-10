# Use an official Node.js runtime as a parent image
FROM node:18.7.0

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json example.test.js ./

# Install app dependencies
RUN npm install -g playwright

# Copy the rest of the application code
COPY . .

# Install Visual Studio Code Server
RUN apt-get update && apt-get install -y curl
RUN curl -fsSL -IL https://raw.githubusercontent.com/cdr/code-server/main/install.sh


# Expose port for application
EXPOSE 9090
ENV PASSWORD=your_password_here
ENV URL=http://localhost:9090

# Command to run the application
CMD ["code-server", "--bind-addr", "0.0.0.0:9090", "--auth", "none"]