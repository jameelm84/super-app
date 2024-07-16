# Use an official Node.js runtime as the base image
FROM node:18

# Install Docker
RUN apt-get update && apt-get install -y docker.io

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
