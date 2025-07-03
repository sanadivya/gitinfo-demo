# Use Node.js LTS base image
FROM node:20-slim

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

EXPOSE 8080

CMD ["npm", "start"]