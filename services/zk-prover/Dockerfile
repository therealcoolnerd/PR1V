FROM node:18-alpine

WORKDIR /app

COPY services/zk-prover/package*.json ./
RUN npm install

COPY services/zk-prover/ ./

EXPOSE 3002
CMD ["npm", "start"]