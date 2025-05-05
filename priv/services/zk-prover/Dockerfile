FROM node:20-alpine
WORKDIR /app
COPY priv/services/zk-prover/package*.json ./
RUN npm install --production
COPY priv/services/zk-prover .
EXPOSE 3000
CMD ["node", "index.ts"]
