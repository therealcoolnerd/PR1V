FROM node:20-alpine
WORKDIR /app
COPY priv/services/zk-prover/package*.json ./
RUN npm install
COPY priv/services/zk-prover .
# Choose one approach: either ts-node or compile with tsc
# Option 1: Use ts-node (simpler for development)
RUN npm install -g ts-node
EXPOSE 3002
CMD ["ts-node", "index.ts"]

# Option 2: Compile with tsc (better for production)
# RUN npm install typescript -g
# COPY tsconfig.json ./
# RUN tsc
# EXPOSE 3002
# CMD ["node", "dist/index.js"]
