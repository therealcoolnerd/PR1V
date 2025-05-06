FROM node:18-alpine

WORKDIR /app

COPY services/threat-db/package*.json ./
RUN npm install

COPY services/threat-db/ ./

EXPOSE 3001
CMD ["npm", "start"]