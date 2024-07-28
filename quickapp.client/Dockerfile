# Use the official Node.js image as the base image
FROM node:19

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install the project dependencies
RUN npm install

# Copy the entire Angular project to the working directory
COPY . .

# Build the Angular application
RUN npm run build --prod

# Set the working directory to the built Angular app
WORKDIR /app/dist/quickapp.client/browser

# Expose the port the app runs on
EXPOSE 4200

# Start the Angular application using ng serve
CMD ["npx", "ng", "serve", "--host", "0.0.0.0", "--port", "4200", "--disable-host-check", "true"]
