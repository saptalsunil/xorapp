# Use an official Node.js runtime as a parent image
FROM node

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json example.test.js ./
COPY chromium.zip /root/.cache/ms-playwright/chromium.zip
COPY code-server-4.96.2-linux-arm64.tar.gz /tmp/
# Set environment variable for offline browser installation 
ENV PLAYWRIGHT_BROWSERS_PATH=/root/.cache/ms-playwright 
# Extract the Chromium ZIP file 
RUN mkdir -p /root/.cache/ms-playwright && \
unzip /root/.cache/ms-playwright/chromium.zip -d /root/.cache/ms-playwright && \ 
rm /root/.cache/ms-playwright/chromium.zip

# Extract the tarball to /usr/local
RUN tar -xzC /usr/local -f /tmp/code-server-4.96.2-linux-arm64.tar.gz --strip-components=1

# Install app dependencies
RUN npm install -g playwright
RUN npm install
RUN npx playwright install
RUN apt-get update && apt-get install -y \
    libnss3 \
	libglib2.0-0 \
	libnss3 libx11-6 \
	libxkbfile1 \
	libxss1 \
	libgdk-pixbuf2.0-0 \
	libatk1.0-0 \
	libatk-bridge2.0-0 \
	libcups2 \
	libpango-1.0-0 \
	libgdk-pixbuf2.0-0 \
	libx11-xcb1 \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    && rm -rf /var/lib/apt/lists/*
RUN npm cache clean --force
RUN npx playwright install-deps
RUN echo '{ "browsers": ["chromium"] }' > /root/.cache/ms-playwright/playwright.config.json
RUN npx playwright test --browser=chromium --version
#RUN npx playwright install chromium

# Copy the rest of the application code
COPY . .

# Install Visual Studio Code Server
#RUN curl -fsSL -IL https://code-server.dev/install.sh | sh
#RUN rmdir /usr/local/lib/node_modules/code-server/
#RUN npm install -g code-server
#RUN code-server
#RUN curl -fsSL https://github.com/coder/code-server/releases/download/v4.96.2/code-server-4.96.2-linux-arm64.tar.gz | tar -xzC /usr/local --strip-components=1

RUN if [ -d /usr/local/lib/node_modules/code-server ]; then rmdir /usr/local/lib/node_modules/code-server/; fi



# Expose port for application
#EXPOSE 9090
#ENV PASSWORD=your_password_here
#ENV URL=http://localhost:9090

# Command to run the application
#CMD ["code-server", "--bind-addr", "0.0.0.0:9090", "--auth", "none"]
CMD ["npx", "playwright", "test"]