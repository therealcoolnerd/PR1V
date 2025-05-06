FROM node:18-alpine

WORKDIR /app

COPY services/relayer/package*.json ./
RUN npm install

COPY services/relayer/ ./

EXPOSE 3003
CMD ["npm", "start"]