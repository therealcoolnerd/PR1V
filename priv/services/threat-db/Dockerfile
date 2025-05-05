FROM node:20-alpine
WORKDIR /app
COPY priv/services/threat-db/package*.json ./
RUN npm install --production
COPY priv/services/threat-db .
EXPOSE 3000
CMD ["node", "index.ts"]
