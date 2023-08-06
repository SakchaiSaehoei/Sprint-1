# https://www.youtube.com/watch?v=dtLpWR98HfE&t=2s
# Stage 1 : Build the Next.js app
FROM node:latest
# RUN mkdir -p /home/app/ && chown -R node:node/home/app
# Set the working directory in the container
WORKDIR /app
# COPY --chown=node:node . .
# Copy package.json and package-lock.json to the container
# USER node
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the app's source code to the container
COPY . .

# Build the Next.js app for production
RUN npm run build

EXPOSE 49153

CMD ["npm", "run", "dev"]
# CMD ["yarn", "start"]