# Use Jenkins as the base image
FROM jenkins/jenkins:lts-jdk17

# Switch to root user to install necessary software
USER root

# Install Docker and Node.js
RUN apt-get update && \
    apt-get install -y docker.io && \
    curl -sL https://deb.nodesource.com/setup_17.x | bash - && \
    apt-get install -y nodejs

# Switch back to the jenkins user
USER jenkins

# Set the working directory to the app folder
WORKDIR /node

# Copy package.json file into the container
COPY package.json .

# Install dependencies inside the container
RUN npm install

# Copy the rest of the code into the container
COPY . .

# Run the node server with server.js file
CMD ["node", "server.js"]

# Expose the service on PORT 3000
EXPOSE 3000
