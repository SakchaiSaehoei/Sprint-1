# Stage 1 : Build the Next.js app
FROM node:14 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package.json package-lock.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the app's source code to the container
COPY . .

# Build the Next.js app for production
# RUN npm run build

EXPOSE 3000

CMD ["node", "index.js"]