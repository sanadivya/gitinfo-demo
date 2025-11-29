# Use Node.js LTS base image
FROM node:20.19.6-alpine3.21

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

EXPOSE 8080

CMD ["npm", "start"]