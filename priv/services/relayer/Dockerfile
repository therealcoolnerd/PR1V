FROM node:20-alpine
WORKDIR /app
COPY priv/services/relayer/package*.json ./
RUN npm install --production
COPY priv/services/relayer .
EXPOSE 3000
CMD ["node", "index.ts"]
